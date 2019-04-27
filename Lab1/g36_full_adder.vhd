
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity g36_full_adder is -- Entity for full adder
	Port (A1 : in std_logic; -- First bit to add
			B1 : in std_logic; -- Second bit to add
			cin : std_logic;   -- Carry int
			s : out std_logic; -- Sum 
			cout : out std_logic); -- Carry out
end g36_full_adder;

architecture fa of g36_full_adder is
begin 
s <= A1 XOR B1 XOR cin; -- Calculates sum
cout <= (A1 and B1) OR (cin and A1) or (cin AND B1); -- Calculate carry out
end fa;
