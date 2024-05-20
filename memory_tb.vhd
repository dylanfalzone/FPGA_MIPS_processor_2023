library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is

end memory_tb;

architecture TB of memory_tb is

	signal clk 			: std_logic  :='0';
	signal rst 			: std_logic	 :='1';
	signal addr 		: std_logic_vector(31 downto 0);
	signal rd_en 		: std_logic; --from ctrl
	signal wr_en 		: std_logic:='0'; --from ctrl
	signal inport_en	: std_logic; --from top
	signal inport_sel 	: std_logic;
	signal inport0  	: std_logic_vector(9 downto 0); --from top
	signal inport1		: std_logic_vector(9 downto 0);
	signal reg_in  		: std_logic_vector(31 downto 0);--from dp
	signal outport 		: std_logic_vector(31 downto 0);--to top
	signal outdata 		: std_logic_vector(31 downto 0); --to dp
	signal nextop 		: std_logic:='0';


begin  -- TB

    UUT : entity work.Memory
		port map(
		clk=> clk,
		rst => rst,
		addr => addr,
		rd_en=>rd_en,
		wr_en=>wr_en,
		inport_en=>InPort_en,
		inport_sel=>inport_sel,
		inport0=>Inport0,
		inport1=>Inport1,
		reg_in=>reg_in,
		outport=>outport,
		outdata=>outdata);

	clk <= not clk after 2 ns;
	rd_en<=not wr_en;
    process
    begin
	wait for 10 ns;
	rst<='0';
	wait for 10 ns;
	
	--write 0x0A0A0A0A to byte addr 0x0
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(168430090,32));
	addr	<=std_logic_vector(to_unsigned(0,32));
	wr_en	<='1';
	wait for 40 ns;
	
	--write 0xF0F0F0F0 to addr 0x04
	nextop<=not nextop;
	reg_in	<="11110000111100001111000011110000";
	addr	<=std_logic_vector(to_unsigned(4,32));
	wr_en	<='1';
	wait for 40 ns;
	
	--read 0x0A0A0A0A from byte addr 0x0
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(1,32));
	addr	<=std_logic_vector(to_unsigned(0,32));
	wr_en	<='0';
	wait for 40 ns;	
	
	--read 0x0A0A0A0A from byte addr 0x001
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(1,32));
	addr	<=std_logic_vector(to_unsigned(1,32));
	wr_en	<='0';
	wait for 40 ns;		
	
	--read 0XF0F0F0F0 from byte addr 0x004
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(1,32));
	addr	<=std_logic_vector(to_unsigned(4,32));
	wr_en	<='0';
	wait for 40 ns;	
	
	--read 0XF0F0F0F0 from byte addr 0x005
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(1,32));
	addr	<=std_logic_vector(to_unsigned(5,32));
	wr_en	<='0';
	wait for 40 ns;	
	
	--Write 0x00001111 to the outport 
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(15,32));
	addr	<="00000000000000001111111111111100";
	wr_en	<='1';
	wait for 40 ns;	
	
	--Load 0x00010000 into inport 0
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(0,32));
	inport0	<="0000010000";
	inport_sel<='0';
	inport_en<='1';
	wr_en	<='0';
	addr	<="00000000000000001111111111111000";
	wait for 10 ns;
	inport_en<='0';
	wait for 40 ns;
	
	--Load 0x00000001 into inport 1
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(0,32));
	inport1	<="0000000001";
	inport_sel<='1';
	inport_en<='1';
	wr_en	<='0';
	addr	<="00000000000000001111111111111100";
	wait for 10 ns;
	inport_en<='0';
	wait for 40 ns;

	--Read from inport 0
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(0,32));
	inport_sel<='0';
	wr_en	<='0';
	addr	<="00000000000000001111111111111000";
	wait for 40 ns;	
	
	--Read from inport 0
	nextop<=not nextop;
	reg_in	<=std_logic_vector(to_unsigned(0,32));
	inport_sel<='1';
	wr_en	<='0';
	addr	<="00000000000000001111111111111100";
	wait for 40 ns;
	
	
	
    end process;

end TB;
