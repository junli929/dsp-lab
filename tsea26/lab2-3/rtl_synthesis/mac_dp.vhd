library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_dp is
  
  port (
    clk_i            : in  std_logic;
    reset_i          : in  std_logic;
    c_scalefactor    : in  std_logic_vector(2 downto 0);
    c_macop          : in  std_logic_vector(3 downto 0);
    c_dosat          : in  std_logic;
    mac_operanda     : in  signed(39 downto 0);  -- From ACR/RF
    mac_operandb     : in  signed(39 downto 0);  -- From ACR/RF
    mul_opa_reg      : in  signed(16 downto 0);  -- From multiplier
    mul_opb_reg      : in  signed(16 downto 0);  -- From multiplier
    scale_overflow   : out std_logic;
    sat_flag         : out std_logic;   -- 1 if data was saturated
    mac_result       : out signed(39 downto 0);  -- macunit output data
    add_pos_overflow : out std_logic;   -- positive overflow
    add_neg_overflow : out std_logic);  -- negative overflow

end mac_dp;


architecture mac_dp_rtl of mac_dp is
  signal mul_sig : signed(33 downto 0);

  signal adder_opb, adder_opa, to_scaling, adder_result, mul_guarded_reg,
         abs_result, round_result, from_scaling : signed(39 downto 0);
  signal adder_cin : std_logic;

  signal add_pos_overflow1, add_pos_overflow2 : std_logic;
  signal add_neg_overflow1, add_neg_overflow2 : std_logic;

  --signal c_dornd, c_doabs : std_logic;
  signal c_invopb, c_opbsel : std_logic_vector(1 downto 0);
  signal c_opasel : std_logic_vector(2 downto 0);
  signal tmp, tmp2 : signed(40 downto 0);


  component mac_scale
    port (
      scale_overflow : out  std_logic;
      from_scaling   : out  signed(39 downto 0);
      to_scaling     : in signed(39 downto 0);
      c_scalefactor  : in  std_logic_vector(2 downto 0));
  end component;

  component saturation
    port (
      value_i   : in  signed(39 downto 0);
      do_sat_i  : in  std_logic;
      value_o   : out signed(39 downto 0);
      did_sat_o : out std_logic);
  end component;
  
begin  -- behav

  -- purpose: Control table for the MAC
  -- type   : combinational
  ctrl_table: process (c_macop)
  begin  -- process ctrl_table
    case c_macop is
	-----------------------------------------------------------------------------------------------------
	when "0000" => c_invopb <= "00"; c_opasel <= "000"; c_opbsel <= "00";  -- CLR
	when "0001" => c_invopb <= "00"; c_opasel <= "001"; c_opbsel <= "01";  -- ADD
	when "0010" => c_invopb <= "01"; c_opasel <= "001"; c_opbsel <= "01";  -- SUB
	when "0011" => c_invopb <= "01"; c_opasel <= "001"; c_opbsel <= "01";  -- CMP
	when "0100" => c_invopb <= "01"; c_opasel <= "000"; c_opbsel <= "01";  -- NEG
	-----------------------------------------------------------------------------------------------------
	when "0101" => c_invopb <= "10"; c_opasel <= "000"; c_opbsel <= "01";  -- ABS
	-----------------------------------------------------------------------------------------------------
	when "0110" => c_invopb <= "00"; c_opasel <= "000"; c_opbsel <= "10"; -- MUL
	when "0111" => c_invopb <= "00"; c_opasel <= "001"; c_opbsel <= "10"; -- MAC
	when "1000" => c_invopb <= "01"; c_opasel <= "001"; c_opbsel <= "10"; -- MDM
	-----------------------------------------------------------------------------------------------------
	when "1001" => c_invopb <= "00"; c_opasel <= "000"; c_opbsel <= "01"; -- MOVE
	when "1010" => c_invopb <= "00"; c_opasel <= "010"; c_opbsel <= "01"; -- MOVE_ROUND
	-----------------------------------------------------------------------------------------------------
	when others => c_invopb <= "00"; c_opasel <= "000"; c_opbsel <= "00"; -- NOP
	-----------------------------------------------------------------------------------------------------
    end case;
  end process ctrl_table;

   --  Operation descriptions
   --    CLR:  mac_result = 0
   --    ADD:  mac_result = mac_operanda + mac_operandb
   --    SUB:  mac_result = mac_operanda - mac_operandb
   --    CMP:  mac_result = mac_operanda - mac_operandb
   --    NEG:  mac_result = 0 - mac_operandb
   --    ABS:  mac_result = abs(mac_operandb)
   --    MUL:  mac_result = mul_opa * mul_opb
   --    MAC:  mac_result = mac_operanda + mul_opa * mul_opb
   --    MDM:  mac_result = mac_operanda - mul_opa * mul_opb
   --    MOVE: mac_result = mac_operandb
   --    MOVE_ROUND: mac_result = round(mac_operandb)
   --    NOP:  mac_result = 0

  -----------------------------------------------------------------------------
  -- Multiplier
  mul_sig <= mul_opa_reg * mul_opb_reg;

  -- purpose: Pipeline stage for the multiplier result
  -- type   : sequential
  mulpipe: process (clk_i)
  begin  -- process mulpipe
    if rising_edge(clk_i) then
      if reset_i = '0' then
        mul_guarded_reg <= (others => '0');
      else
        mul_guarded_reg <= (39 downto 34 => mul_sig(33)) & mul_sig;
      end if;
    end if;
  end process mulpipe;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Create OpA to adder
  with c_opasel select
    adder_opa <=
    (others => '0') when "000",
    (X"0000008000") when "010",
    mac_operanda    when others;
  -----------------------------------------------------------------------------

  
  -----------------------------------------------------------------------------
  -- Create OpB temporary value before scaling
  with c_opbsel select
    to_scaling <=
    (others => '0') when "00",
    mac_operandb    when "01",
    mul_guarded_reg when others;
  -----------------------------------------------------------------------------

  
  -----------------------------------------------------------------------------
  -- Scaling stuff
  scaling : mac_scale
        port map (scale_overflow => scale_overflow,
                  from_scaling   => from_scaling,
                  to_scaling     => to_scaling,
                  c_scalefactor  => c_scalefactor);
  -----------------------------------------------------------------------------


  
  -----------------------------------------------------------------------------
  -- Invert OpB if necessary
  with c_invopb select
    adder_cin <=
    '0' when "00",
    from_scaling(39) when "10",
    '1' when others;
    
  --
  with adder_cin select
    adder_opb <=
    from_scaling when '0',
    not from_scaling     when others;
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- The adder itself
  tmp <= adder_opa + adder_opb + ((40 downto 1 => '0') & adder_cin);
  adder_result <= tmp(39 downto 0);
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Take the absolute value if necessary
  --absolute: process (c_doabs, adder_result)
  --begin  -- process absolute
  --  abs_result <= adder_result;
  --if c_doabs = '1' then
  --  if adder_result(39) = '1' then
  --    abs_result <= not adder_result + 1;
  --  end if;
  --end if;
  --end process absolute;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Round the value if necessary
  --rounding: process (c_dornd, abs_result)
  --begin  -- process rounding
    --round_result <= abs_result;
    --if c_dornd = '1' then
      --if abs_result(15) = '1' then
        --round_result <= (abs_result(39 downto 16) & X"0000") + 65536;
      --end if;
    --end if;
  --end process rounding;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Create some overflow flag related signals
  add_pos_overflow1 <= (not adder_opa(39) and not adder_opb(39) and adder_result(39));
  add_pos_overflow2 <= '1' when ((c_opasel = "010") and (from_scaling = x"7fffffffff")) else '0';
  add_pos_overflow <= add_pos_overflow1 or add_pos_overflow2;
  add_neg_overflow1 <= (adder_opa(39) and adder_opb(39) and not adder_result(39));
  add_neg_overflow2 <= '1' when ((c_invopb = "10") and (from_scaling = x"8000000000")) else '0';
  add_neg_overflow <= add_neg_overflow1 or add_neg_overflow2;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Saturation handling is done in a separate module that you need to edit!
  sat_box : saturation port map (
    value_i   => adder_result,
    do_sat_i  => c_dosat,
    value_o   => mac_result,
    did_sat_o => sat_flag);
  -----------------------------------------------------------------------------
  
end architecture mac_dp_rtl;
