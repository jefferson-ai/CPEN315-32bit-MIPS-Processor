#!/bin/bash
# ============================================================
# run_all.sh — Compile, simulate, and generate VCD waveforms
# CPEN 315: 32-bit Single-Cycle MIPS Processor
# Usage: chmod +x run_all.sh && ./run_all.sh
# ============================================================

set -e  # Exit on any error

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  CPEN 315 — MIPS32 Simulation Runner${NC}"
echo -e "${CYAN}=============================================${NC}"

# Create waveforms output directory
mkdir -p waveforms

# -------------------------------------------------------
# Step 1: Compile all source files
# -------------------------------------------------------
echo -e "\n${CYAN}[1/3] Compiling source files...${NC}"
ghdl -a --std=08 \
  src/alu.vhd \
  src/alu_control.vhd \
  src/data_memory.vhd \
  src/register_file.vhd \
  src/instruction_memory.vhd \
  src/control_unit.vhd
echo -e "${GREEN}  ✓ Sources compiled${NC}"

# -------------------------------------------------------
# Step 2: Compile all testbenches
# -------------------------------------------------------
echo -e "\n${CYAN}[2/3] Compiling testbenches...${NC}"
ghdl -a --std=08 \
  testbench/tb_alu.vhd \
  testbench/tb_data_memory.vhd \
  testbench/tb_register_file.vhd \
  testbench/tb_instruction_memory.vhd \
  testbench/tb_control_unit.vhd
echo -e "${GREEN}  ✓ Testbenches compiled${NC}"

# -------------------------------------------------------
# Step 3: Elaborate + Run each testbench → VCD output
# -------------------------------------------------------
echo -e "\n${CYAN}[3/3] Running simulations...${NC}"

run_tb() {
  local ENTITY=$1
  local VCD=$2
  local LABEL=$3
  echo -e "\n  → ${LABEL}"
  ghdl -e --std=08 "$ENTITY"
  ghdl -r --std=08 "$ENTITY" --vcd="waveforms/${VCD}" --stop-time=500ns
  echo -e "  ${GREEN}✓ waveforms/${VCD} generated${NC}"
}

run_tb "tb_ALU"               "tb_alu.vcd"               "Task 2: ALU"
run_tb "tb_Data_Memory"       "tb_data_memory.vcd"       "Task 1: Data Memory"
run_tb "tb_Register_File"     "tb_register_file.vcd"     "Task 3: Register File"
run_tb "tb_Instruction_Memory" "tb_instruction_memory.vcd" "Task 4: Instruction Memory"
run_tb "tb_Control_Unit"      "tb_control_unit.vcd"      "Task 5: Control Unit"

# -------------------------------------------------------
# Summary
# -------------------------------------------------------
echo -e "\n${CYAN}=============================================${NC}"
echo -e "${GREEN}  ALL SIMULATIONS COMPLETE${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
echo "VCD files in waveforms/:"
ls -lh waveforms/*.vcd 2>/dev/null || echo "  (none found)"
echo ""
echo "Open in GTKWave:"
echo "  gtkwave waveforms/tb_alu.vcd"
echo "  gtkwave waveforms/tb_data_memory.vcd"
echo "  gtkwave waveforms/tb_register_file.vcd"
echo "  gtkwave waveforms/tb_instruction_memory.vcd"
echo "  gtkwave waveforms/tb_control_unit.vcd"
