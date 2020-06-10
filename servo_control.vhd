 library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_arith.all;
 use ieee.std_logic_unsigned.all;
 entity servo_control is
   generic (divisor: integer :=500);
   port(
        clk : in  std_logic;
        BTN : in  std_logic_vector(7 downto 0);
        q: out std_logic );
 end servo_control;
 architecture a of servo_control is
   signal clk1   : std_logic;  --new clk : 100000Hz
   signal cnt2   : std_logic;
   signal data   : integer range 0 to 230;
   signal period : integer range 0 to 1999; --2000 x 0.01ms = 20ms
 begin
  ----- clk divider, generate 100000Hz frequence, 0.01ms -----
   process (clk)
     variable cnt1     : integer range 0 to divisor;
     variable divisor2 : integer range 0 to divisor;
  begin
     divisor2 := divisor/2; 
if (clk'event and clk='1') then
       if cnt1=divisor then
         cnt1 := 1;
       else
         cnt1 := cnt1 + 1;
       end if;	
     end if;
 
     if (clk'event and clk='1') then
       if (( cnt1=divisor2) or (cnt1=divisor)) then	
         cnt2 <= not cnt2;
       end if;
     end if;
     clk1<=  cnt2 ;
   end process;
   process(clk1)
   begin
     case BTN is  
       when "00000000" => data <= 70;  --  70(0.7ms)  => 0 degree
       when "00000001" => data <= 80; -- 110(1.1ms) => 45 degree
       when "00000010" => data <= 90;
       when "00000011" => data <= 100; -- 150(1.5ms) => 90 degree
       when "00000100" => data <= 110;
       when "00000101" => data <= 120;
       when "00000110" => data <= 130;
       when "00000111" => data <= 140; -- 190(1.9ms) => 135 degree
       when "00001000" => data <= 150;
       when "00001001" => data <= 160;
       when "00001010" => data <= 170;
       when "00001011" => data <= 180;
       when "00001100" => data <= 190;
       when "00001101" => data <= 200;
       when "00001110" => data <= 210;
       when "00001111" => data <= 220;
       when "00010000" => data <= 230;
       when others => null;
     end case;
   end process;
   ----- up counter -----
   process(clk1,period)
   begin
     if clk1'event and clk1= '1' then
       period <= period + 1;
     end if;
   end process;
   q <= '1' when period < data else '0';
 end a; 
