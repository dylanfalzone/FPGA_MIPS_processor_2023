library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_tb is

end datapath_tb;

architecture TB of datapath_tb is
	signal	clk 	  :  std_logic:='0';
	signal	rst 	  :  std_logic:='1';
	signal	inport0	  :  std_logic_vector(9 downto 0);
	signal	inport1   :  std_logic_vector(9 downto 0);
	signal	inportsel :  std_logic_vector(1 downto 0):="10";
	signal	outport	  :  std_logic_vector(31 downto 0);
	signal outstate   : integer;

begin  -- TB

    UUT : entity work.datapath
		port map(
			clk		  =>clk,
			rst		  =>rst,
			inport0	  =>inport0,
			inport1	  =>inport1,
			inportsel =>inportsel,
			outstate  =>outstate,
			outport	  =>outport);

	clk <= not clk after 2 ns;
	
    process
    begin
	wait for 5 ns;
	rst<='0';
	inport0<=std_logic_vector(to_unsigned(510,10));
	inport1<=std_logic_vector(to_unsigned(51,10));
	wait for 4 ns;
	inportsel<="11";
	
	

    end process;

end TB;