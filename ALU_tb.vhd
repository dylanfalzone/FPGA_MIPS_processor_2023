library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is

end ALU_tb;

architecture TB of ALU_tb is

	signal in0  		   : std_logic_vector(31 downto 0);
	signal in1			   : std_logic_vector(31 downto 0);
	signal shift_amount	   : std_logic_vector(4 downto 0);
	signal operation_select: std_logic_vector(5 downto 0); 
	signal branch_taken    :  std_logic;
	signal new_result	   :  std_logic_vector(31 downto 0);
	signal old_result 	   : std_logic_vector(31 downto 0);
	signal hi_result	   :std_logic_vector(31 downto 0);
	signal clk 		  	   : std_logic :='0';
	signal rst 			   : std_logic:='1';


begin  -- TB

    UUT : entity work.ALU
		port map(
				in0=>in0,
				in1=>in1,
				shift_amount=>shift_amount,
				operation_select=>operation_select,
				branch_taken=>branch_taken,
				new_result=>new_result,
				old_result=>old_result,
				clk =>clk,
				rst =>rst,
				hi_result=>hi_result);

	clk <= not clk after 2 ns;
	
    process
    begin
	wait for 10 ns;
	rst<='0';
	wait for 10 ns;
	
	
	--add 10 + 15
	shift_amount<=std_logic_vector(to_unsigned(0,5));
	in0<=std_logic_vector(to_unsigned(10, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(0, 6)));
	wait for 40 ns;
	
		--sub 25-10
	in0<=std_logic_vector(to_unsigned(25, 32));
	in1<=std_logic_vector(to_unsigned(10, 32));
	operation_select<=(std_logic_vector(to_unsigned(2, 6)));
	wait for 40 ns;
	
		--mult 10*-4 (signed)
	in0<=std_logic_vector(to_signed(10, 32));
	in1<=std_logic_vector(to_signed(-4, 32));
	operation_select<=(std_logic_vector(to_signed(4, 6)));
	wait for 40 ns;
	
		--mult 65536*131072 unsigned
	in0<=std_logic_vector(to_unsigned(65536, 32));
	in1<=std_logic_vector(to_unsigned(131072, 32));
	operation_select<=(std_logic_vector(to_unsigned(5, 6)));
	wait for 40 ns;
	
		--and 0x0000FFFF and 0xffff1234
	in0<=std_logic_vector(to_unsigned(65535, 32));
	in1<=std_logic_vector(to_unsigned(4660, 32));
	operation_select<=(std_logic_vector(to_unsigned(6, 6)));
	wait for 40 ns;
	
		--srl 0x0000000f by 4
	in0<=std_logic_vector(to_unsigned(15, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(12, 6)));
	shift_amount<=(std_logic_vector(to_unsigned(4,5)));
	wait for 40 ns;
	
		--sra 0xf0000008 by 1 4026531848
	in0<=std_logic_vector(to_unsigned(8, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(14, 6)));
	shift_amount<=(std_logic_vector(to_unsigned(1,5)));
	wait for 40 ns;
	
		--sra of 0x00000008 by 1
	in0<=std_logic_vector(to_unsigned(8, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(14, 6)));
	shift_amount<=(std_logic_vector(to_unsigned(1,5)));
	wait for 40 ns;
	
		--set on less than using 10 and 15
	in0<=std_logic_vector(to_unsigned(10, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(15, 6)));
	wait for 40 ns;
	
		--set on less than using 15 and 10
	in0<=std_logic_vector(to_unsigned(15, 32));
	in1<=std_logic_vector(to_unsigned(10, 32));
	operation_select<=(std_logic_vector(to_unsigned(15, 6)));
	wait for 40 ns;
	
	--branch_taken taken output =0 for 5<=0 (BRLEZ)
	in0<=std_logic_vector(to_unsigned(5, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(24, 6)));
	wait for 40 ns;
	
	--branch taken output = 1 for 5>0 brgz
	in0<=std_logic_vector(to_unsigned(5, 32));
	in1<=std_logic_vector(to_unsigned(15, 32));
	operation_select<=(std_logic_vector(to_unsigned(25, 6)));
	wait for 40 ns;
	
	
    end process;

end TB;
