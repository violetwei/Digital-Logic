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
-- Generated on "04/02/2019 14:24:51"
                                                            
-- Vhdl Test Bench template for design  :  g36_FSM
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY g36_FSM_vhd_tst IS
END g36_FSM_vhd_tst;
ARCHITECTURE g36_FSM_arch OF g36_FSM_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL count : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL direction : STD_LOGIC;
SIGNAL enable : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT g36_FSM
	PORT (
	clk : IN STD_LOGIC;
	count : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	direction : IN STD_LOGIC;
	enable : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : g36_FSM
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	count => count,
	direction => direction,
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
		-- Initialize all variables
		 direction <= '1';
 		 enable <= '1';
       reset <= '0';
		 clk <= '0';
		 
		 WAIT for 5 ms;
		 FOR i IN 0 to 100 LOOP -- Go in loop to test wraps correctly
			clk <= '0'; -- Sets clock to 0 (falling edge)
			reset <= '1'; -- Sets reset and enable to 1
			enable <= '1';
			
			if (i = 20) then -- Test opposite direction
				direction <= '0';
			end if;
		
						
			if (i = 50) then -- Test reset with falling direction
				reset <= '0';
			end if;
			
			if (i = 60) then -- Test reset with rising direction
				direction <= '1';
				reset <= '0';
			end if;
			
			if (i > 70 and i < 80) then -- Test when circuit disabled
				enable <= '0';
			end if;
			
			WAIT for 5 ms;
			clk <= '1'; -- Rising edge
			WAIT for 5 ms;
		END loop;

WAIT;                                                        
END PROCESS always;                                          
END g36_FSM_arch;
