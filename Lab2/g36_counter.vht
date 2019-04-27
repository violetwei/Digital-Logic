-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/19/2019 14:12:08"
                                                            
-- Vhdl Test Bench template for design  :  g36_counter
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY g36_counter_vhd_tst IS
END g36_counter_vhd_tst;
ARCHITECTURE g36_counter_arch OF g36_counter_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL count : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL enable : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT g36_counter
	PORT (
	clk : IN STD_LOGIC;
	count : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	enable : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : g36_counter
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	count => count,
	enable => enable,
	reset => reset
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN 
   reset <= '0'; -- Initialize all values
	clk <= '0';
	enable <= '1';


	WAIT FOR 5 ms;
	FOR i IN 0 to 50 LOOP -- test to ensure that wraps correctly
		clk <= '0'; -- Toggle clock back to 0
		reset <= '1'; -- Maintains reset at 1 (active0low)
		enable <= '1'; -- Maintains enable at 1 (active-low)
		
		if(i > 20 and i < 30) then -- Sets enable to 1 to freeze clock
			enable <= '0'; -- Test synchronously
		end if;
		
		if (i = 35) then
			reset <= '0'; -- Test reset back to 0, asynchronous
		end if;
		
		
		WAIT FOR 5 ms; -- Rising edge
		clk <= '1';
		WAIT FOR 5 ms; -- Falling edge

	END LOOP;
WAIT;                                                        
END PROCESS always;                                          
END g36_counter_arch;
