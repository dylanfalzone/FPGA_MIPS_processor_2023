library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity controller is
port(
	clk				: in std_logic;
	rst				: in std_logic;
	IR_31_26			: in std_logic_vector(31 downto 26);
	IR_5_0			: in std_logic_vector(5 downto 0);
	PCWriteCond 	: out std_logic;
	PCWrite			: out std_logic;
	IorD 				: out std_logic;
	MemRead			: out std_logic;
	MemWrite			: out std_logic;
	MemToReg			: out std_logic;
	IRWrite			: out std_logic;
	JumpAndLink		: out std_logic;
	IsSigned			: out std_logic;
	PcSource			: out std_logic_vector(1 downto 0);
	Operation_type	: out std_logic_vector(5 downto 0);
	AluSrcA			: out std_logic;
	ALUSrcB			: out std_logic_vector(1 downto 0);
	RegWrite			: out std_logic;
	outstate			: out integer;
	RegDst			: out std_logic
	);
	
end controller;


architecture arch_controller of controller is

	type STATE_TYPE is (START, instruction_fetch, mult,
	instruction_decode, r1, r2, I1, I2, LWSW, LW2, HALT, 
	LW3, LW4, SW2, SW3, b1, b2, b3, r_jump1, r_jump2, j1);	
	
	signal state		: STATE_TYPE;
	signal next_state : STATE_TYPE;
	signal statetemp : integer;
	
begin
	
	process(clk, rst)
	begin
		if (rst ='1') then
		state <= START;
		elsif (rising_edge(clk)) then
		state <= next_state;
		end if;
	end process;
	
	
	process(state,IR_31_26,IR_5_0)
	begin
		--default values
		next_state		<=state;
		PCWriteCond 	<='0';
		PCWrite			<='0';
		IorD				<='0';
		MemRead			<='1';
		MemWrite			<='0';
		memtoreg			<='0';
		IRWrite			<='0';
		jumpandlink 	<='0';
		issigned			<='0';
		pcsource			<="00";
		operation_type <="000000";
		alusrca			<='0';
		alusrcB 			<="00";
		regwrite 		<='0';
		regdst 			<='0';
		
		
		case state is
		when START =>
		statetemp<=0;
			next_state<=instruction_fetch;
		
		when instruction_fetch=> 
		statetemp<=1;
			--load rf
			memread<='1';
			irwrite<='1';
			
			--increment pc
			alusrcb<="01";
			pcwrite<='1';
			operation_type<="111111";
			next_state<=instruction_decode;

		when instruction_decode=>
		statetemp<=2;
			Operation_type<=IR_31_26;
			case IR_31_26 is 
			--LW
			when "100011" => 
				next_state<=LWSW;
			--SW
			when "101011" => 
				next_state<=LWSW;
			--RTYPE
			when "000000" => 
				--JUMP REGISTER
				if(IR_5_0 = "001000") then
					next_state<=r_jump1;
				else
					next_state<=r1;
				end if;
			--JUMP TO ADDR
			when "000010" =>
				pcsource<="10";
				pcwrite<='1';
				next_state<=j1;
				
			--JUMP +LINK
			when "000011" =>
				pcsource<="10";
				pcwrite<='1';
				regwrite<='1';
				jumpandlink<='1';
				next_state<=j1;
			--BREQ
			when "000100" =>
				next_state<=b1;
			--BRNE
			when "000101" => 
				next_state<=b1;
			--BR <=0
			when "000110" => 
				next_state<=b1;
			--BR >=0
			when "000111" => 
				next_state<=b1;
			--BR <0 or BR >0
			when "000001" => 
				next_state<=b1;
			--halt	
			when "111111" =>
				next_state<=HALT;
			--I TYPE
			when others   => 
				next_state<=I1;
			end case;
		
		--LW OR SW
		when LWSW =>
		statetemp<=3;
			isSigned <= '0';
			ALUSRCA <= '1';
			ALUSRCB <= "10";
			Operation_type <= IR_31_26;
			if(IR_31_26 = "100011") then 
				next_state<=LW2;
			else
				next_state<=SW2;
			end if;
			
		--LW STORE	
		when LW2 =>
		statetemp<=4;
		ALUSRCA <= '1';
			ALUSRCB <= "10";
			operation_type<=IR_31_26;
			Iord <= '1';
			Memread <='1';
			next_state<=LW3;
			
		--LW DELAY STAGE
		when LW3=>
		statetemp<=5;
			Iord<='1';
			next_state<=LW4;
			
		--LW COMPLETE
		when LW4 =>
		statetemp<=6;
			MemToReg<='1';
			RegWrite<='1';
			RegDst<='0';
			next_state<=Instruction_Fetch;
		
		--SW STORE
		when SW2 =>
		statetemp<=7;
			Iord <= '1';
			MemWrite<='1';
			MemRead<='0';
			next_state<=SW3;
			
		--SW DELAY STAGE
		when SW3 =>
		statetemp<=8;
			next_state<=instruction_fetch;
			
		--R Operation
		when r1 =>
		statetemp<=9;
			operation_type<=IR_31_26;
			ALUSRCA<='1';
			ALUSRCB<="00";
			if ((IR_5_0 = "010010") or (IR_5_0 = "010000")) then --MFLO OR MFHI
				regwrite<='1';
				regdst<='1';
				next_state<=instruction_fetch; 
			elsif ((IR_5_0 = "011001") or (IR_5_0 = "011000")) then
				next_state<=mult;
			else
				next_state<=r2;
			end if;
		
		--R mult don't store.
		when mult =>
		statetemp<=9;
			operation_type<="111111";
			next_state<=instruction_fetch;
		
		--R store/complete
		when r2 =>
		statetemp<=10;
			operation_type<="111111";
			regwrite<='1';
			regdst<='1';
			next_state<=instruction_fetch;
			
		--I operation
		when I1=>
		statetemp<=11;
			if(IR_31_26 ="001011") then --SLTI
				IsSigned<='1';
			end if;
			operation_type<=IR_31_26;
			ALUSRCA<='1';
			ALUSRCB<="10";
			next_state<=I2;
			
		--I STORE/COMPLETE
		when I2=>
		statetemp<=12;
			regWrite<='1';
			next_state<=instruction_fetch;
		
		--Jump REGISTER1
		when r_jump1=>
		statetemp<=13;
			operation_type<=IR_31_26;
			ALUSRCA<='1';
			pcwrite<='1';
			next_state<=r_jump2;
		
			
		--jump register2
		when r_jump2=>
		statetemp<=14;
			operation_type<=IR_31_26;
			IorD<='1';
			
			
			next_state<=instruction_fetch;
		
		--jump+link or jump=>addr
		when j1 =>
		statetemp<=15;
			next_state<=instruction_fetch;
		
		--BRANCHING
		when b1=>
		statetemp<=16;
			Issigned<='1';
			operation_type<="111101";
			ALUSRCB<="11";
			next_state<=b2;
		when b2=>
		statetemp<=17;
			operation_type<=IR_31_26;
			ALUSRCA<='1';
			ALUSRCB<="00";
			pcWritecond<='1';
			pcsource<="01";
			next_state<=b3;
		--BRANCH delay/complete
		when b3=>
		statetemp<=18;
			ALUSRCA<='1';
			next_state<=instruction_fetch;
		
		when HALT=>
		statetemp<=19;
			next_state<=HALT;

		when others =>
		null;
		end case;
		

		
	end process;
		outstate<=statetemp;

end arch_controller;