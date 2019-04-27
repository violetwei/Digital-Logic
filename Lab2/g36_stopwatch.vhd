library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g36_stopwatch is
	Port (start		: in std_logic; -- Start button
	      stop		: in std_logic; -- Stop button
			reset		: in std_logic; -- Reset button
			clk		: in std_logic; -- Clock
			HEX0		: out std_logic_vector (6 downto 0); -- 7 segment decoders
			HEX1		: out std_logic_vector (6 downto 0);
			HEX2		: out std_logic_vector (6 downto 0);
			HEX3		: out std_logic_vector (6 downto 0);
			HEX4		: out std_logic_vector (6 downto 0);
			HEX5		: out std_logic_vector (6 downto 0));
end g36_stopwatch;

architecture stopwatch of g36_stopwatch is
	component g36_clock_divider is -- declare all components needed
	  Port(	enable	: in std_logic;
			reset		: in std_logic;
			clk		: in std_logic;
			en_out	: out std_logic); -- output of clock divider (enable)
	end component;
	
	component g36_counter is 
		Port (enable	: in std_logic;
	       reset	: in std_logic;
			 clk		: in std_logic;
			 count	: out std_logic_vector(3 downto 0)); -- outputs count
	end component;
	
	component g36_7_segment_decoder is -- Component for 7 segment decoder
			Port ( code : in std_logic_vector(3 downto 0); -- Input (binary)
			segments : out std_logic_vector(6 downto 0)); -- Output (7 seg display)
	end component;  
	
signal c0_centiSec: std_logic_vector(3 downto 0); -- Signal for current centiseconds
signal c1_deciSec: std_logic_vector(3 downto 0); -- Signal for current deciseconds
signal c2_second: std_logic_vector(3 downto 0); -- Signal for current seconds
signal c3_dekaSec: std_logic_vector(3 downto 0); -- Signal for current dekaseconds
signal c4_minute: std_logic_vector(3 downto 0); -- Signal for current minutes
signal c5_dekaMin: std_logic_vector(3 downto 0); -- Signal for current dekaminutes

signal clock_div_en_out: std_logic; -- Signal for clock output of clock divider (input to centisecond)
signal reset_c0: std_logic; -- Signal to reset centisecond count

signal clk_c1: std_logic; -- Signal for clock output of centisecond clock (input to decisecond)
signal reset_c1: std_logic; -- Signal to reset decisecond count

signal clk_c2: std_logic; -- Signal for clock output of decisecond clock (input to second)
signal reset_c2: std_logic; -- Signal to reset second count

signal clk_c3: std_logic; -- Signal for clock output of second clock (input to dekasecond)
signal reset_c3: std_logic; -- Signal to reset dekasecond count

signal clk_c4: std_logic; -- Signal for clock output of second clock (input to minute)
signal reset_c4: std_logic; -- Signal to reset minute count

signal clk_c5: std_logic; -- Signal for clock output of second clock (input to dekaminute)
signal reset_c5: std_logic;  -- Signal to reset dekaminute count

signal enableSignal: std_logic; -- Signal to store enable of circuit

begin

-- Create instances of all 7-segment decoders needed
-- Input is count of std_logic_vectors that store count, output is segments
dec0 : g36_7_segment_decoder Port map (code => c0_centiSec(3 downto 0), segments => HEX0(6 downto 0));
dec1 : g36_7_segment_decoder Port map (code => c1_deciSec(3 downto 0), segments => HEX1(6 downto 0));
dec2 : g36_7_segment_decoder Port map (code => c2_second(3 downto 0), segments => HEX2(6 downto 0));
dec3 : g36_7_segment_decoder Port map (code => c3_dekaSec(3 downto 0), segments => HEX3(6 downto 0));
dec4 : g36_7_segment_decoder Port map (code => c4_minute(3 downto 0), segments => HEX4(6 downto 0));
dec5 : g36_7_segment_decoder Port map (code => c5_dekaMin(3 downto 0), segments => HEX5(6 downto 0));

-- Create instance of clock divider, enable set to enableSignal (set by start and stop button)
-- en_out set to output of clockdivider
clockDiv : g36_clock_divider 	Port map (enable => enableSignal, reset => reset, clk => clk, en_out => clock_div_en_out); -- MUST CHANGE ENABLE

-- Creates all instances of counters which counts each unit
-- Enable fixed as 1, we can do this because everything depends on the clock divider, if the clock divider pauses, everything pauses
-- Reset is either set reset button or reset signals
-- We use AND since reset is active low, if either reset button or reset signal is 0, reset must be 0
-- Reset signal activated when reach max value, go back to previous value
-- Clocks set to clock signal generated by previous count
-- Count output is allocated to appropriate std_logic vector
count0 : g36_counter Port map (enable => '1', reset => reset AND reset_c0, clk => clock_div_en_out, count => c0_centiSec(3 downto 0));
count1 : g36_counter Port map (enable => '1', reset => reset AND reset_c1, clk => clk_c1, count => c1_deciSec(3 downto 0));
count2 : g36_counter Port map (enable => '1', reset => reset AND reset_c2, clk => clk_c2, count => c2_second(3 downto 0));
count3 : g36_counter Port map (enable => '1', reset => reset AND reset_c3, clk => clk_c3, count => c3_dekaSec(3 downto 0));
count4 : g36_counter Port map (enable => '1', reset => reset AND reset_c4, clk => clk_c4, count => c4_minute(3 downto 0));
count5 : g36_counter Port map (enable => '1', reset => reset AND reset_c5, clk => clk_c5, count => c5_dekaMin(3 downto 0));

-- Create process to detect changes in parameters to ensure asynchronous
process(start, stop, reset, clk, c0_centiSec, c1_deciSec, c2_second, c3_dekaSec, c4_minute, c5_dekaMin) begin

-- If start pressed, set enable signal to 1 to resume clock count this works synchronously on next clock count
if (start = '0') then
   enableSignal <= '1';
end if;

-- If stop pressed, set enable signal to 0 to stop clock count this works synchronously on next clock count
if (stop = '0') then
   enableSignal <= '0';
end if;

-- Ensures that only changes in the rising edge of the system clock
if rising_edge(clk) then
	if (c0_centiSec = "1010") then -- Once reach 10 centiseconds, reset centisecond count, toggle clock for deciseconds
		reset_c0 <= '0';
		clk_c1 <= '1';
	else
		clk_c1 <= '0';
		reset_c0 <= '1';
	end if;
		

	if (c1_deciSec = "1010") then  -- Once reach 10 deciseconds, reset decisecond count, toggle clock for seconds
		reset_c1 <= '0';
		clk_c2 <= '1';
	else
		clk_c2 <= '0';
		reset_c1 <= '1';
	end if;


	if (c2_second = "1010") then  -- Once reach 10 seconds, reset second count, toggle clock for dekaseconds
		reset_c2 <= '0';
		clk_c3 <= '1';
	else
		clk_c3 <= '0';
		reset_c2 <= '1';
	end if;


	if (c3_dekaSec = "0110") then  -- Once reach 6 dekaseconds, reset dekasecond count, toggle clock for minutes
		reset_c3 <= '0';
		clk_c4 <= '1';
	else
		clk_c4 <= '0';
		reset_c3 <= '1';
	end if;


	if (c4_minute = "1010") then   -- Once reach 10 minutes, reset minute count, toggle clock for dekaminutes
		reset_c4 <= '0';
		clk_c5 <= '1';
	else
		clk_c5 <= '0';
		reset_c4 <= '1';
	end if;


	if (c5_dekaMin = "0110") then -- Once reach 6 dekaminutes, reset dekaminute count
		reset_c5 <= '0';
	else
		reset_c5 <= '1';
	end if;

end if;

end process;
end stopwatch;

