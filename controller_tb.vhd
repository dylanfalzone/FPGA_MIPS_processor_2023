library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_tb is

end controller_tb;

architecture TB of controller_tb is
	signal clk				: std_logic:='0';
	signal rst				:  std_logic:='1';
	signal IR_31_26			:  std_logic_vector(31 downto 26);
	signal PCWriteCond 		:  std_logic;
	signal PCWrite			:  std_logic;
	signal IorD 			:  std_logic;
	signal MemRead			:  std_logic;
	signal MemWrite			:  std_logic;
	signal MemToReg			:  std_logic;
	signal IRWrite			:  std_logic;
	signal JumpAndLink		:  std_logic;
	signal IsSigned			:  std_logic;
	signal PcSource			:  std_logic_vector(1 downto 0);
	signal Operation_type	:  std_logic_vector(5 downto 0);
	signal AluSrcA			:  std_logic;
	signal ALUSrcB			:  std_logic_vector(1 downto 0);
	signal RegWrite			:  std_logic;
	signal RegDst			:  std_logic;
	signal IR_5_0			: std_logic_vector(5 downto 0);
	signal IR				: std_logic_vector(31 downto 0);
	signal outstate			: integer;

begin  -- TB

    UUT : entity work.controller
		port map(
			clk				=>clk,
			rst				=>rst,
			PcWriteCond		=>PcWriteCond,
			PCWrite			=>PCWrite,
			IorD			=>IorD,
			MemRead			=>MemRead,
			MemWrite		=>MemWrite,
			MemToReg		=>MemToReg,
			IRWrite			=>IRWrite,
			JumpAndLink		=>JumpAndLink,
			IsSigned		=>ISSigned,
			PCSource		=>PCSource,
			Operation_type	=>Operation_Type,
			ALuSrcA			=>ALUSrcA,
			ALUSrcB			=>ALUSrcB,
			RegWrite		=>RegWrite,
			RegDst			=>RegDst,
			IR_31_26		=>IR_31_26,
			outstate		=>outstate,
			IR_5_0			=>IR_5_0);

	clk <= not clk after 2 ns;
	
    process
    begin
	wait for 10 ns;
	rst<='0';
	wait for 10 ns;
	
	
	--lw $reg1, 30($ZERO)
	IR<="10001100000000010000000011000000";
	IR_31_26<=IR(31 downto 26);
	IR_5_0<=IR(5 downto 0);
	wait for 40 ns;
	
	--lw $reg2, 3C($ZERO)
	IR<="10001100000000100000000011110000";
	IR_31_26<=IR(31 downto 26);
	IR_5_0<=IR(5 downto 0);
	wait for 40 ns;
	

    end process;

end TB;