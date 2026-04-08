-- ============================================================
-- File     : tb_alu.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : ALU Testbench (Task 2)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Task 2 Test Cases:
--   i.   ADD  2500    + 25000
--   ii.  SUB  540250  - 37800
--   iii. AND  53957  AND 30000
--   iv.  OR   746353  OR  846465
--   v.   SLT  58847537 < 72464383 ?
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ALU is
end tb_ALU;

architecture Behavioral of tb_ALU is

    -- Component under test
    component ALU
        port (
            a           : in  STD_LOGIC_VECTOR(31 downto 0);
            b           : in  STD_LOGIC_VECTOR(31 downto 0);
            alu_control : in  STD_LOGIC_VECTOR(2  downto 0);
            alu_result  : out STD_LOGIC_VECTOR(31 downto 0);
            zero        : out STD_LOGIC
        );
    end component;

    signal a           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal b           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal alu_control : STD_LOGIC_VECTOR(2  downto 0) := "000";
    signal alu_result  : STD_LOGIC_VECTOR(31 downto 0);
    signal zero        : STD_LOGIC;

begin

    uut: ALU port map (
        a           => a,
        b           => b,
        alu_control => alu_control,
        alu_result  => alu_result,
        zero        => zero
    );

    stim_proc: process
    begin

        -- -------------------------------------------------------
        -- Task 2.i : ADD 2500 + 25000 = 27500
        -- -------------------------------------------------------
        a           <= STD_LOGIC_VECTOR(to_unsigned(2500,  32));
        b           <= STD_LOGIC_VECTOR(to_unsigned(25000, 32));
        alu_control <= "000";  -- ADD
        wait for 20 ns;
        assert alu_result = STD_LOGIC_VECTOR(to_unsigned(27500, 32))
            report "FAIL Task2.i: ADD 2500+25000" severity error;
        report "Task2.i ADD: result = " & integer'image(to_integer(unsigned(alu_result)));

        -- -------------------------------------------------------
        -- Task 2.ii : SUB 540250 - 37800 = 502450
        -- -------------------------------------------------------
        a           <= STD_LOGIC_VECTOR(to_unsigned(540250, 32));
        b           <= STD_LOGIC_VECTOR(to_unsigned(37800,  32));
        alu_control <= "001";  -- SUB
        wait for 20 ns;
        assert alu_result = STD_LOGIC_VECTOR(to_unsigned(502450, 32))
            report "FAIL Task2.ii: SUB 540250-37800" severity error;
        report "Task2.ii SUB: result = " & integer'image(to_integer(unsigned(alu_result)));

        -- -------------------------------------------------------
        -- Task 2.iii : AND 53957 & 30000
        -- 53957  = 0x0000D2A5
        -- 30000  = 0x00007530
        -- result = 0x00005020 = 20512
        -- -------------------------------------------------------
        a           <= STD_LOGIC_VECTOR(to_unsigned(53957, 32));
        b           <= STD_LOGIC_VECTOR(to_unsigned(30000, 32));
        alu_control <= "010";  -- AND
        wait for 20 ns;
        report "Task2.iii AND: result = " & integer'image(to_integer(unsigned(alu_result)));

        -- -------------------------------------------------------
        -- Task 2.iv : OR 746353 | 846465
        -- -------------------------------------------------------
        a           <= STD_LOGIC_VECTOR(to_unsigned(746353, 32));
        b           <= STD_LOGIC_VECTOR(to_unsigned(846465, 32));
        alu_control <= "011";  -- OR
        wait for 20 ns;
        report "Task2.iv OR: result = " & integer'image(to_integer(unsigned(alu_result)));

        -- -------------------------------------------------------
        -- Task 2.v : SLT 58847537 < 72464383 → result should be 1
        -- -------------------------------------------------------
        a           <= STD_LOGIC_VECTOR(to_unsigned(58847537, 32));
        b           <= STD_LOGIC_VECTOR(to_unsigned(72464383, 32));
        alu_control <= "100";  -- SLT
        wait for 20 ns;
        assert alu_result = x"00000001"
            report "FAIL Task2.v: SLT 58847537 < 72464383 should be 1" severity error;
        report "Task2.v SLT: result = " & integer'image(to_integer(unsigned(alu_result)));

        -- -------------------------------------------------------
        -- Zero flag check: SUB equal values → zero='1'
        -- -------------------------------------------------------
        a           <= x"0000ABCD";
        b           <= x"0000ABCD";
        alu_control <= "001";  -- SUB
        wait for 20 ns;
        assert zero = '1'
            report "FAIL: Zero flag should be 1 when a=b with SUB" severity error;
        report "Zero flag test: zero = " & std_logic'image(zero);

        report "===== ALU Testbench Complete =====";
        wait;
    end process;

end Behavioral;
