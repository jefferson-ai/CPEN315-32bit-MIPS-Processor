-- ============================================================
-- File     : register_file.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Register File (8 x 32-bit registers)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Description:
--   8 general-purpose 32-bit registers (R0..R7).
--   R0 is hardwired to 0x00000000 (read always returns 0).
--   Dual read ports (async), single write port (sync on clk rise).
--   Reset initialises registers with default values.
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    port (
        clk              : in  STD_LOGIC;
        rst              : in  STD_LOGIC;
        reg_write_en     : in  STD_LOGIC;                       -- Write enable
        reg_write_dest   : in  STD_LOGIC_VECTOR(2 downto 0);   -- Dest register addr
        reg_write_data   : in  STD_LOGIC_VECTOR(31 downto 0);  -- Data to write
        reg_read_addr_1  : in  STD_LOGIC_VECTOR(2 downto 0);   -- Read port 1 addr
        reg_read_addr_2  : in  STD_LOGIC_VECTOR(2 downto 0);   -- Read port 2 addr
        reg_read_data_1  : out STD_LOGIC_VECTOR(31 downto 0);  -- Read port 1 data
        reg_read_data_2  : out STD_LOGIC_VECTOR(31 downto 0)   -- Read port 2 data
    );
end Register_File;

architecture Behavioral of Register_File is

    type reg_file_type is array(0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal reg_file : reg_file_type;

begin

    -- Synchronous write + reset
    process(clk, rst)
    begin
        if rst = '1' then
            -- Initialize registers with default values on reset
            reg_file(0) <= x"00000000";  -- R0 always 0
            reg_file(1) <= x"00000001";
            reg_file(2) <= x"00000002";
            reg_file(3) <= x"00000003";
            reg_file(4) <= x"00000004";
            reg_file(5) <= x"00000005";
            reg_file(6) <= x"00000006";
            reg_file(7) <= x"00000007";

        elsif rising_edge(clk) then
            -- Write to register (R0 is read-only, skip write if dest = 0)
            if reg_write_en = '1' and reg_write_dest /= "000" then
                reg_file(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
            end if;
        end if;
    end process;

    -- Asynchronous dual read ports
    -- R0 always reads as 0
    reg_read_data_1 <= x"00000000" when reg_read_addr_1 = "000"
                       else reg_file(to_integer(unsigned(reg_read_addr_1)));

    reg_read_data_2 <= x"00000000" when reg_read_addr_2 = "000"
                       else reg_file(to_integer(unsigned(reg_read_addr_2)));

end Behavioral;
