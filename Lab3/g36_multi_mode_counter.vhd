library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity g36_multi_mode_counter is
	Port (start		: in std_logic;
			stop		: in std_logic;
			direction: in std_logic;
			reset		: in std_logic;
			clk		: in std_logic;
			HEX0		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0));
end g36_multi_mode_counter;

architecture multi_mode_counter of g36_multi_mode_counter is
	component g36_clock_divider is -- declare all components needed
	  Port(	enable	: in std_logic;
			reset		: in std_logic;
			clk		: in std_logic;
			en_out	: out std_logic); -- output of clock divider (enable)
	end component;
	
	component g36_FSM is 
		Port (enable	: in std_logic;
			 reset	: in std_logic;
	       direction: in std_logic;
			 clk		: in std_logic;
			 count	: out std_logic_vector(3 downto 0)); -- outputs count
	end component;
	
	component g36_7_segment_decoder is -- Component for 7 segment decoder
			Port ( code : in std_logic_vector(3 downto 0); -- Input (binary)
			segments : out std_logic_vector(6 downto 0)); -- Output (7 seg display)
	end component;  
	
signal clock_div_en_out: std_logic; -- Signal for clock output of clock divider - clock for seconds
signal enableSignal: std_logic; -- Signal to store enable of circuit

signal countTemp : std_logic_vector(3 downto 0); -- Stores output of FSM
signal hexa0: std_logic_vector(3 downto 0) := "0001"; -- Stores output of FSM as BCD
signal hexa1: std_logic_vector(3 downto 0) := "0000"; -- Stores output of FSM as BCD
	
	
begin

-- Create instances of all 7-segment decoders needed
-- Input is output of FSM as BCD
h0 : g36_7_segment_decoder Port map (code => hexa0(3 downto 0), segments => HEX0(6 downto 0));
h1 : g36_7_segment_decoder Port map (code => hexa1(3 downto 0), segments => HEX1(6 downto 0));

-- Create instance of clock divider, enable hardset to '1' (enable button controls enable of FSM)
-- en_out set to output of clockdivider
clockDiv : g36_clock_divider 	Port map (enable => '1', reset => reset, clk => clk, en_out => clock_div_en_out);

-- Create instance of FSM, enable set to enableSignal (1 is enabled, 0 disabled), clock set to output of clock divider
-- Stores output of FSM as 4-bit binary number
fsm : g36_FSM  Port map (enable => enableSignal, reset => reset, direction => direction, clk => clock_div_en_out, count => countTemp);


-- Create process to detect changes in parameters to ensure asynchronous
process(start, stop, reset, countTemp) begin

	-- If start pressed, set enable signal to 1 to resume clock count this works synchronously on next clock count
	if (start = '0') then
		enableSignal <= '1';
	end if;

	-- If stop pressed, set enable signal to 0 to stop clock count this works synchronously on next clock count
	if (stop = '0') then
		enableSignal <= '0';
	end if;
	
	-- If countTemp is bigger than 9, convert to BCD (hexa1 set to 1 and hexa0 subtracted by 10)
	if (unsigned(countTemp) > 9) then
		hexa1 <= "0001";
		hexa0 <= std_logic_vector(unsigned(countTemp) - 10);
	else -- Otherwise, hexa1 is just 0 and hexa0 is the count
		hexa1 <= "0000";
		hexa0 <= countTemp;
	end if;
	
end process;
	
end multi_mode_counter;