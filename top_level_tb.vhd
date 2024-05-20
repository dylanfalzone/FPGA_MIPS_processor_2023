library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is

end top_level_tb;

architecture TB of top_level_tb is
		signal clk : std_logic:='0';
		signal switch : std_logic_vector(9 downto 0):="0000000000";
		signal button_n : std_logic_vector(1 downto 0):="11";
		signal rst       : std_logic:='1';
	signal inportsel : std_logic_vector(1 downto 0);
    signal outport   : std_logic_vector(31 downto 0);
    signal inport0   : std_logic_vector(9 downto 0);
    signal inport1   : std_logic_vector(9 downto 0);
	SIGNAL led5 	 : std_logic_vector(6 downto 0);
	SIGNAL led4 	 : std_logic_vector(6 downto 0);
	SIGNAL led3 	 : std_logic_vector(6 downto 0);
	SIGNAL led2 	 : std_logic_vector(6 downto 0);
	SIGNAL led1 	 : std_logic_vector(6 downto 0);
	SIGNAL led0 	 : std_logic_vector(6 downto 0);
begin  -- TB

   
    -- the buttons are active low
	  rst <= not button_n(0);
	 inportsel(1)<= not button_n(1);
	 inportsel(0)<= switch(9);
	 inport0<='0' & switch(8 downto 0);
	 inport1<='0' & switch(8 downto 0);

    -- map output to two LEDs
    UUT_LED5 : entity work.decoder7seg port map (
        input  => outport(15 downto 12),
        output => led5);

    UUT_LED4 : entity work.decoder7seg port map (
        input  => outport(11 downto 8),
        output => led4);

    -- all other LEDs should display 0
    UUT_LED3 : entity work.decoder7seg port map (
        input  => outport(7 downto 4),
        output => led3);

    UUT_LED2 : entity work.decoder7seg port map (
        input  => outport(3 downto 0),
        output => led2);

    UUT_LED1 : entity work.decoder7seg port map (
        input  => "0000",
        output => led1);

    UUT_LED0 : entity work.decoder7seg port map (
        input  => "0000",
        output => led0);

    UUT_datapath : entity work.datapath
			port map (
            clk    	=> clk,
            rst    	=> rst,
				inport0	=>inport0,
				inport1	=>inport1,
				inportsel=>inportsel,
				outport	=>outport);


	clk <= not clk after 2 ns;
	
    process
    begin
	wait for 5 ns;
	button_n(0)<='0';
	wait for 100 ns;
	button_n(0)<='1';
	button_n(1)<='0';
	switch(8 downto 0)<=std_logic_vector(to_unsigned(10,9));
	switch(9)<='1';
	wait for 10 ns;
	switch(8 downto 0)<=std_logic_vector(to_unsigned(20,9));
	switch(9)<='0';
	wait for 400000 ns;
	
	

    end process;

end TB;