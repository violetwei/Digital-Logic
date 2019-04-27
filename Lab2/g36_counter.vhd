library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g36_counter is
    Port (enable	: in std_logic;
	       reset	: in std_logic;
			 clk		: in std_logic;
			 count	: out std_logic_vector(3 downto 0));
end g36_counter;


architecture counter of g36_counter is
signal countTemp : unsigned(3 downto 0); -- Stores temporary count as unsigned sequence of bits
begin
  process(clk, reset) begin -- detects changes in clock or reset, automatically executes below
  
  if (reset = '0') then -- When reset is 0, resets clock signal (asynchronous behavior)
      countTemp <= "0000";
		
  elsif (rising_edge(clk)) then -- Everything below only occurs if rising edge of clock detected (synchronous)
    
	 if (enable = '1') then -- Enable is active-low, if it is 1, clock counts up normally
	   countTemp <= countTemp + 1;
   
	 else -- If enable is not 1, then maintains current clock count
	   countTemp <= countTemp;
	 end if;
  end if;
  end process;
  count <= std_logic_vector(countTemp); -- Convert unsigned signal to std_logic_vector
end counter;
	 