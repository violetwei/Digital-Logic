library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g36_7_segment_decoder is -- Entity for 7 segment decoder
	Port ( code : in std_logic_vector(3 downto 0); -- Input (binary)
	segments : out std_logic_vector(6 downto 0)); -- Output (7 seg display)
end g36_7_segment_decoder;  

architecture g36_7_segment_arch of g36_7_segment_decoder is -- Architecture of decoder
begin
with code select -- Uses selected signal assignment
segments <= "1000000" WHEN "0000", -- For 1-14, sets hexadecmial
				"1111001" WHEN "0001", -- 6 is in the first position, 0 is last position (on diagram)
				"0100100" WHEN "0010",
				"0110000" WHEN "0011",
				"0011001" WHEN "0100",
				"0010010" WHEN "0101",
				"0000010" WHEN "0110",
				"1111000" WHEN "0111",
				"0000000" WHEN "1000",
				"0010000" WHEN "1001",
				"0001000" WHEN "1010",
				"0000011" WHEN "1011",
				"1000110" WHEN "1100",
				"0100001" WHEN "1101",
				"0000110" WHEN "1110",
				"0001110" WHEN others; -- Should only occur when 15
end g36_7_segment_arch;