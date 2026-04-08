-- ============================================================
-- File     : alu_control.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : ALU Control Unit
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Description:
--   Decodes ALUOp (from main control unit) and funct field
--   (from R-type instructions) to produce 3-bit ALU control.
--
--   ALUOp | Instruction Type  | ALU Action
--   ------+-------------------+-----------
--    00   | Load/Store (lw/sw)| ADD
--    01   | Branch (beq)      | SUB
--    10   | R-type            | Use funct field
--    11   | ADDI              | ADD
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control is
    port (
        ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0);  -- From main CU
        ALU_Funct   : in  STD_LOGIC_VECTOR(2 downto 0);  -- funct[2:0] from instruction
        ALU_Control_Out : out STD_LOGIC_VECTOR(2 downto 0)   -- To ALU
    );
end ALU_Control;

architecture Behavioral of ALU_Control is
begin

    process(ALUOp, ALU_Funct)
    begin
        case ALUOp is
            when "00" =>  -- lw / sw: always ADD
                ALU_Control_Out <= "000";

            when "01" =>  -- beq: always SUB
                ALU_Control_Out <= "001";

            when "10" =>  -- R-type: use funct field
                -- funct: 000=ADD, 001=SUB, 010=AND, 011=OR, 100=SLT
                ALU_Control_Out <= ALU_Funct(2 downto 0);

            when "11" =>  -- addi: always ADD
                ALU_Control_Out <= "000";

            when others =>
                ALU_Control_Out <= "000";
        end case;
    end process;

end Behavioral;
