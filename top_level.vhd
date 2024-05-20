library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
		  clk	     : in  std_logic;
        switch   : in  std_logic_vector(9 downto 0);
        button_n : in  std_logic_vector(1 downto 0);
        led0     : out std_logic_vector(6 downto 0);
        led0_dp  : out std_logic;
        led1     : out std_logic_vector(6 downto 0);
        led1_dp  : out std_logic;
        led2     : out std_logic_vector(6 downto 0);
        led2_dp  : out std_logic;
        led3     : out std_logic_vector(6 downto 0);
        led3_dp  : out std_logic;
        led4     : out std_logic_vector(6 downto 0);
        led4_dp  : out std_logic;
        led5     : out std_logic_vector(6 downto 0);
        led5_dp  : out std_logic
        );
end top_level;


architecture STR of top_level is

    signal rst       : std_logic;
	 signal inportsel : std_logic_vector(1 downto 0);
    signal outport   : std_logic_vector(31 downto 0);
    signal inport0   : std_logic_vector(9 downto 0);
    signal inport1   : std_logic_vector(9 downto 0);

begin  -- STR
	led0_dp<= not inportsel(0); --sel
	led1_dp<= not inportsel(1); --enable
	led2_dp<= not rst;
	led3_dp<= not inport0(1);
	
    -- the buttons are active low
    rst <= not button_n(0); --rst
	 inportsel(1)<= not button_n(1); --enable
	 inportsel(0)<= switch(9); --select
	 inport0<='0' & switch(8 downto 0);
	 inport1<='0' & switch(8 downto 0);
		
    -- map output to two LEDs
    U_LED5 : entity work.decoder7seg port map (
        input  => outport(23 downto 20),
        output => led5);

    U_LED4 : entity work.decoder7seg port map (
        input  => outport(19 downto 16),
        output => led4);

    -- all other LEDs should display 0
    U_LED3 : entity work.decoder7seg port map (
        input  => outport(15 downto 12),
        output => led3);

    U_LED2 : entity work.decoder7seg port map (
        input  => outport(11 downto 8),
        output => led2);

    U_LED1 : entity work.decoder7seg port map (
        input  => outport(7 downto 4),
        output => led1);
	
    U_LED0 : entity work.decoder7seg port map (
        input  => outport(3 downto 0),
        output => led0);

    U_datapath : entity work.datapath
			port map (
            clk    	=> clk,
            rst    	=> rst,
				inport0	=>inport0,
				inport1	=>inport1,
				inportsel=>inportsel,
				outport	=>outport);

end STR;
