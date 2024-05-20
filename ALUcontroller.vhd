library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ALUcontroller is 
	port(
		operation_type  	: in std_logic_vector(5 downto 0);
		operation_specify	: in std_logic_vector(5 downto 0);
		operation_select	: out std_logic_vector(5 downto 0);
		ALU_LO_HI			: out std_logic_vector(1 downto 0);
		HI_en 				: out std_logic;
		LO_en 				: out std_logic
		
	);
end ALUcontroller;

architecture arch10 of alucontroller is

signal opsel : integer;
signal hi_en_temp : std_logic;
signal lo_en_temp : std_logic;
signal alu_lo_hi_temp : std_logic_vector(1 downto 0);

begin

process(operation_type, operation_specify)
begin

opsel<=31;
hi_en_temp<='0';
lo_en_temp<='0';
alu_lo_hi_temp<="00";
	case to_integer(unsigned(operation_type)) is 
	when 0 => --r-type
	--add, sub, mult, multu and, or, xor, srl, sll, sra,slt, sltu, mfhi, mflo,jmp reg
		case to_integer(unsigned(operation_specify)) is 
		when 33 =>
			--add unsigned
			opsel<=0;
		when 35 =>
			--sub unsigned
			opsel<=2;
		when 24 =>--mult
			opsel<= 4;
			lo_en_temp<='1';
			hi_en_temp<='1';
			
		when 25 =>--multu
			opsel<=5;
			lo_en_temp<='1';
			hi_en_temp<='1';
					
		when 36 =>--and
			opsel<=6;
		when 37 =>
			--or
			opsel<=8;
		when 38 =>
			--xor
			opsel<=11;
		when 2 =>
			--srl
			opsel<=12;
		when 0 =>
			--sll
			opsel<=13;
		when 3 =>
			--sra
			opsel<=14;
		when 42 =>
			--slt
			opsel<=15;
		when 43 =>
			--sltu
			opsel<=17;
		when 16 =>
			--mfhi
			opsel<=18;
			alu_lo_hi_temp<="10";
		when 18 =>
			--mflo
			opsel<=19;
			alu_lo_hi_temp<="01";
		when 8 =>
			--jump reg
			opsel<=30;
		when others=>
		null;
		end case;
	when 9 => --ITYPE:
		--add immediate I-TYPE
		opsel<=1;
	when 16 =>
		--subi I TYPE
		opsel<=3;
	when 12 =>
		--andi I TYPE
		opsel<=7; 
	when 13 =>
		--ori I TYPE
		opsel<=9;
	when 14 =>
		--xori I TYPE
		opsel<=11;
	when 11 =>
		--slti ITYPE
		opsel<=16;
	when 35 =>
		--lw I TYPE
		opsel<=20;
	when 43 =>
		--sw ITYPE
		opsel<=21;
	when 4 =>
		--breq ITYPE
		opsel<=22;
	when 5 =>
		--brne ITYPE
		opsel<=23;
	when 6 =>
		--brlez ITYPE
		opsel<=24;
	when 7 =>
		--brgz ITYPE
		opsel<=25;
	when 1 =>
		--brlz ITYPE
		opsel<=26;
		--brgez ITYPE
		opsel<=27;
	when 2 => --JTYPE:
		--jump to addr JTYPE
		opsel<=28;
	when 3 =>
		--jump and link JTYPE
		opsel<=28;
	when 61 =>
		opsel<=29;
	when 63 =>
		opsel<=0;
	when others =>
	null;
	end case;



	
end process;
	
operation_select<=std_logic_vector(to_unsigned(opsel,6));
hi_en<=hi_en_temp;
lo_en<=lo_en_temp;
alu_lo_hi<=alu_lo_hi_temp;


end arch10;