
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Memory is 
	port(
		clk 		 : in std_logic;
		rst 		 : in std_logic;
	   addr 		 : in std_logic_vector(31 downto 0);
		inport0 	 : in std_logic_vector(9 downto 0);
		inport1   : in std_logic_vector(9 downto 0);
		wr_en 	 : in std_logic;
		rd_en 	 : in std_logic;
		inport_sel: in std_logic;
		inport_en : in std_logic;
		reg_in  	 : in std_logic_vector(31 downto 0);
		outport	 : out std_logic_vector(31 downto 0);
		outdata	 : out std_logic_vector(31 downto 0)
	);
end Memory;

architecture arch_memory of Memory is
signal inport0_reg 	 : std_logic_vector(31 downto 0);
signal inport1_reg 	 : std_logic_vector(31 downto 0);
signal outdata_temp	 : std_logic_vector(31 downto 0);
signal ramout 			 : std_logic_vector(31 downto 0);
signal inport0_reg_en : std_logic;
signal inport1_reg_en : std_logic;
signal ramin 			 : std_logic_vector(7 downto 0);
signal outport_en		 : std_logic;
signal in0convert0	 : std_logic_vector(31 downto 0);
signal in0convert1 	 : std_logic_vector(31 downto 0);

begin
	process(addr,inport0_reg,inport1_reg,ramout,wr_en)
	begin
	outport_en<='0';
		case addr is 
		when "00000000000000001111111111111000" =>
			outdata_temp<=inport0_reg;
		when "00000000000000001111111111111100" =>
			if(wr_en ='0') then
				outdata_temp<=inport1_reg;
			else
				outdata_temp<=ramout;
				outport_en<='1';
			end if;
		when others =>
			outdata_temp<=ramout;
		end case;
	end process;
	outdata<=outdata_temp;
	
	process(inport_en,inport_sel)
	begin
	inport0_reg_en<='0';
	inport1_reg_en<='0';
		if(inport_en = '1') then
			if (inport_sel ='0') then 
				inport0_reg_en<='1';
			elsif (inport_sel ='1') then
				inport1_reg_en<='1';	
			end if;
		else
			inport0_reg_en<='0';
			inport1_reg_en<='0';
		end if;
	end process;
	
	ramin<=std_logic_vector(to_unsigned((to_integer(unsigned(addr))/4),8));
	U_RAM : entity work.bubbles
	port map(
		address => ramin,
		clock => clk,
		data => reg_in,
		wren => wr_en,
		q 	=> ramout);
		
	in0convert0<=std_logic_vector(to_unsigned(0,22)) & inport0;
	U_inport0_reg : entity work.reg
	port map(
		clk=> clk,
		rst=> '0',
		enable=>inport0_reg_en,
		in0=>in0convert0,
		output=>inport0_reg);
		
	in0convert1<=std_logic_vector(to_unsigned(0,22)) & inport1;		
	U_inport1_reg : entity work.reg
	port map(
		clk=> clk,
		rst=> '0',
		enable=>inport1_reg_en,
		in0=>in0convert1,
		output=>inport1_reg);
	
	U_outport_reg : entity work.reg
	port map(
		clk=>clk,
		rst=>rst,
		enable=>outport_en,
		in0=>reg_in,
		output=>outport);
		
	
end arch_memory;
