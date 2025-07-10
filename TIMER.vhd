-- TIMER.VHD (a peripheral module for SCOMP)
-- 2003.04.24
--
-- Timer returns a 16 bit counter value with a resolution of the CLOCK period.
-- Writing any value to timer resets to 0x0000, but the timer continues to run.
-- The counter value rolls over to 0x0000 after a clock tick at 0xFFFF.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;


ENTITY TIMER IS
	PORT(
		CLOCK,
		RESETN   : IN    STD_LOGIC;
		IO_ADDR  : IN    STD_LOGIC_VECTOR(10 DOWNTO 0);
		IO_READ  : IN    STD_LOGIC;
		IO_WRITE : IN    STD_LOGIC;
		IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END TIMER;


ARCHITECTURE a OF TIMER IS
	SIGNAL COUNT     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IO_EN     : STD_LOGIC;

	BEGIN
	
	-- Use LPM function to create bidirection I/O data bus
	IO_BUS: lpm_bustri
	GENERIC MAP (
		lpm_width => 16
	)
	PORT MAP (
		data     => COUNT,
		enabledt => IO_EN,
		tridata  => IO_DATA
	);

	PROCESS (CLOCK, RESETN, IO_ADDR, IO_READ)
	BEGIN
		IF (RESETN = '0' OR ((IO_ADDR = "00000000010") AND (IO_WRITE = '1'))) THEN
			COUNT <= x"0000";
		ELSIF (rising_edge(CLOCK)) THEN
			COUNT <= COUNT + 1;
		END IF;
	END PROCESS;
	
	-- Drive IO_DATA when requested.
	IO_EN <=
		'1' WHEN (IO_ADDR = "00000000010") AND (IO_READ = '1')
		ELSE '0';

END a;

