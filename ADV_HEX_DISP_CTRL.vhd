LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

-- Advanced controller offering a four distinct modes of interaction with the HEX LED display, as follows
--		1) Individual segment toggling
--		2) Shapes display mode
--		3) Left and right shift
--		4) Decimal display mode

ENTITY ADV_HEX_DISP_CTRL IS
	PORT (
		io_addr	: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		io_data	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		io_write	: IN STD_LOGIC;
		resetn 	: IN STD_LOGIC;
		segments	: OUT STD_LOGIC_VECTOR(41 DOWNTO 0)
	);
END ADV_HEX_DISP_CTRL;

ARCHITECTURE arch OF ADV_HEX_DISP_CTRL IS
	TYPE MODE_TYPE IS ( segment, shape, shift, decimal );

	SIGNAL segments_mem 	: STD_LOGIC_VECTOR(41 DOWNTO 0);
	SIGNAL nio_addr		: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL mode				: MODE_TYPE;
	
BEGIN
	WITH io_addr SELECT
		mode <= 	segment 	WHEN "0000000011",
					shape		WHEN "0000000100",
					shift		WHEN "0000000101",
					decimal	WHEN "0000000110";
	
	segments_mem <= (others => '0') WHEN (resetn = 0);
	
END arch;