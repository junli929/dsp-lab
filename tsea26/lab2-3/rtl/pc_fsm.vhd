library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pc_fsm is
  port
    (
      clk_i, reset_i:    in std_logic;
      jump_decision_i:    in std_logic; 
      lc_pfc_loop_flag_i: in std_logic; 
      lc_pfc_loope_i:     in std_logic_vector(15 downto 0);
      ctrl_i:             in std_logic_vector(5 downto 0);
      interrupt:          in std_logic; 
      pc_addr_bus_i:      in std_logic_vector(15 downto 0);

      pfc_pc_add_opa_sel_o:  out std_logic;
      pfc_lc_loopn_sel_o:    out std_logic;
      pfc_pc_sel_o:          out std_logic_vector(2 downto 0);
      pfc_inst_nop_o:        out std_logic);
end pc_fsm;

architecture pc_fsm_rtl of pc_fsm is

  signal ctrl_c1              : std_logic_vector(5 downto 0);
  signal ctrl_c2              : std_logic_vector(5 downto 0);
  signal ctrl_c3              : std_logic_vector(5 downto 0);
  signal s0_state_sel         : std_logic_vector (2 downto 0);
  signal jump_case_sel        : std_logic_vector (1 downto 0);
  signal ctrl_i_PFC_JUMP             : std_logic;
  signal ctrl_c2_PFC_RET             : std_logic;
  signal ctrl_i_PFC_DELAY_SLOT       : std_logic_vector (1 downto 0);

  type StateType is (s0,s1,s3,s4,s5,s6,s7,s8,s9,s10,s13);
  signal next_state           : StateType;
  signal state                : StateType;

begin

  ctrl_i_PFC_DELAY_SLOT <= ctrl_i(4 downto 3);
  ctrl_i_PFC_JUMP <= ctrl_i(2);
  ctrl_c2_PFC_RET <= ctrl_c2(1);
  
--  register generation logic
  process (clk_i)
  begin
    if clk_i'event and clk_i = '1' then
      if  ( reset_i = '0' ) then
        state <= s0 ;
      else
        ctrl_c1 <= ctrl_i ;
        ctrl_c2 <= ctrl_c1 ;
        ctrl_c3 <= ctrl_c2 ;
        state <= next_state ;
      end if;
    end if;
  end process;

--  next state logic

  s0_state_sel <=  ctrl_i_PFC_JUMP & ctrl_i_PFC_DELAY_SLOT;
  
  process (s0_state_sel, state, ctrl_i)
  begin
    next_state <= s0 ;
    case  state  is
      when s0 =>
        case s0_state_sel is
          when "100" =>
            next_state <= s4; -- What is the next state? jump,ds=0
          when "101" =>
            next_state <= s5; -- What is the next state? jump,ds=1
          when "110" =>
            next_state <= s3; -- What is the next state? jump,ds=2
          when "111" =>
            next_state <= s1;  -- jump,ds=3
          when others =>
            next_state <= s0;
        end case;
      when s1 =>
        next_state <= s7 ;
      when s3 =>
        next_state <= s6 ;
      when s4 =>
        next_state <= s8 ;
      when s5 =>
        next_state <= s8 ;
      when s6 =>
        next_state <= s10 ;
      when s7 =>
        next_state <= s9 ;
      when s8 =>
        next_state <= s10 ;
      when s9 =>
        
        case ctrl_c3(1) is
            when '1' =>
                next_state <= s13;  --ret = 1
            when others =>
                next_state <= s0;
        end case;
      when s10 =>
        
        case ctrl_c3(1) is
            when '1' => --ret = 1
                next_state <= s13;
            when others =>
                next_state <= s0;
        end case;      
      when s13 =>
        next_state <= s0 ;
      when others =>
        next_state <= s0;
    end case;
  end process;

--  output logic

  jump_case_sel <= ctrl_c2_PFC_RET & jump_decision_i;
  
  process (state, jump_case_sel, s0_state_sel, ctrl_c3)
  begin
    pfc_pc_add_opa_sel_o <= '0';  --Default value
    pfc_pc_sel_o<= "001";         --Default value
    pfc_inst_nop_o<='0';	  --Default value
    pfc_lc_loopn_sel_o<='0';   --Default value
    case  state  is
      when s0 =>
        case s0_state_sel is
            when "100" =>
                pfc_pc_sel_o <= "000";-- to s4, no nop insert
            when others =>
        end case;
      when s1 =>
        -- Empty
      when s3 =>
        -- Empty
      when s4 =>
        pfc_pc_sel_o <= "000"; --pc no update
        pfc_inst_nop_o <= '1';  --nop insert
      when s5 =>
        pfc_pc_sel_o <= "000";--pc no update, no nop insert
      when s6 =>
        case  jump_case_sel is
            when "10" | "11" =>     -- ret
            pfc_pc_sel_o <= "000";
            when "01" =>
            pfc_pc_sel_o <= "011"; --jump
            when "00" =>    --no jump & ret
            pfc_pc_sel_o <= "000";
            when others => --Empty
        end case;
      when s7 =>
        case  jump_case_sel is
          when "10" | "11" =>   -- ret
            pfc_pc_sel_o <= "000";
          when "01" =>  --jump
            pfc_pc_sel_o <= "011";
          when "00" =>  --no jump & ret
            pfc_pc_sel_o <= "001";
          when others => --Empty
        end case;
      when s8 =>
        -- Your code here
        case  jump_case_sel is
          when "10" | "11"=>    --ret
            pfc_pc_sel_o <= "000";
            pfc_inst_nop_o <= '1';
          when "01" =>  --jump
            pfc_pc_sel_o <= "011";
            pfc_inst_nop_o <= '1';
          when "00" =>  --no jump & ret
            pfc_pc_sel_o <= "000";
            pfc_inst_nop_o <= '1';
          when others => --Empty
        end case;
      
      when s9 =>
        case ctrl_c3(1) is
            when '1' => --ret
                pfc_pc_sel_o <= "110";
            when '0' =>
            when others =>
        end case;
      
      when s10 =>
        case ctrl_c3(1) is
            when '1' => --ret
                pfc_pc_sel_o <= "110";
                pfc_inst_nop_o <= '1';
            when '0' =>
                pfc_pc_sel_o <= "001";
                pfc_inst_nop_o <= '1';
            when others =>    
        end case;
      when s13 =>
        pfc_pc_sel_o <= "001";
        pfc_inst_nop_o <= '1';
      when others =>
    end case;
  end process;

--  case: default


end pc_fsm_rtl;
