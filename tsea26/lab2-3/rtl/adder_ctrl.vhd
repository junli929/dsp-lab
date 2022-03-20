library ieee;
use ieee.std_logic_1164.all;

entity adder_ctrl is
  port (
    function_i   : in  std_logic_vector(2 downto 0);
    opa_sign_i   : in  std_logic;
    mx_opa_inv_o : out std_logic;
    mx_ci_o      : out std_logic_vector(1 downto 0));
end adder_ctrl;

architecture adder_ctrl_rtl of adder_ctrl is
begin  -- adder_ctrl_rtl

process(function_i,opa_sign_i)
begin
if function_i ="000" then --add a+b
    mx_opa_inv_o <= '0';
    mx_ci_o <= "00";
    
elsif function_i = "001" then --addc a+b+carry
    mx_opa_inv_o <= '0';
    mx_ci_o <= "10";
    
elsif function_i = "010" then --sub b-a
    mx_opa_inv_o <= '1';
    mx_ci_o <= "01";
    
elsif function_i = "011" then --subc b-a-1+c
    mx_opa_inv_o <= '1';
    mx_ci_o <= "10";
    
elsif function_i = "100" then --abs(a)
    if opa_sign_i = '1' then
    mx_opa_inv_o <= '1';
    mx_ci_o <= "01";
    else
    mx_opa_inv_o <= '0';
    mx_ci_o <= "00";
    end if;
    
elsif function_i = "101" then --cmp         b-a
    mx_opa_inv_o <= '1';
    mx_ci_o <= "01";
    
elsif function_i = "110" then --max
    mx_opa_inv_o <= '1';
    mx_ci_o <= "01";
    
elsif function_i = "111" then --min
    mx_opa_inv_o <= '1';
    mx_ci_o <= "01";
end if;
end process;
end adder_ctrl_rtl;
