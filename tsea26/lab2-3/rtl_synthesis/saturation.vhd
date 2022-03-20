library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

                                                                        
entity saturation is
  port (
    value_i   : in  signed(39 downto 0);
    do_sat_i  : in  std_logic;
    value_o   : out signed(39 downto 0);
    did_sat_o : out std_logic);
end saturation;

architecture saturation_rtl of saturation is
begin  -- saturation_rtl
process(value_i,do_sat_i)
begin
    if do_sat_i = '0' then
        value_o <= value_i;
        did_sat_o <= '0';
    else
   -- elsif do_sat_i = '1'then
        if (value_i(39 downto 31) /="000000000") and (value_i(39 downto 31) /= "11111111") then
            if value_i(39) = '0'then
                value_o <= x"007fffffff";
                did_sat_o <= '1';
            else
                value_o <= x"ff80000000";
                did_sat_o <= '1';
            
            end if;
        else
        value_o <= value_i;
        did_sat_o <= '0';
        end if;
    end if;    
end process;  
end saturation_rtl;
