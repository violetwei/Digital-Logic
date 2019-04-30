library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g36_FSM is
	Port (enable	: in std_logic; -- If enable is 1, then clock enabled
			direction: in std_logic; -- Up direction is 1, down direction is 0
			reset		: in std_logic; -- Active low, if reset, and direction up, sets to 1st state, if direction down, last state
			clk		: in std_logic; -- Clock to change states
			count		: out std_logic_vector(3 downto 0)); -- Output of FSM
end g36_FSM;

architecture FSM of g36_FSM is
	type states IS (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O); -- Declares new types for all states in FSM
	signal y : states; -- Creates a new signal to store type of FSM
	signal countTemp : integer; -- Creates temporary signal to store output as integer
begin
	process(clk, reset, direction, y) begin
		if(reset = '0' AND direction = '1') then -- 1 - If reset, go to first state (if up direction)
			y <= A;
		elsif(reset = '0' AND direction = '0') then -- 9 - If reset, go to last state (if down direction)
			y <= O;
		elsif(rising_edge(clk)) then -- Changes on rising edge of clock
			case y is -- Case depending on current state of system
				when A => -- When current state
					if (enable = '1') then -- if clock enabled
						if(direction = '1') then -- If direction positive, go up state
							y <= B;
						else -- Or else, go down state
							y <= O;
						end if;
					else
						y <= A; -- If disabled, state stays the same
					end if;
				when B => -- Do this for all 15 states in the state machine
					if (enable = '1') then
						if(direction = '1') then
							y <= C; -- Next state
						else
							y <= A; -- Prior state
						end if;
					else
						y <= B; -- Don't change state
					end if;
				when C =>
					if (enable = '1') then
						if(direction = '1') then
							y <= D; -- Next state
						else
							y <= B; -- Prior state
						end if;
					else
						y <= C; -- Don't change state
					end if;
				when D =>
					if (enable = '1') then
						if(direction = '1') then
							y <= E; -- Next state
						else
							y <= C; -- Prior state
						end if;
					else
						y <= D; -- Don't change state
					end if;
				when E =>
					if (enable = '1') then
						if(direction = '1') then
							y <= F; -- Next state
						else
							y <= D; -- Prior state
						end if;
					else
						y <= E; -- Don't change state
					end if;
				when F =>
					if (enable = '1') then
						if(direction = '1') then
							y <= G; -- Next state
						else
							y <= E; -- Prior state
						end if;
					else
						y <= F; -- Don't change state
					end if;
				when G =>
					if (enable = '1') then
						if(direction = '1') then
							y <= H; -- Next state
						else
							y <= F; -- Prior state
						end if;
					else
						y <= G; -- Don't change state
					end if;
				when H =>
					if (enable = '1') then
						if(direction = '1') then
							y <= I; -- Next state
						else
							y <= G; -- Prior state
						end if;
					else
						y <= H; -- Don't change state
					end if;
				when I =>
					if (enable = '1') then
						if(direction = '1') then
							y <= J; -- Next state
						else
							y <= H; -- Prior state
						end if;
					else
						y <= I; -- Don't change state
					end if;
				when J =>
					if (enable = '1') then
						if(direction = '1') then
							y <= K; -- Next state
						else
							y <= I; -- Prior state
						end if;
					else
						y <= J; -- Don't change state
					end if;
				when K =>
					if (enable = '1') then
						if(direction = '1') then
							y <= L; -- Next state
						else
							y <= J; -- Prior state
						end if;
					else
						y <= K; -- Don't change state
					end if;
				when L =>
					if (enable = '1') then
						if(direction = '1') then
							y <= M; -- Next state
						else
							y <= K; -- Prior state
						end if;
					else
						y <= L; -- Don't change state
					end if;
				when M =>
					if (enable = '1') then
						if(direction = '1') then
							y <= N; -- Next state
						else
							y <= L; -- Prior state
						end if;
					else
						y <= M; -- Don't change state
					end if;
				when N =>
					if (enable = '1') then
						if(direction = '1') then
							y <= O; -- Next state
						else
							y <= M; -- Prior state
						end if;
					else
						y <= N; -- Don't change state
					end if;
				when O =>
					if (enable = '1') then
						if(direction = '1') then
							y <= A; -- Next state
						else
							y <= N; -- Prior state
						end if;
					else
						y <= O; -- Don't change state
					end if;
				end case;
		end if;			
		
		-- Set output
		case y is -- Depending on state, sets output (Moore state machine)
			when A =>
				countTemp <= 1;
			when B =>
				countTemp <= 2;
			when c =>
				countTemp <= 4;
			when D =>
				countTemp <= 8;
			when E =>
				countTemp <= 3;
			when F =>
				countTemp <= 6;
			when G =>
				countTemp <= 12;
			when H =>
				countTemp <= 11;
			when I =>
				countTemp <= 5;
			when J =>
				countTemp <= 10;
			when K =>
				countTemp <= 7;
			when L =>
				countTemp <= 14;
			when M =>
				countTemp <= 15;
			when N =>
				countTemp <= 13;
			when O =>
				countTemp <= 9;
		end case;
		
	end process;
	-- Converts countTemp from integer to std_logic_vector
	count <= std_logic_vector(to_unsigned(countTemp, count'length));
end FSM;