-- ============================================================
-- File     : tb_instruction_memory.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Instruction Memory Testbench (Task 4)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Task 4 Test Cases:
--   Read instructions at addresses 0, 2, 4, 6:
--     Addr 0: add $t0, $t1, $t2
--     Addr 2: sub $t2, $t2, $t3
--     Addr 4: and $t1, $t2, $t0
--     Addr 6: or  $t2, $t3, $t1
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Instruction_Memory is
end tb_Instruction_Memory;

architecture Behavioral of tb_Instruction_Memory is

    component Instruction_Memory
        port (
            pc          : in  STD_LOGIC_VECTOR(31 downto 0);
            instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal pc          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: Instruction_Memory port map (
        pc          => pc,
        instruction => instruction
    );

    stim_proc: process
    begin

        -- Task 4.ii : Read instructions back

        -- Address 0: add $t0, $t1, $t2
        pc <= x"00000000"; wait for 20 ns;
        report "Addr 0 (add): instruction = " & integer'image(to_integer(unsigned(instruction)));
        report "  op=" & integer'image(to_integer(unsigned(instruction(31 downto 29))))
             & " rs=" & integer'image(to_integer(unsigned(instruction(28 downto 26))))
             & " rt=" & integer'image(to_integer(unsigned(instruction(25 downto 23))))
             & " rd=" & integer'image(to_integer(unsigned(instruction(22 downto 20))))
             & " funct=" & integer'image(to_integer(unsigned(instruction(17 downto 15))));

        -- Address 1 (maps to sub $t2, $t2, $t3 in our ROM)
        pc <= x"00000001"; wait for 20 ns;
        report "Addr 1 (sub): instruction = " & integer'image(to_integer(unsigned(instruction)));

        -- Address 2 (and)
        pc <= x"00000002"; wait for 20 ns;
        report "Addr 2 (and): instruction = " & integer'image(to_integer(unsigned(instruction)));

        -- Address 3 (or)
        pc <= x"00000003"; wait for 20 ns;
        report "Addr 3 (or): instruction = " & integer'image(to_integer(unsigned(instruction)));

        -- Address beyond memory limit: should return 0x00000000
        pc <= x"00000020"; wait for 20 ns;
        assert instruction = x"00000000"
            report "FAIL: PC >= 0x20 should return NOP (0x00000000)" severity error;
        report "PC=0x20 (out of range): instruction = " & integer'image(to_integer(unsigned(instruction)));

        report "===== Instruction Memory Testbench Complete =====";
        wait;
    end process;

end Behavioral;
