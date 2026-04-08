-- ============================================================
-- File     : control_unit.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Main CPU Control Unit
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Description:
--   Decodes the 3-bit opcode from each instruction and asserts
--   the appropriate control signals for the datapath.
--
-- Opcode Table (3-bit):
--   000 = R-type  (add, sub, and, or, slt, jr)
--   001 = lw      (load word)
--   010 = sw      (store word)
--   011 = beq     (branch if equal)
--   100 = addi    (add immediate)
--   101 = j       (jump)
--   110 = jal     (jump and link)
--   111 = slti    (set less than immediate)
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    port (
        opcode       : in  STD_LOGIC_VECTOR(2 downto 0);  -- Instruction opcode
        reset        : in  STD_LOGIC;                      -- Reset signal

        -- Datapath control outputs
        reg_dst      : out STD_LOGIC_VECTOR(1 downto 0);  -- Dest reg select
        mem_to_reg   : out STD_LOGIC_VECTOR(1 downto 0);  -- Mem/ALU to reg
        alu_op       : out STD_LOGIC_VECTOR(1 downto 0);  -- ALU operation type
        jump         : out STD_LOGIC;                      -- Jump signal
        branch       : out STD_LOGIC;                      -- Branch signal
        mem_read     : out STD_LOGIC;                      -- Memory read enable
        mem_write    : out STD_LOGIC;                      -- Memory write enable
        alu_src      : out STD_LOGIC;                      -- ALU 2nd operand src
        reg_write    : out STD_LOGIC;                      -- Register write enable
        sign_or_zero : out STD_LOGIC                       -- Sign/zero extend
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
begin

    process(reset, opcode)
    begin
        if reset = '1' then
            -- Default: all signals deasserted
            reg_dst      <= "00";
            mem_to_reg   <= "00";
            alu_op       <= "00";
            jump         <= '0';
            branch       <= '0';
            mem_read     <= '0';
            mem_write    <= '0';
            alu_src      <= '0';
            reg_write    <= '0';
            sign_or_zero <= '0';

        else
            case opcode is

                -- -----------------------------------------------
                -- R-type: add, sub, and, or, slt, jr
                -- -----------------------------------------------
                when "000" =>
                    reg_dst      <= "01";  -- rd field selects dest
                    mem_to_reg   <= "00";  -- ALU result to reg
                    alu_op       <= "10";  -- Use funct field
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';  -- 2nd operand from register
                    reg_write    <= '1';
                    sign_or_zero <= '0';

                -- -----------------------------------------------
                -- lw: load word
                -- -----------------------------------------------
                when "001" =>
                    reg_dst      <= "00";  -- rt field selects dest
                    mem_to_reg   <= "01";  -- Memory data to reg
                    alu_op       <= "00";  -- ADD (compute address)
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '1';
                    mem_write    <= '0';
                    alu_src      <= '1';  -- 2nd operand from immediate
                    reg_write    <= '1';
                    sign_or_zero <= '1';  -- Sign extend immediate

                -- -----------------------------------------------
                -- sw: store word
                -- -----------------------------------------------
                when "010" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "00";  -- ADD (compute address)
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '1';
                    alu_src      <= '1';  -- 2nd operand from immediate
                    reg_write    <= '0';
                    sign_or_zero <= '1';  -- Sign extend immediate

                -- -----------------------------------------------
                -- beq: branch if equal
                -- -----------------------------------------------
                when "011" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "01";  -- SUB (compare)
                    jump         <= '0';
                    branch       <= '1';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';  -- 2nd operand from register
                    reg_write    <= '0';
                    sign_or_zero <= '1';

                -- -----------------------------------------------
                -- addi: add immediate
                -- -----------------------------------------------
                when "100" =>
                    reg_dst      <= "00";  -- rt field selects dest
                    mem_to_reg   <= "00";  -- ALU result to reg
                    alu_op       <= "11";  -- ADD
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '1';  -- 2nd operand from immediate
                    reg_write    <= '1';
                    sign_or_zero <= '1';  -- Sign extend

                -- -----------------------------------------------
                -- j: jump
                -- -----------------------------------------------
                when "101" =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "00";
                    jump         <= '1';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '0';
                    sign_or_zero <= '0';

                -- -----------------------------------------------
                -- jal: jump and link
                -- -----------------------------------------------
                when "110" =>
                    reg_dst      <= "10";  -- R7 (return address reg)
                    mem_to_reg   <= "10";  -- PC+4 written to R7
                    alu_op       <= "00";
                    jump         <= '1';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '1';  -- Write return addr to R7
                    sign_or_zero <= '0';

                -- -----------------------------------------------
                -- slti: set less than immediate
                -- -----------------------------------------------
                when "111" =>
                    reg_dst      <= "00";  -- rt field selects dest
                    mem_to_reg   <= "00";  -- ALU result to reg
                    alu_op       <= "10";  -- SLT
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '1';  -- 2nd operand from immediate
                    reg_write    <= '1';
                    sign_or_zero <= '1';  -- Sign extend

                when others =>
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "00";
                    jump         <= '0';
                    branch       <= '0';
                    mem_read     <= '0';
                    mem_write    <= '0';
                    alu_src      <= '0';
                    reg_write    <= '0';
                    sign_or_zero <= '0';

            end case;
        end if;
    end process;

end Behavioral;
