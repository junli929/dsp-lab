library ieee;
use ieee.std_logic_1164.all;

entity min_max_ctrl is
  port (
    function_i  : in  std_logic_vector(2 downto 0);
    opa_sign_i  : in  std_logic;
    opb_sign_i  : in  std_logic;
    carry_i     : in  std_logic;
    mx_minmax_o : out std_logic);
end min_max_ctrl;

architecture min_max_ctrl_rtl of min_max_ctrl is
begin  -- min_max_ctrl_rtl
  
  process (function_i,opa_sign_i,opb_sign_i,carry_i)
  begin
  if function_i = "110" then --max
  if opa_sign_i = '0' and opb_sign_i = '1' then
  mx_minmax_o <= '0';
  elsif opa_sign_i ='1' and opb_sign_i = '1' and carry_i = '1' then
  mx_minmax_o <= '1';
  elsif opa_sign_i ='1' and opb_sign_i = '1' and carry_i = '0' then
  mx_minmax_o <= '0';
  elsif opa_sign_i ='0' and opb_sign_i = '0' and carry_i = '0' then
  mx_minmax_o <= '0';
  elsif opa_sign_i ='0' and opb_sign_i = '0' and carry_i = '1' then
  mx_minmax_o <= '1';
  else
  mx_minmax_o <= '1';
  end if;
  
  elsif function_i = "111" then --min
  if opa_sign_i ='0' and opb_sign_i ='1' then
  mx_minmax_o <= '1';
  elsif opa_sign_i ='1' and opb_sign_i = '1' and carry_i = '1' then
  mx_minmax_o <= '0';
  elsif opa_sign_i ='1' and opb_sign_i = '1' and carry_i = '0' then
  mx_minmax_o <= '1';
  elsif opa_sign_i ='0' and opb_sign_i = '0' and carry_i = '0' then
  mx_minmax_o <= '1';
  elsif opa_sign_i ='0' and opb_sign_i = '0' and carry_i = '1' then
  mx_minmax_o <= '0';
  else
  mx_minmax_o <= '0';
  end if;
end if;  
end process;  
end min_max_ctrl_rtl;
