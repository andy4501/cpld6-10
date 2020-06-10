library ieee;
use ieee.std_logic_1164.all;

entity slowCLK is
 generic(divisor:integer:=50000000);    
port(  clockIN : in  std_logic;
           clockOUT: out std_logic); 
end slowCLK;
architecture arch of slowCLK is
signal PULSE : std_logic;
begin
---------- clk divider ---------------
process(clockIN)
variable counter,divisor2 : integer range 0 to divisor;
begin
  divisor2:=divisor/2;
----------- up counter -----------------
    if (clockIN 'event and clockIN ='1') then
      if counter = divisor then
        counter := 1;
      else
        counter := counter + 1;
      end if;
    end if;
  ----- clk generator -----
    if (clockIN 'event and clockIN ='1') then
      if (( counter= divisor2) or (counter = divisor))then
        PULSE <= not PULSE ;
      end if;
    end if;
    clockOUT <= PULSE ;
  end process;
end arch;
