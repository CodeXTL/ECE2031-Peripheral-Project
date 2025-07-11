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
	TYPE MODE_TYPE IS ( m_segment, m_shape, m_shift, m_decimal );

	SIGNAL segments_mem 	: STD_LOGIC_VECTOR(41 DOWNTO 0);
	SIGNAL nio_addr		: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL mode				: MODE_TYPE;
	
BEGIN
	WITH io_addr SELECT
		mode <= 	m_segment 	WHEN "00000000011",
					m_shape		WHEN "00000000100",
					m_shift		WHEN "00000000101",
					m_decimal	WHEN "00000000110",
					m_segment 	WHEN OTHERS;
	
	-- Process block to update display output
	PROCESS (io_write, resetn)
	BEGIN
		IF (resetn = '0') THEN
			segments <= (OTHERS => '1');
		ELSIF (io_write = '1') THEN
			segments <= segments_mem;
		END IF;
	END PROCESS;
	
	-- Process block to update segments_mem
	PROCESS (mode, io_data)
	BEGIN
		CASE mode IS
			WHEN m_segment =>
				CASE io_data(9 DOWNTO 7) IS
					WHEN "000" =>	-- 1st display from right
						segments_mem(6 DOWNTO 0) <= NOT io_data(6 DOWNTO 0);
					WHEN "001" =>	-- 2nd display from right
						segments_mem(13 DOWNTO 7) <= NOT io_data(6 DOWNTO 0);
					WHEN "010" =>	-- 3rd display from right
						segments_mem(20 DOWNTO 14) <= NOT io_data(6 DOWNTO 0);
					WHEN "011" =>	-- 4th display from right
						segments_mem(27 DOWNTO 21) <= NOT io_data(6 DOWNTO 0);
					WHEN "100" =>	-- 5th display from right
						segments_mem(34 DOWNTO 28) <= NOT io_data(6 DOWNTO 0);
					WHEN "101" =>	-- 6th display from right
						segments_mem(41 DOWNTO 35) <= NOT io_data(6 DOWNTO 0);
					WHEN OTHERS =>
						NULL;
				END CASE;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS;
END arch;