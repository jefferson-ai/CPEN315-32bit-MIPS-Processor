-- ============================================================
-- File     : data_memory.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Data Memory
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Description:
--   256-entry synchronous data memory, each entry 32 bits wide.
--   Write: on rising clock edge when mem_write_en = '1'.
--   Read : synchronous when mem_read = '1', else outputs zero.
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory is
    port (
        clk             : in  STD_LOGIC;
        mem_access_addr : in  STD_LOGIC_VECTOR(31 downto 0);  -- Address
        mem_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);  -- Data to write
        mem_write_en    : in  STD_LOGIC;                       -- Write enable
        mem_read        : in  STD_LOGIC;                       -- Read enable
        mem_read_data   : out STD_LOGIC_VECTOR(31 downto 0)   -- Data read out
    );
end Data_Memory;

architecture Behavioral of Data_Memory is

    -- 256 x 32-bit RAM
    type data_mem_type is array(0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal RAM : data_mem_type := (others => x"00000000");

    signal ram_addr : integer range 0 to 255;

begin

    -- Address: use lower 8 bits as index
    ram_addr <= to_integer(unsigned(mem_access_addr(7 downto 0)));

    process(clk)
    begin
        if rising_edge(clk) then
            -- Write operation
            if mem_write_en = '1' then
                RAM(ram_addr) <= mem_write_data;
            end if;

            -- Read operation
            if mem_read = '1' then
                mem_read_data <= RAM(ram_addr);
            else
                mem_read_data <= x"00000000";
            end if;
        end if;
    end process;

end Behavioral;
