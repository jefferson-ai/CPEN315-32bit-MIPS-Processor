-- ============================================================
-- File     : tb_data_memory.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Data Memory Testbench (Task 1)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Task 1 Test Cases:
--   i.  Write 1024    to address 2,  then read it back
--   ii. Write 429496  to address 4,  then read it back
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Data_Memory is
end tb_Data_Memory;

architecture Behavioral of tb_Data_Memory is

    component Data_Memory
        port (
            clk             : in  STD_LOGIC;
            mem_access_addr : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_write_en    : in  STD_LOGIC;
            mem_read        : in  STD_LOGIC;
            mem_read_data   : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal clk             : STD_LOGIC := '0';
    signal mem_access_addr : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write_data  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write_en    : STD_LOGIC := '0';
    signal mem_read        : STD_LOGIC := '0';
    signal mem_read_data   : STD_LOGIC_VECTOR(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Data_Memory port map (
        clk             => clk,
        mem_access_addr => mem_access_addr,
        mem_write_data  => mem_write_data,
        mem_write_en    => mem_write_en,
        mem_read        => mem_read,
        mem_read_data   => mem_read_data
    );

    -- Clock generation
    clk_proc: process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        wait for CLK_PERIOD;

        -- -------------------------------------------------------
        -- Task 1.i : Write 1024 to address 2
        -- -------------------------------------------------------
        mem_access_addr <= STD_LOGIC_VECTOR(to_unsigned(2, 32));
        mem_write_data  <= STD_LOGIC_VECTOR(to_unsigned(1024, 32));
        mem_write_en    <= '1';
        mem_read        <= '0';
        wait for CLK_PERIOD;

        -- Read back from address 2
        mem_write_en    <= '0';
        mem_read        <= '1';
        wait for CLK_PERIOD;
        assert mem_read_data = STD_LOGIC_VECTOR(to_unsigned(1024, 32))
            report "FAIL Task1.i: Expected 1024 at address 2" severity error;
        report "Task1.i READ addr 2: data = " & integer'image(to_integer(unsigned(mem_read_data)));
        mem_read <= '0';

        wait for CLK_PERIOD;

        -- -------------------------------------------------------
        -- Task 1.ii : Write 429496 to address 4
        -- -------------------------------------------------------
        mem_access_addr <= STD_LOGIC_VECTOR(to_unsigned(4, 32));
        mem_write_data  <= STD_LOGIC_VECTOR(to_unsigned(429496, 32));
        mem_write_en    <= '1';
        mem_read        <= '0';
        wait for CLK_PERIOD;

        -- Read back from address 4
        mem_write_en    <= '0';
        mem_read        <= '1';
        wait for CLK_PERIOD;
        assert mem_read_data = STD_LOGIC_VECTOR(to_unsigned(429496, 32))
            report "FAIL Task1.ii: Expected 429496 at address 4" severity error;
        report "Task1.ii READ addr 4: data = " & integer'image(to_integer(unsigned(mem_read_data)));
        mem_read <= '0';

        -- -------------------------------------------------------
        -- Verify address 2 still holds 1024 (no corruption)
        -- -------------------------------------------------------
        wait for CLK_PERIOD;
        mem_access_addr <= STD_LOGIC_VECTOR(to_unsigned(2, 32));
        mem_read        <= '1';
        wait for CLK_PERIOD;
        assert mem_read_data = STD_LOGIC_VECTOR(to_unsigned(1024, 32))
            report "FAIL: Address 2 corrupted after writing to address 4" severity error;
        report "Retention check addr 2: data = " & integer'image(to_integer(unsigned(mem_read_data)));

        report "===== Data Memory Testbench Complete =====";
        std.env.stop;
        wait;
    end process;

end Behavioral;
