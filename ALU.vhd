library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ALU is 
	port(
		clk 		 	: in std_logic;
		rst				: in std_logic;
		in0  			: in std_logic_vector(31 downto 0);
		in1				: in std_logic_vector(31 downto 0);
		shift_amount 	: in std_logic_vector(4 downto 0); 
		Operation_select: in std_logic_vector(5 downto 0); 
		Branch_taken 	: out std_logic;
		New_result		: out std_logic_vector(31 downto 0);
		Old_result 		: out std_logic_vector(31 downto 0);
		HI_result		: out std_logic_vector(31 downto 0)
		
	);
end ALU;


architecture arch6 of ALU is 
signal temp1 : unsigned(31 downto 0);
signal temp2 : signed(63 downto 0);
signal temp3 : unsigned(63 downto 0);
signal branchtemp : std_logic;
signal tempresult : std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(0,32));
signal tempresulthi : std_logic_vector(31 downto 0);
signal regenable : std_logic:='1';
begin 
	process(in0,in1,operation_select,shift_amount,temp1,temp2,temp3,clk)
	begin
		regenable<='1';
		temp1<=to_unsigned(0,32);
		temp2<=to_signed(0,64);
		temp3<=to_unsigned(0,64);
		branchtemp<='0';
		tempresult<=std_logic_vector(to_unsigned(0, 32));
		tempresulthi<=std_logic_vector(to_unsigned(0, 32));
		case to_integer(unsigned(operation_select)) is 
		
		when 0 => --add unsigned
			temp1<=unsigned(in0)+unsigned(in1);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 1 => --add immediate
			temp1<=unsigned(in0)+unsigned(in1);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 2 => -- sub unsigned	
			temp1<=unsigned(in0)-unsigned(in1);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 3 => -- sub immediate
			temp1<=unsigned(in0)-unsigned(in1);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 4 => --mult
			temp2<=signed(signed(in0)*signed(in1));
			tempresult<=std_logic_vector(temp2(31 downto 0));
			tempresulthi<=std_logic_vector(temp2(63 downto 32));
		when 5 => --mult unsigned
			temp3<=unsigned(unsigned(in0)*unsigned(in1));
			tempresult<=std_logic_vector(temp3(31 downto 0));
			tempresulthi<=std_logic_vector(temp3(63 downto 32));
		when 6 => -- and
			tempresult<=in0 and in1;
		when 7 => --andi
			tempresult <= in0 and in1;
		when 8 => --or
			tempresult <= in0 or in1;
		when 9 => --ori
			tempresult <= in0 or in1;
		when 10 => -- xor
			tempresult <= in0 xor in1;
		when 11 => --xori
			tempresult<= in0 xor in1;
		when 12 => --srl
			tempresult<=std_logic_vector(shift_right(unsigned(in1),to_integer(unsigned(shift_amount))));
		when 13 => --sll
			tempresult<=std_logic_vector(shift_left(unsigned(in1),to_integer(unsigned(shift_amount))));
		when 14 => --sra
			tempresult<=std_logic_vector(shift_right(signed(in1),to_integer(unsigned(shift_amount))));
		when 15 => --slt
			if(to_integer(signed(in0)) < to_integer(signed(in1))) then
				tempresult<=std_logic_vector(to_unsigned(1, 32));
			else
				tempresult<=std_logic_vector(to_unsigned(0, 32));
			end if;

		when 16 => --slti
			if(to_integer(signed(in0)) < to_integer(signed(in1))) then
				tempresult<=std_logic_vector(to_unsigned(1, 32));
			else
				tempresult<=std_logic_vector(to_unsigned(0, 32));
			end if;
		when 17 => --stlu
			if(to_integer(unsigned(in0)) < to_integer(unsigned(in1))) then
				tempresult<=std_logic_vector(to_unsigned(1, 32));
			else
				tempresult<=std_logic_vector(to_unsigned(0, 32));
			end if;
		when 18 => --mfhi
		when 19 => --mflo
		when 20 => --LW
			temp1<=unsigned(in0)+unsigned(in1);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 21 => --SW
			temp1<=unsigned(in0)+unsigned(in1);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 22 => --beq
			if(in0 = in1) then
				branchtemp<='1';
			end if;
		when 23 => --brne
			if(in0 /= in1) then
				branchtemp<='1';
			end if;
		when 24 => --brlez
			if(to_integer(signed(in0))<=0) then
				branchtemp<='1';
			end if;
		when 25 => --brgz
			if(to_integer(signed(in0))>0) then
				branchtemp<='1';
			end if;
		when 26 => --brlz
			if(to_integer(signed(in0))<0) then
				branchtemp<='1';
			end if;
		when 27 => --bgez
			if(to_integer(signed(in0))>=0) then
				branchtemp<='1';
			end if;
		when 28 => --jump to addr
		when 29 => --add uns+signed
			temp1<=to_unsigned(to_integer(unsigned(in0))+to_integer(signed(in1)),32);
			tempresult<=std_logic_vector(temp1(31 downto 0));
		when 30 => --jump register
			tempresult<=in0;
		when 31 => --fake inst	
		when others => 
			null;
		end case;
	end process;
	branch_taken<=branchtemp;
	new_result<=tempresult;
	
	U_ALU_out : entity work.reg
	port map(
		clk=>clk,
		rst=>rst,
		enable=>regenable,
		in0=>tempresult,
		output=>old_result);

		
	Hi_result<=tempresulthi;
end arch6;