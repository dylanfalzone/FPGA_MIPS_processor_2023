library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity generic_components is
	port(
	out0 	: out std_logic;
	in0 	: in std_logic);
end generic_components;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mux2x1 is 
	generic (WIDTH : positive:= 32);
	port (
		in0    : in std_logic_vector(WIDTH-1 downto 0);
		in1    : in std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		sel    : in std_logic
);
end mux2x1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mux3x1 is 
	generic (WIDTH : positive:= 32);
	port (
		in0    : in std_logic_vector(WIDTH-1 downto 0);
		in1    : in std_logic_vector(WIDTH-1 downto 0);
		in2	 : in std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		sel    : in std_logic_vector(1 downto 0)
);
end mux3x1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mux4x1 is 
	generic (WIDTH : positive:= 32);
	port (
		in0    : in std_logic_vector(WIDTH-1 downto 0);
		in1    : in std_logic_vector(WIDTH-1 downto 0);
		in2    : in std_logic_vector(WIDTH-1 downto 0);
		in3    : in std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		sel    : in std_logic_vector(1 downto 0)
);
end mux4x1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg is 
	generic (WIDTH : positive:= 32);
	port (
		clk	 : in std_logic;
		rst 	 : in std_logic;
		enable : in std_logic;
		in0    : in std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0)
);
end reg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sign_extend is 
	port(
		in0 : in std_logic_vector(15 downto 0);
		sel : in std_logic;
		output : out std_logic_vector(31 downto 0)
		);
end sign_extend;

architecture arch_generic_components of generic_components is
begin
	out0 <=in0;
end arch_generic_components;

architecture arch_mux2x1 of mux2x1 is
begin 
	output <= in0 when sel ='0' else in1;
end arch_mux2x1;

architecture arch_mux3x1 of mux3x1 is
begin 

	output<= in0 when (sel="00") else
				in1 when (sel="01") else
				in2 when (sel="10") else
				std_logic_vector(to_unsigned(0, WIDTH));
end arch_mux3x1;

architecture arch_mux4x1 of mux4x1 is
begin 

	output<= in0 when (sel="00") else
				in1 when (sel="01") else
				in2 when (sel="10") else
				in3 when (sel="11") else
				std_logic_vector(to_unsigned(0, WIDTH));
end arch_mux4x1;

architecture arch_reg of reg is
begin 
	process(clk, rst)
	begin
		if(rst ='1') then
			output<=(others =>'0');
		elsif(clk ='1' and clk' event) then
			if(enable = '1') then
			output<=in0;
			end if;
		end if;
	end process;
end arch_reg;

architecture arch_sign_extend of sign_extend is
begin
	process(in0, sel)
	begin
	if (sel='1') then
		if(in0(15 downto 15) = "1") then
			output(31 downto 16)<= "1111111111111111";
			output(15 downto 0)<=in0;
		else 
			output(31 downto 16)<= "0000000000000000";
			output(15 downto 0)<=in0;
		end if;
	else 
		output(31 downto 16)<= "0000000000000000";
		output(15 downto 0)<=in0;		
	end if;
	end process;
end arch_sign_extend;