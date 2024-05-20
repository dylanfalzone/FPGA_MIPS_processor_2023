
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity regfile is 
	port(
		clk 		: in std_logic;
		rst		: in std_logic;
		rd_addr1	: in std_logic_vector(4 downto 0); --ReadReg1
		rd_addr2 : in std_logic_vector(4 downto 0); --ReadReg2
		wr_addr 	: in std_logic_vector(4 downto 0); --WriteReg
		wr_en	   : in std_logic;					     --RegWrite
		wr_Data	: in std_logic_vector(31 downto 0); --WriteData
		jnl		: in std_logic;						  --JumpAndLink
		rd_data1 : out std_logic_vector(31 downto 0);--ReadData1
		rd_data2 : out std_logic_vector(31 downto 0)--ReadData2
	);
end regfile;

architecture arch_regfile of regfile is
	type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
	signal regs : reg_array;
    
begin
    process (clk, rst) is
    begin
        if (rst = '1') then
            for i in regs'range loop
                regs(i) <= (others => '0');
            end loop;
        elsif (rising_edge(clk)) then
            if (wr_en = '1') then
					if(jnl='1') then
						regs(31)<=wr_data;
					else
                regs(to_integer(unsigned(wr_addr))) <= wr_data;
					end if;
            end if;

            rd_data1 <= regs(to_integer(unsigned(rd_addr1)));
            rd_data2 <= regs(to_integer(unsigned(rd_addr2)));
        end if;
    end process;
end arch_regfile;