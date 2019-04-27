library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g36_clock_divider is
  Port(	enable	: in std_logic;
			reset		: in std_logic;
			clk		: in std_logic;
			en_out	: out std_logic);
end g36_clock_divider;

architecture clock_divider	of g36_clock_divider is
signal countdownTemp : unsigned(18 downto 0); -- Needs to store numbers from 0 to 499,999
begin
  process(clk, reset) begin -- detects changes in clock or reset, automatically executes below
  
  if (reset = '0') then -- When reset is 0, resets clock signal to 499,999 (asynchronous behavior)
      countdownTemp <= "1111010000100011111"; -- 499,999 in binary
		en_out <= '0'; -- Sets en_out to 0 when resets
		
  elsif (rising_edge(clk)) then -- Everything below only occurs if rising edge of clock detected (synchronous)
    
	 
	 if (enable = '1') then -- Enable is active-low, if it is 1, clock counts down normally
	   if (countdownTemp = 1) then
			countdownTemp <= countdownTemp - 1;
			en_out <= '1'; -- Will set en_out to 1 on the next clock cycle, occurs when countdownTemp is 0 (since decremented in line before)
		elsif (countdownTemp = 0) then
			countdownTemp <= "1111010000100011111"; -- If countdownTemp = 0, reset to 499,999 otherwise decrement (syncrhonous)
			en_out <= '0'; -- When goes back to 499,999, en_out goes to 0
		else
			countdownTemp <= countdownTemp - 1; -- If not one of the conditions, simply decrements countdownTemp
			en_out <= '0'; -- Maintains en_out as 0

		end if;
   
	 else -- If enable is not 1, then maintains current clock count
	   countdownTemp <= countdownTemp;
	 end if;
	 

  end if;
  end process;
end clock_divider;
