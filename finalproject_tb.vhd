library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity finalproject_tb is

end finalproject_tb;

architecture TB of finalproject_tb is

		signal  PCWriteCond : std_logic;
		signal  PCWrite     : std_logic;
		signal  IorD        : std_logic;
		signal  MemRead     : std_logic;
		signal  MemWrite    : std_logic;
		signal  MemToReg    : std_logic;
		signal  IR1out		: std_logic_Vector(15 downto 0);
		signal  IRWrite     : std_logic;
		signal  JumpAndLink : std_logic;
		signal  IsSigned    : std_logic;
		signal  PCSource    : std_logic_vector(1 downto 0);
		signal  ALUOp       : std_logic_vector(5 downto 0);
		signal  ALUSrcB     : std_logic_vector(1 downto 0);
		signal  ALUSrcA     : std_logic;
		signal  RegWrite    : std_logic;
		signal  RegDst      : std_logic;
		signal  ALU_LO_HI	  : std_logic_vector(1 downto 0);
		signal  OPSelect    : std_logic_vector(5 downto 0);
		signal  InPort_en   : std_logic;
		signal  InPort0	  : std_logic_vector(8 downto 0);
		signal  InPort1	  : std_logic_vector(8 downto 0);
		signal  OpCode      : std_logic_vector(5 downto 0);
		signal  ALU_OpCode  : std_logic_vector(5 downto 0);
		signal  OutPort	  : std_logic_vector(31 downto 0); 
		signal  inport_sel  : std_logic;
		signal 	hi_en		: std_logic;
		signal lo_en		: std_logic;
		  
		signal  clk    	  : std_logic:='0';
		signal  rst		  : std_logic:='1';


begin  -- TB


	UUT : entity work.datapath
		port map(
		  PCWriteCond => PCWriteCond,
		  PCWrite     => PCWrite,
		  IorD        => IorD,
		  MemRead     => MemRead,
		  MemWrite    => MemWrite,
		  MemToReg    => MemToReg,
		  IR1out	  => IR1out,
		  IRWrite     => IRWrite,
		  JumpAndLink => JumpAndLink,
		  IsSigned    => IsSigned,
		  PCSource    => PCSource, 
		  ALUOp       => ALUOp,
		  ALUSrcB     => ALUSrcB, 
		  ALUSrcA     => ALUSrcA,
		  RegWrite    => REGWRITE,
		  RegDst      => regdst,
		  ALU_LO_HI	  => ALU_LO_HI, 
		  OPSelect    => OPSelect,
		  InPort_en   => InPort_en,
		  InPort0	  => InPort0, 
		  InPort1	  => InPort1, 
		  OpCode      => opcode, 
		  ALU_OpCode  => alu_opcode,
		  OutPort	  => outport,
		  inport_sel  => inport_sel,
		  clk    	  => clk,
		  rst		  => rst
		  );
				
	UUA : entity work.alucontroller
		port map(
		opcode  	=>opcode,
		ir			=>alu_opcode,
		opselect	=>opselect,
		ALU_LO_HI	=>alu_lo_hi,
		HI_en 		=>hi_en,
		LO_en 		=>lo_en
		);
		
	UUB : entity work.controller 
		port map(
		clk			=>clk,
		rst			=>rst,
		PCWriteCond =>pcwritecond,
		ir1			=> IR1out,
		alu_opcode  =>alu_opcode,
		PCWrite		=>pcwrite,
		IorD		=>iord,
		MemRead		=>memread,
		MemWrite	=>memwrite,
		memtoreg	=>memtoreg,
		IRWrite		=>irwrite,
		jumpandlink =>jumpandlink,
		issigned	=>issigned,
		pcsource 	=>pcsource,
		aluop 		=>aluop,
		alusrca		=>alusrca,
		alusrcB		=>alusrcB,
		regwrite 	=>regwrite,
		regdst 		=>regdst,
		opcode 		=>opcode
		);




	clk <= not clk after 2 ns;
	
    process
    begin
	wait for 10 ns;
	rst<='0';
	wait for 10 ns;
	
	
    end process;

end TB;
