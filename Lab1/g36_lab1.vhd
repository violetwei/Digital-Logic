library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g36_lab1 is
	Port(A, B 	: in std_logic_vector (4 downto 0); -- 5 bit values
			decoded_A : out std_logic_vector(13 downto 0); -- 2* 7-segment display
			decoded_B : out std_logic_vector(13 downto 0); -- 2* 7-segment display
			decoded_AplusB : out std_logic_vector(13 downto 0));  -- 2* 7-segment display
end g36_lab1;



architecture arch_add of g36_lab1 is -- Architecture of adder
	component g36_7_segment_decoder is -- Use 7 segment decoder as component
		Port ( code : in std_logic_vector(3 downto 0);
		segments : out std_logic_vector(6 downto 0));
	end component;
	component g36_full_adder is -- Use full adder as component
		Port (A1 : in std_logic;
			B1 : in std_logic;
			cin : std_logic;
			s : out std_logic;
			cout : out std_logic);
	end component;   
signal tempA: std_logic_vector(3 downto 0); -- Used to store MSB of A (concatenated with 0)
signal tempB: std_logic_vector(3 downto 0); -- Used to store MSB of B (concatenated with 0)
signal tempS: std_logic_vector(3 downto 0); -- Used to store MSB of A+B (concatenated with 0)
signal cInt : std_logic_vector(3 downto 0); -- Used to store intermediate carry
signal sums : std_logic_vector(5 downto 0); -- Used to store sums
begin
deca1 : g36_7_segment_decoder Port map ( code => A(3 downto 0), segments => decoded_A(6 downto 0)); -- Decodes least significant values A
tempA <= ("000") & (A(4)); -- Add 000 in front since max value is 1F
deca2 : g36_7_segment_decoder Port map ( code => tempA, segments => decoded_A(13 downto 7)); -- Decodes MSB

decb1 : g36_7_segment_decoder Port map ( code => B(3 downto 0), segments => decoded_B(6 downto 0)); -- Decodes least significant values B
tempB <= ("000") & (B(4)); -- Add 000 in front since max value is 1F
decb2 : g36_7_segment_decoder Port map ( code => tempB, segments => decoded_B(13 downto 7));  -- Decodes MSB

sum1 : g36_full_adder Port map ( A1 => A(0), B1 => B(0), cin => '0',       s => sums(0), cout => cInt(0)); -- Calculates all sums (sum 0 is LSB)
sum2 : g36_full_adder Port map ( A1 => A(1), B1 => B(1), cin => cInt(0), s => sums(1), cout => cInt(1));
sum3 : g36_full_adder Port map ( A1 => A(2), B1 => B(2), cin => cInt(1), s => sums(2), cout => cInt(2)); 
sum4 : g36_full_adder Port map ( A1 => A(3), B1 => B(3), cin => cInt(2), s => sums(3), cout => cInt(3)); 
sum5 : g36_full_adder Port map ( A1 => A(4), B1 => B(4), cin => cInt(3), s => sums(4), cout => sums(5)); -- Last carry out is MSB

decs1 : g36_7_segment_decoder Port map ( code => sums(3 downto 0), segments => decoded_AplusB(6 downto 0)); -- Decodes least significant values sum
tempS <= ("00") & (sums(5)) & (sums(4)); -- Add 00 in front since max value is 1F, concatenate carry and sum
decs2 : g36_7_segment_decoder Port map ( code => tempS, segments => decoded_AplusB(13 downto 7)); -- Decodes MSB
 
end arch_add;





