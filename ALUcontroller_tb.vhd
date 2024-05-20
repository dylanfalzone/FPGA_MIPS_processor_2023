library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUcontroller_tb is

end ALUcontroller_tb;

architecture TB of ALUcontroller_tb is

	signal in0  		   : std_logic_vector(31 downto 0);
	signal in1			   : std_logic_vector(31 downto 0);
	signal shift_amount	   : std_logic_vector(4 downto 0);
	signal operation_select: std_logic_vector(5 downto 0); 
	signal branch_taken    :  std_logic;
	signal new_result	   :  std_logic_vector(31 downto 0);
	signal old_result 	   : std_logic_vector(31 downto 0);
	signal hi_result	   : std_logic_vector(31 downto 0);
	
	signal operation_type   : std_logic_vector(5 downto 0);
	signal operation_specify: std_logic_vector(5 downto 0);
	signal ALU_LO_HI		: std_logic_vector(1 downto 0);
	signal HI_en			: std_logic;
	signal LO_en			: std_logic;
	
	signal clk 		: std_logic :='0';
	signal rst 		: std_logic:='1';


begin  -- TB

    UUT : entity work.ALU
		port map(
				in0				=>in0,
				in1				=>in1,
				shift_amount	=>shift_amount,
				operation_select=>operation_select,
				branch_taken	=>branch_taken,
				new_result		=>new_result,
				old_result		=>old_result,
				clk				=>clk,
				rst 			=>rst,
				hi_result		=>hi_result);


	UUB : entity work.ALUcontroller
		port map(
				operation_select	=> operation_select,
				operation_specify 	=> operation_specify,
				operation_type		=> operation_type,
				alu_lo_hi 			=> alu_lo_hi,
				hi_en 				=> hi_en,
				lo_en 				=> lo_en);
				
				
	clk <= not clk after 2 ns;
	
    process
    begin
	wait for 10 ns;
	rst<='0';
	wait for 10 ns;
	
	--add 10 + 15
	shift_amount<=std_logic_vector(to_unsigned(1,5));
	in0<=std_logic_vector(to_unsigned(10, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_type<= "000000";
	operation_specify<= "100001";
	wait for 40 ns;

		--andi 10 + 15
	in0<=std_logic_vector(to_unsigned(10, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_type<= "001100";
	operation_specify<= "000000";
	wait for 40 ns;
	
		--multu 10*15
	operation_type<= "000000";
	operation_specify<= "011001";
	wait for 40 ns;
	
		--lw
	operation_type<= "100011";
	operation_specify<= "011001";
	wait for 40 ns;	
		
		--sw
	operation_type<= "101011";
	operation_specify<= "011001";
	wait for 40 ns;	
		
		--mflo
	operation_type<= "000000";
	operation_specify<= "010010";
	wait for 40 ns;	
		--mfhi
	operation_type<= "000000";
	operation_specify<= "010000";
	wait for 40 ns;
	
	
    end process;

end TB;
