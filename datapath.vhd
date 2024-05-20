library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity datapath is 
	port(
		clk : in std_logic;
		rst : in std_logic;
		inport0 	 : in std_logic_vector(9 downto 0);
		inport1   : in std_logic_vector(9 downto 0);
		inportsel : in std_logic_vector(1 downto 0);
		OUTSTATE  : out integer;
		outport	 : out std_logic_vector(31 downto 0)	
		);
end datapath;

architecture arch_datapath of datapath is
	--all signals are grouped by which component generates them
	
	
	--Controller signals:
	signal PCWriteCond 	: std_logic;
	signal PCWrite			: std_logic;
	signal IorD 			: std_logic;
	signal MemRead			: std_logic;
	signal MemWrite		: std_logic;
	signal MemToReg		: std_logic;
	signal IRWrite			: std_logic;
	signal JumpAndLink	: std_logic;
	signal IsSigned		: std_logic;
	signal PcSource		: std_logic_vector(1 downto 0);
	signal Operation_type: std_logic_vector(5 downto 0);
	signal AluSrcA			: std_logic;
	signal ALUSrcB			: std_logic_vector(1 downto 0);
	signal RegWrite		: std_logic;
	signal RegDst			: std_logic;
	
	--PC
	signal PC_out			: std_logic_vector(31 downto 0);
	signal PC_en			: std_logic;
	signal PC_MUX_out		: std_logic_vector(31 downto 0);
	
	--memory
	signal Memory_out		: std_logic_vector(31 downto 0);
	signal inport_en		: std_logic;
	signal inport_sel		: std_logic;
	
	--instruction register
	signal IR_10_6			: std_logic_vector(10 downto 6);
	signal IR_31_0			: std_logic_vector(31 downto 0);
	signal IR_5_0			: std_logic_vector(5 downto 0);
	signal IR_15_0			: std_logic_vector(15 downto 0);
	signal IR_15_11		: std_logic_vector(15 downto 11);
	signal IR_20_16		: std_logic_vector(20 downto 16);
	signal IR_25_21		: std_logic_vector(25 downto 21);
	signal IR_25_0			: std_logic_vector(25 downto 0);
	signal IR_31_26		: std_logic_vector(31 downto 26);
	
	--data_memory
	signal Data_memory_Reg_out	: std_logic_vector(31 downto 0);
	
	--rf_in_mux's
	signal RF_mux1_out 		: std_logic_vector(4 downto 0);
	signal RF_mux2_out 		: std_logic_vector(31 downto 0);
	
	--rf
	signal RF_data_out1 		: std_logic_vector(31 downto 0);
	signal RF_data_out2		: std_logic_vector(31 downto 0);
	
	--shift_left2_2
	signal sign_extend_out	: std_logic_vector(31 downto 0);
	signal shift_left2_2_out: std_logic_vector(31 downto 0);
	
	--ALU_in_mux's
	signal ALU_in_mux1_out	: std_logic_vector(31 downto 0);
	signal ALU_in_mux2_out	: std_logic_vector(31 downto 0);
	
	--shift_left_1
	signal Shift_left2_1_out: std_logic_vector(27 downto 0);
	signal concat_out			: std_logic_vector(31 downto 0);
	
	--alu
	signal branch_taken		: std_logic;
	signal alu_new_result	: std_logic_vector(31 downto 0);
	signal alu_old_result	: std_logic_vector(31 downto 0);
	signal alu_new_hi_result: std_logic_vector(31 downto 0);
	signal alu_old_hi_result: std_logic_vector(31 downto 0);
	signal alu_old_lo_result: std_logic_vector(31 downto 0);
	
	--alu_control
	signal alu_operation_select: std_logic_vector(5 downto 0);
	signal alu_lo_hi				: std_logic_vector(1 downto 0);
	signal alu_hi_en				: std_logic;
	signal alu_lo_en				: std_logic;
	
	--alu_out_muxs
	signal alu_out_mux1_out	: std_logic_vector(31 downto 0);
	signal alu_out_mux2_out	: std_logic_vector(31 downto 0);
	
begin
	--Controller:
	U_controller : entity work.controller
	port map(
			clk				=>clk,
			rst				=>rst,
			PcWriteCond		=>PcWriteCond,
			PCWrite			=>PCWrite,
			IorD				=>IorD,
			MemRead			=>MemRead,
			MemWrite			=>MemWrite,
			MemToReg			=>MemToReg,
			IRWrite			=>IRWrite,
			JumpAndLink		=>JumpAndLink,
			IsSigned			=>ISSigned,
			PCSource			=>PCSource,
			Operation_type	=>Operation_Type,
			ALuSrcA			=>ALUSrcA,
			ALUSrcB			=>ALUSrcB,
			RegWrite			=>RegWrite,
			RegDst			=>RegDst,
			IR_31_26			=>IR_31_26,
			OUTSTATE			=>OUTSTATE,
			IR_5_0			=>IR_5_0);
			
	--Pc_en logic:		
	Pc_en<=(PCWriteCond and branch_taken) or PcWrite; 
			
	--PC:		
	U_PC	: entity work.reg
	port map(
			clk 		=>clk,
			rst 		=>rst,
			enable	=>pc_en,
			in0		=>alu_out_mux1_out,
			output	=>pc_out);
			
	--pc_out_mux:
	U_PC_mux : entity work.mux2x1
	port map(
			in0		=>pc_out,
			in1		=>alu_old_Result,
			sel		=>IorD,
			output	=>PC_mux_out);
				
	--dividing up inport_sel:
	inport_en<=inportsel(1);
	inport_sel<=inportsel(0);
	
	--memory:
	U_Memory: entity work.memory
	port map(
			clk 		 =>clk,
			rst 		 =>rst,
			addr 		 =>pc_mux_out,
			inport0 	 =>inport0,
			inport1   =>inport1,
			wr_en 	 =>MemWrite,
			rd_en 	 =>MemRead,
			inport_sel=>Inport_sel,
			inport_en =>Inport_en,
			reg_in  	 =>RF_data_out2,
			outport	 =>outport,
			outdata	 =>memory_out);
			
	--Instruction register and each IR signal	
	U_Instruction_Register: entity work.reg
	port map(
			clk		=>clk,
			rst		=>rst,
			enable	=>IRWrite,
			in0		=>memory_out,
			output	=>IR_31_0);
	IR_25_0	<=IR_31_0(25 downto 0);
	IR_31_26	<=IR_31_0(31 downto 26);
	IR_25_21	<=IR_31_0(25 downto 21);
	IR_20_16	<=IR_31_0(20 downto 16);
	IR_15_11	<=IR_31_0(15 downto 11);
	IR_15_0	<=IR_31_0(15 downto 0);
	IR_5_0	<=IR_31_0(5 downto 0);
	IR_10_6	<=IR_31_0(10 downto 6);

	--Data Memory register
	U_Data_memory : entity work.reg
	port map(
			clk		=> clk,
			rst		=> rst,
			enable	=>	clk,
			in0		=> memory_out,
			output	=> data_memory_reg_out);
			
	--RF_in_mux1
	U_RF_in_mux1 : entity work.mux2x1
	generic map(WIDTH =>5)
	port map(
			in0		=>IR_20_16,
			in1		=>IR_15_11,
			sel		=>RegDst,
			output	=>RF_mux1_out);
	
	--RF_in_mux2
	U_RF_in_mux2 : entity work.mux2x1
	port map(
			in0		=>alu_out_mux2_out,
			in1		=>Data_memory_reg_out,
			sel		=>MemToReg,
			output	=>RF_mux2_out);
	--Register File		
	U_RF : entity work.Regfile
	port map(
			clk 		=>clk,
			rst		=>rst,
			rd_addr1	=>IR_25_21,
			rd_addr2 =>IR_20_16,
			wr_addr 	=>RF_mux1_out,
			wr_en	   =>RegWrite,
			wr_Data	=>RF_mux2_out,
			jnl		=>JumpAndLink,					 
			rd_data1 =>RF_data_out1,
			rd_data2 =>RF_data_out2);
	
	--Sign extend and shift_left2_2:
	U_sign_extend : entity work.sign_extend
	port map(
			sel		=>IsSigned,
			in0		=>IR_15_0,
			output	=>sign_extend_out);
	shift_left2_2_out<=std_logic_vector(shift_left(unsigned(sign_extend_out),2));
	
	--Shift_left2_1 and Concat:
	shift_left2_1_out<="00" & std_logic_vector(shift_left(unsigned(IR_25_0),2));
	Concat_out<=PC_out(31 downto 28) & Shift_left2_1_out(27 downto 0);

	
	--ALU_in_mux1:
	U_ALU_in_mux1 : entity work.mux2x1
	port map(
			in0		=>pc_out,
			in1		=>RF_data_out1,
			sel		=>ALUSrcA,
			output	=>ALU_in_mux1_out);
	
	
	--ALu_in_mux2:
	U_ALU_in_mux2 : entity work.mux4x1
	port map(
			in0		=>RF_data_out2,
			in1		=>std_logic_vector(to_unsigned(4,32)),
			in2		=>sign_extend_out,
			in3		=>shift_left2_2_out,
			sel		=>ALuSrcB,
			output	=>ALU_in_mux2_out);
			
	
	--ALU
	U_ALU : entity work.ALU
	port map(
			clk					=>clk,
			rst					=>rst,
			in0					=>ALU_in_mux1_out,
			in1					=>ALu_in_mux2_out,
			shift_amount		=>IR_10_6,
			Branch_taken		=>Branch_taken,
			New_result			=>Alu_new_result,
			old_result			=>Alu_old_result,
			hi_result			=>Alu_new_hi_result,
			Operation_select	=>ALu_Operation_select);
			
	--ALu_control
	U_ALU_control : entity work.ALUcontroller
	port map(
			operation_type		=>Operation_type,
			operation_specify	=>IR_5_0,
			operation_select	=>alu_operation_select,
			ALU_lo_hi			=>alu_lo_hi,
			LO_en					=>alu_lo_en,
			HI_en					=>alu_hi_en);
			
	--ALU out registers:
	U_ALU_OUT_LO : entity work.reg
	port map(
			clk		=>clk,
			rst		=>rst,
			in0		=>alu_new_result,
			enable	=>alu_lo_en,
			output	=>alu_old_lo_result);
	U_ALU_OUT_HI : entity work.reg
	port map(
			clk		=>clk,
			rst		=>rst,
			in0		=>alu_new_hi_result,
			enable	=>alu_hi_en,
			output	=>alu_old_hi_result);
			
	--ALU_Out_mux's
	U_ALU_OUT_MUX1 : entity work.mux3x1
	port map(
			in0		=>alu_new_result,
			in1		=>alu_old_result,
			in2		=>concat_out,
			sel		=>PCSource,
			output	=>Alu_out_mux1_out);
	U_ALU_OUT_MUX2 : entity work.mux3x1
	port map(
			in0		=>alu_old_result,
			in1		=>alu_old_lo_result,
			in2		=>alu_old_hi_result,
			sel		=>ALu_lo_hi,
			output	=>alu_out_mux2_out);
			
	
end arch_datapath;
