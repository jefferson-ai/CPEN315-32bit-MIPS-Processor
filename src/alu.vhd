-- ============================================================
-- File     : alu.vhd
-- Project  : 32-bit Single-Cycle MIPS Processor
-- Module   : Arithmetic Logic Unit (ALU)
-- Author   : CPEN 315 Group
-- Date     : 2026
-- ============================================================
-- Description:
--   32-bit ALU supporting ADD, SUB, AND, OR, SLT operations.
--   Outputs a zero flag when result == 0 (used for BEQ).
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port (
        a           : in  STD_LOGIC_VECTOR(31 downto 0);  -- Operand A
        b           : in  STD_LOGIC_VECTOR(31 downto 0);  -- Operand B
        alu_control : in  STD_LOGIC_VECTOR(2  downto 0);  -- Operation select
        alu_result  : out STD_LOGIC_VECTOR(31 downto 0);  -- Result
        zero        : out STD_LOGIC                        -- Zero flag
    );
end ALU;

architecture Behavioral of ALU is
    signal result : STD_LOGIC_VECTOR(31 downto 0);
begin

    process(alu_control, a, b)
    begin
        case alu_control is
            when "000" =>  -- ADD
                result <= STD_LOGIC_VECTOR(signed(a) + signed(b));

            when "001" =>  -- SUB
                result <= STD_LOGIC_VECTOR(signed(a) - signed(b));

            when "010" =>  -- AND
                result <= a and b;

            when "011" =>  -- OR
                result <= a or b;

            when "100" =>  -- SLT (Set on Less Than)
                if signed(a) < signed(b) then
                    result <= x"00000001";
                else
                    result <= x"00000000";
                end if;

            when others =>  -- Default: ADD
                result <= STD_LOGIC_VECTOR(signed(a) + signed(b));
        end case;
    end process;

    -- Zero flag: high when result is zero (used by BEQ)
    zero       <= '1' when result = x"00000000" else '0';
    alu_result <= result;

end Behavioral;
