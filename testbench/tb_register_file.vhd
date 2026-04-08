-- ============================================================
-- File     : tb_register_file.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Register File Testbench (Task 3)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Task 3 Test Cases:
--   Write and read:
--     Register 1: 1934858
--     Register 3: 8558447
--     Register 5: 203848544
--     Register 7: 20670420
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Register_File is
end tb_Register_File;

architecture Behavioral of tb_Register_File is

    component Register_File
        port (
            clk              : in  STD_LOGIC;
            rst              : in  STD_LOGIC;
            reg_write_en     : in  STD_LOGIC;
            reg_write_dest   : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_write_data   : in  STD_LOGIC_VECTOR(31 downto 0);
            reg_read_addr_1  : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_read_addr_2  : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_read_data_1  : out STD_LOGIC_VECTOR(31 downto 0);
            reg_read_data_2  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal clk              : STD_LOGIC := '0';
    signal rst              : STD_LOGIC := '0';
    signal reg_write_en     : STD_LOGIC := '0';
    signal reg_write_dest   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal reg_write_data   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal reg_read_addr_1  : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal reg_read_addr_2  : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal reg_read_data_1  : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_read_data_2  : STD_LOGIC_VECTOR(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Register_File port map (
        clk              => clk,
        rst              => rst,
        reg_write_en     => reg_write_en,
        reg_write_dest   => reg_write_dest,
        reg_write_data   => reg_write_data,
        reg_read_addr_1  => reg_read_addr_1,
        reg_read_addr_2  => reg_read_addr_2,
        reg_read_data_1  => reg_read_data_1,
        reg_read_data_2  => reg_read_data_2
    );

    clk_proc: process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        -- Reset
        rst <= '1'; wait for CLK_PERIOD;
        rst <= '0'; wait for CLK_PERIOD;

        -- -------------------------------------------------------
        -- Task 3.i : Write values to registers 1, 3, 5, 7
        -- -------------------------------------------------------

        -- Write 1934858 to Register 1
        reg_write_dest <= "001";
        reg_write_data <= STD_LOGIC_VECTOR(to_unsigned(1934858, 32));
        reg_write_en   <= '1';
        wait for CLK_PERIOD;

        -- Write 8558447 to Register 3
        reg_write_dest <= "011";
        reg_write_data <= STD_LOGIC_VECTOR(to_unsigned(8558447, 32));
        wait for CLK_PERIOD;

        -- Write 203848544 to Register 5
        reg_write_dest <= "101";
        reg_write_data <= STD_LOGIC_VECTOR(to_unsigned(203848544, 32));
        wait for CLK_PERIOD;

        -- Write 20670420 to Register 7
        reg_write_dest <= "111";
        reg_write_data <= STD_LOGIC_VECTOR(to_unsigned(20670420, 32));
        wait for CLK_PERIOD;

        reg_write_en <= '0';
        wait for CLK_PERIOD;

        -- -------------------------------------------------------
        -- Task 3.ii : Read values back from registers 1, 3, 5, 7
        -- -------------------------------------------------------

        -- Read Register 1 and Register 3 simultaneously
        reg_read_addr_1 <= "001";
        reg_read_addr_2 <= "011";
        wait for 5 ns;  -- combinational read, small delay
        assert reg_read_data_1 = STD_LOGIC_VECTOR(to_unsigned(1934858, 32))
            report "FAIL Task3: Register 1 should be 1934858" severity error;
        assert reg_read_data_2 = STD_LOGIC_VECTOR(to_unsigned(8558447, 32))
            report "FAIL Task3: Register 3 should be 8558447" severity error;
        report "Task3 R1: " & integer'image(to_integer(unsigned(reg_read_data_1)));
        report "Task3 R3: " & integer'image(to_integer(unsigned(reg_read_data_2)));

        -- Read Register 5 and Register 7
        reg_read_addr_1 <= "101";
        reg_read_addr_2 <= "111";
        wait for 5 ns;
        assert reg_read_data_1 = STD_LOGIC_VECTOR(to_unsigned(203848544, 32))
            report "FAIL Task3: Register 5 should be 203848544" severity error;
        assert reg_read_data_2 = STD_LOGIC_VECTOR(to_unsigned(20670420, 32))
            report "FAIL Task3: Register 7 should be 20670420" severity error;
        report "Task3 R5: " & integer'image(to_integer(unsigned(reg_read_data_1)));
        report "Task3 R7: " & integer'image(to_integer(unsigned(reg_read_data_2)));

        -- R0 must always read as 0
        reg_read_addr_1 <= "000";
        wait for 5 ns;
        assert reg_read_data_1 = x"00000000"
            report "FAIL: R0 should always read as 0" severity error;
        report "R0 hardwired zero check: " & integer'image(to_integer(unsigned(reg_read_data_1)));

        report "===== Register File Testbench Complete =====";
        std.env.stop;
        wait;
    end process;

end Behavioral;
