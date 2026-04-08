# CPEN 315 — 32-bit Single-Cycle MIPS Processor in VHDL

**University of Ghana — School of Engineering Sciences**
**Department of Computer Engineering — 2025/2026**

## Overview
This project implements the five core components of a 32-bit single-cycle
MIPS processor in VHDL, simulated using GHDL v4.0.0 and GTKWave.

## Components
| File | Description |
|------|-------------|
| `src/alu.vhd` | 32-bit ALU: ADD, SUB, AND, OR, SLT + zero flag |
| `src/alu_control.vhd` | 2-level ALU decoder (ALUOp + funct → alu_control) |
| `src/register_file.vhd` | 8×32-bit registers, R0 hardwired to 0 |
| `src/data_memory.vhd` | 256×32-bit synchronous RAM |
| `src/instruction_memory.vhd` | 16-entry ROM, boundary protection at PC≥32 |
| `src/control_unit.vhd` | 3-bit opcode → 10 datapath control signals |

## Supported Instructions
`add` `sub` `and` `or` `slt` `jr` `lw` `sw` `beq` `addi` `j` `jal` `slti`

## How to Run
```bash
# Compile all source files
ghdl -a --std=08 src/*.vhd

# Compile testbenches
ghdl -a --std=08 testbench/*.vhd

# Run a specific testbench (example: ALU)
ghdl -e --std=08 tb_ALU
ghdl -r --std=08 tb_ALU --vcd=waveforms/tb_alu.vcd
```
Or use the VS Code tasks (`.vscode/tasks.json`) to compile and run all at once.

## Tools
- GHDL v4.0.0 (VHDL-2008)
- GTKWave (waveform viewer)
- Visual Studio Code

## Results
All 5 testbench task groups passed successfully.# CPEN 315 — 32-bit Single-Cycle MIPS Processor (VHDL)
**Part B | VS Code + GHDL**

---

## Project Structure

```
mips32/
├── src/
│   ├── alu.vhd               # Task 2  — ALU (ADD, SUB, AND, OR, SLT)
│   ├── alu_control.vhd       # ALUOp + funct → ALU control signal
│   ├── data_memory.vhd       # Task 1  — 256×32 synchronous RAM
│   ├── register_file.vhd     # Task 3  — 8×32 register file
│   ├── instruction_memory.vhd# Task 4  — ROM with MIPS instructions
│   └── control_unit.vhd      # Task 5  — Main CPU control unit
├── testbench/
│   ├── tb_alu.vhd
│   ├── tb_data_memory.vhd
│   ├── tb_register_file.vhd
│   ├── tb_instruction_memory.vhd
│   └── tb_control_unit.vhd
├── waveforms/                 # VCD files generated after simulation
└── .vscode/
    └── tasks.json             # Run tasks directly in VS Code
```

---

## Setup (Mac M3)

### 1. Install GHDL
```bash
brew install ghdl
```

### 2. Install GTKWave (for viewing waveforms)
```bash
brew install --cask gtkwave
```

### 3. Install VS Code Extension
Search for **"VHDL" by puorc** in the VS Code Extensions panel.

---

## Running Simulations

### Option A — VS Code Tasks (recommended)
Press `Cmd + Shift + P` → **Tasks: Run Task** → choose any task:
- **Run ALL Tests** — compiles and runs everything at once
- **Run: ALU (Task 2)**
- **Run: Data Memory (Task 1)**
- **Run: Register File (Task 3)**
- **Run: Instruction Memory (Task 4)**
- **Run: Control Unit (Task 5)**

### Option B — Terminal (from project root)
```bash
# Compile all sources
ghdl -a --std=08 src/alu.vhd src/alu_control.vhd src/data_memory.vhd \
     src/register_file.vhd src/instruction_memory.vhd src/control_unit.vhd

# Compile testbenches
ghdl -a --std=08 testbench/tb_alu.vhd testbench/tb_data_memory.vhd \
     testbench/tb_register_file.vhd testbench/tb_instruction_memory.vhd \
     testbench/tb_control_unit.vhd

# Elaborate and run a specific testbench (e.g. ALU)
mkdir -p waveforms
ghdl -e --std=08 tb_ALU
ghdl -r --std=08 tb_ALU --vcd=waveforms/tb_alu.vcd
```

### Viewing Waveforms
```bash
gtkwave waveforms/tb_alu.vcd
```

---

## Task Summary

| Task | File | What's tested |
|------|------|---------------|
| 1 | tb_data_memory.vhd | Write/read 1024@addr2, 429496@addr4 |
| 2 | tb_alu.vhd | ADD, SUB, AND, OR, SLT with given values |
| 3 | tb_register_file.vhd | Write/read R1,R3,R5,R7 with large values |
| 4 | tb_instruction_memory.vhd | Fetch add/sub/and/or instructions |
| 5 | tb_control_unit.vhd | Control signals for all 8 opcodes |

---

## Opcode Table

| Instruction | Opcode |
|-------------|--------|
| R-type (add/sub/and/or/slt) | 000 |
| lw  | 001 |
| sw  | 010 |
| beq | 011 |
| addi | 100 |
| j   | 101 |
| jal | 110 |
| slti | 111 |
