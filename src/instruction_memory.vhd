-- ============================================================
-- File     : instruction_memory.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Instruction Memory (ROM)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Description:
--   Read-only instruction memory holding 32-bit MIPS instructions.
--   Addressed by lower 4 bits of the 32-bit PC (16 entries max).
--   Returns 0x00000000 when PC >= 0x00000020 (32 instructions).
--
-- Task 4 instructions preloaded (32-bit MIPS encoding):
--   Addr 0: add  $t0, $t1, $t2  -> 000000 01001 01010 01000 00000 100000
--   Addr 2: sub  $t2, $t2, $t3  -> 000000 01010 01011 01010 00000 100010
--   Addr 4: and  $t1, $t2, $t0  -> 000000 01010 01000 01001 00000 100100
--   Addr 6: or   $t2, $t3, $t1  -> 000000 01011 01001 01010 00000 100101
--
-- Register mapping (Task 4 note):
--   $t0 = R1 (reg addr 001)
--   $t1 = R3 (reg addr 011)
--   $t2 = R5 (reg addr 101)
--   $t3 = R7 (reg addr 111)
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory is
    port (
        pc          : in  STD_LOGIC_VECTOR(31 downto 0);  -- Program Counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)   -- Fetched instruction
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    -- ROM: 16 entries of 32-bit instructions
    type rom_type is array(0 to 15) of STD_LOGIC_VECTOR(31 downto 0);

    -- 32-bit MIPS instruction encoding:
    -- R-format: op(6) rs(5) rt(5) rd(5) shamt(5) funct(6)
    -- For our 16-bit adapted format with 3-bit fields:
    -- op(3) rs(3) rt(3) rd(3) shamt(3) funct(3) padding(14)
    --
    -- Task 4 instructions using 3-bit register fields:
    --   add $t0,$t1,$t2 : op=000 rs=011 rt=101 rd=001 shamt=000 funct=000
    --   sub $t2,$t2,$t3 : op=000 rs=101 rt=111 rd=101 shamt=000 funct=001
    --   and $t1,$t2,$t0 : op=000 rs=101 rt=001 rd=011 shamt=000 funct=010
    --   or  $t2,$t3,$t1 : op=000 rs=111 rt=011 rd=101 shamt=000 funct=011

    constant rom_data : rom_type := (
        -- Addr 0: add $t0, $t1, $t2
        0  => "000" & "011" & "101" & "001" & "000" & "000" & "00000000000000",
        -- Addr 1: sub $t2, $t2, $t3
        1  => "000" & "101" & "111" & "101" & "000" & "001" & "00000000000000",
        -- Addr 2: and $t1, $t2, $t0
        2  => "000" & "101" & "001" & "011" & "000" & "010" & "00000000000000",
        -- Addr 3: or  $t2, $t3, $t1
        3  => "000" & "111" & "011" & "101" & "000" & "011" & "00000000000000",
        -- Remaining entries: NOP (all zeros)
        others => x"00000000"
    );

    signal rom_addr : integer range 0 to 15;

begin

    rom_addr <= to_integer(unsigned(pc(3 downto 0)));

    instruction <= x"00000000" when unsigned(pc) >= x"00000020"
                   else rom_data(rom_addr);

end Behavioral;
