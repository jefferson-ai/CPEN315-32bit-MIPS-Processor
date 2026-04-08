-- ============================================================
-- File     : tb_control_unit.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Control Unit Testbench (Task 5)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Task 5: Display control signals for:
--   add (000), slti (111), j (101), jal (110),
--   lw  (001), sw  (010), beq (011), addi (100)
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Control_Unit is
end tb_Control_Unit;

architecture Behavioral of tb_Control_Unit is

    component Control_Unit
        port (
            opcode       : in  STD_LOGIC_VECTOR(2 downto 0);
            reset        : in  STD_LOGIC;
            reg_dst      : out STD_LOGIC_VECTOR(1 downto 0);
            mem_to_reg   : out STD_LOGIC_VECTOR(1 downto 0);
            alu_op       : out STD_LOGIC_VECTOR(1 downto 0);
            jump         : out STD_LOGIC;
            branch       : out STD_LOGIC;
            mem_read     : out STD_LOGIC;
            mem_write    : out STD_LOGIC;
            alu_src      : out STD_LOGIC;
            reg_write    : out STD_LOGIC;
            sign_or_zero : out STD_LOGIC
        );
    end component;

    signal opcode       : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal reset        : STD_LOGIC := '0';
    signal reg_dst      : STD_LOGIC_VECTOR(1 downto 0);
    signal mem_to_reg   : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_op       : STD_LOGIC_VECTOR(1 downto 0);
    signal jump         : STD_LOGIC;
    signal branch       : STD_LOGIC;
    signal mem_read     : STD_LOGIC;
    signal mem_write    : STD_LOGIC;
    signal alu_src      : STD_LOGIC;
    signal reg_write    : STD_LOGIC;
    signal sign_or_zero : STD_LOGIC;

    -- Helper: convert std_logic_vector to binary string (GHDL-compatible)
    function slv_to_str(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length);
        variable idx    : integer := 1;
    begin
        for i in slv'left downto slv'right loop
            if slv(i) = '1' then
                result(idx) := '1';
            else
                result(idx) := '0';
            end if;
            idx := idx + 1;
        end loop;
        return result;
    end function;

    -- Helper: print all control signals
    procedure print_signals(name : string) is
    begin
        report name & " | reg_dst=" & slv_to_str(reg_dst)
             & " mem_to_reg=" & slv_to_str(mem_to_reg)
             & " alu_op=" & slv_to_str(alu_op)
             & " jump=" & std_logic'image(jump)
             & " branch=" & std_logic'image(branch)
             & " mem_read=" & std_logic'image(mem_read)
             & " mem_write=" & std_logic'image(mem_write)
             & " alu_src=" & std_logic'image(alu_src)
             & " reg_write=" & std_logic'image(reg_write)
             & " sign_or_zero=" & std_logic'image(sign_or_zero);
    end procedure;

begin

    uut: Control_Unit port map (
        opcode       => opcode,
        reset        => reset,
        reg_dst      => reg_dst,
        mem_to_reg   => mem_to_reg,
        alu_op       => alu_op,
        jump         => jump,
        branch       => branch,
        mem_read     => mem_read,
        mem_write    => mem_write,
        alu_src      => alu_src,
        reg_write    => reg_write,
        sign_or_zero => sign_or_zero
    );

    stim_proc: process
    begin
        reset <= '1'; wait for 10 ns;
        reset <= '0'; wait for 10 ns;

        -- Task 5: Display control signals for each instruction

        -- add (R-type, opcode = 000)
        opcode <= "000"; wait for 20 ns;
        print_signals("add  (000)");

        -- slti (opcode = 111)
        opcode <= "111"; wait for 20 ns;
        print_signals("slti (111)");

        -- j (opcode = 101)
        opcode <= "101"; wait for 20 ns;
        print_signals("j    (101)");
        assert jump = '1'
            report "FAIL: j should assert jump=1" severity error;

        -- jal (opcode = 110)
        opcode <= "110"; wait for 20 ns;
        print_signals("jal  (110)");
        assert jump = '1' and reg_write = '1'
            report "FAIL: jal should assert jump=1 and reg_write=1" severity error;

        -- lw (opcode = 001)
        opcode <= "001"; wait for 20 ns;
        print_signals("lw   (001)");
        assert mem_read = '1' and reg_write = '1'
            report "FAIL: lw should assert mem_read=1 and reg_write=1" severity error;

        -- sw (opcode = 010)
        opcode <= "010"; wait for 20 ns;
        print_signals("sw   (010)");
        assert mem_write = '1' and reg_write = '0'
            report "FAIL: sw should assert mem_write=1, reg_write=0" severity error;

        -- beq (opcode = 011)
        opcode <= "011"; wait for 20 ns;
        print_signals("beq  (011)");
        assert branch = '1'
            report "FAIL: beq should assert branch=1" severity error;

        -- addi (opcode = 100)
        opcode <= "100"; wait for 20 ns;
        print_signals("addi (100)");
        assert alu_src = '1' and reg_write = '1'
            report "FAIL: addi should assert alu_src=1 and reg_write=1" severity error;

        report "===== Control Unit Testbench Complete =====";
        std.env.stop;
        wait;
    end process;

end Behavioral;
