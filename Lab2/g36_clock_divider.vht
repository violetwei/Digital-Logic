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
-- Generated on "03/19/2019 17:11:30"
                                                            
-- Vhdl Test Bench template for design  :  g36_clock_divider
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY g36_clock_divider_vhd_tst IS
END g36_clock_divider_vhd_tst;
ARCHITECTURE g36_clock_divider_arch OF g36_clock_divider_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL en_out : STD_LOGIC;
SIGNAL enable : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT g36_clock_divider
	PORT (
	enable : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	clk : IN STD_LOGIC;
	en_out : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : g36_clock_divider
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	en_out => en_out,
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


	WAIT FOR 5 ns;
	FOR i IN 0 to 1000000 LOOP -- test to ensure that wraps correctly when reach 0
		clk <= '0'; -- Toggle clock back to 0
		reset <= '1'; -- Maintains reset at 1 (active-low)
		enable <= '1'; -- Maintains enable at 1 (active-low)
		
		if(i > 20 and i < 30) then -- Sets enable to 1 to freeze clock
			enable <= '0'; -- Test synchronously
		end if;
		
		if (i = 35) then
			reset <= '0'; -- Test reset back to 499.999, asynchronous
		end if;
		
		
		WAIT FOR 10 ns; -- Rising edge
		clk <= '1';
		WAIT FOR 10 ns; -- Falling edge

	END LOOP;
WAIT;                                                        
END PROCESS always;                                          
END g36_clock_divider_arch;
