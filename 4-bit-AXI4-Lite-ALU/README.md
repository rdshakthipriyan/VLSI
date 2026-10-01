# 4-bit FPGA ALU with AXI4-Lite

A 4-bit FPGA Arithmetic Logic Unit (ALU) implemented in Verilog and integrated with a Zynq-7000 Processing System using a custom AXI4-Lite interface.

## Overview

This project demonstrates the design and integration of a small RTL datapath into a processor-based FPGA system.

The ALU supports arithmetic, logical, and shift operations and generates carry, zero, and signed-overflow status flags.

The ALU was verified using XSim and integrated as a custom AXI4-Lite IP in AMD Vivado.

## System Architecture

```text
                Python / PYNQ
                     |
                     v
             Zynq ARM Cortex-A9
                     |
                  AXI4-Lite
                     |
                     v
             +---------------+
             |  Custom AXI   |
             |    ALU IP     |
             +-------+-------+
                     |
                     v
             +---------------+
             |    4-bit ALU  |
             +-------+-------+
                     |
                     v
            Result + Status Flags
```

## ALU Operations

| OP | Operation |
|----|-----------|
| `000` | ADD |
| `001` | SUB |
| `010` | AND |
| `011` | OR |
| `100` | XOR |
| `101` | NOT A |
| `110` | SHIFT LEFT |
| `111` | SHIFT RIGHT |

## Status Flags

The ALU generates three status flags:

| Flag | Description |
|------|-------------|
| Carry | Carry/borrow indication |
| Zero | Set when the result is `0` |
| Overflow | Indicates signed arithmetic overflow |

For this implementation, subtraction uses the carry output to indicate a borrow condition.

## AXI4-Lite Register Map

The custom AXI4-Lite IP provides four memory-mapped registers.

| Address | Register | Description |
|---------|----------|-------------|
| `0x00` | A | 4-bit operand A |
| `0x04` | B | 4-bit operand B |
| `0x08` | OP | 3-bit ALU operation |
| `0x0C` | RESULT | Result and status flags |

### Result Register Format

```text
31             7 6       5      4       3          0
+---------------+---------+------+-------+-----------+
|      0        |Overflow | Zero | Carry |   Result  |
+---------------+---------+------+-------+-----------+
```

- Bits `[3:0]` → ALU result
- Bit `[4]` → Carry
- Bit `[5]` → Zero
- Bit `[6]` → Overflow
- Bits `[31:7]` → `0`

## RTL Verification

The ALU was verified using an XSim testbench.

### Verification Results

**15/15 test cases passed**

The testbench covers:

- Addition
- Subtraction
- AND
- OR
- XOR
- NOT
- Left shift
- Right shift
- Carry generation
- Borrow detection
- Zero detection
- Signed addition overflow
- Signed subtraction overflow

## FPGA Implementation

### Target Platform

| Parameter | Value |
|-----------|-------|
| FPGA | XC7Z020CLG400-1 |
| Board | PYNQ-Z2 |
| FPGA Family | Zynq-7000 |
| Vivado | 2026.1 |

### Standalone ALU Synthesis

| Resource | Utilization |
|----------|-------------|
| Slice LUTs | 17 |
| Slice Registers | 0 |
| BRAM | 0 |
| DSP | 0 |

The ALU is implemented as combinational RTL, so no sequential registers are required inside the standalone ALU datapath.

## Timing Results

The complete Vivado design successfully completed implementation.

| Timing Metric | Result |
|---------------|--------|
| WNS | `+10.79 ns` |
| TNS | `0.000 ns` |
| WHS | `+0.075 ns` |
| THS | `0.000 ns` |

A bitstream was successfully generated for the implemented design.

## Vivado Block Design

The custom ALU was packaged as an AXI4-Lite peripheral and integrated with the Zynq-7000 Processing System using AXI SmartConnect.

![Vivado Block Design](Vivado/block-design.png)

### Block Design Architecture

```text
Zynq-7000 Processing System
          |
          | M_AXI_GP0
          v
    AXI SmartConnect
          |
          | AXI4-Lite
          v
     Custom axi_alu IP
          |
          v
       4-bit ALU
```

The Zynq Processing System acts as the AXI master, while the custom `axi_alu` IP operates as an AXI4-Lite slave. The processor communicates with the ALU through memory-mapped registers for operands, operation selection, result, and status flags.

The Processor System Reset block provides synchronized reset signals for the AXI interconnect and custom peripheral, while the Zynq processing system provides the clock used by the AXI interface.

## Repository Structure

```text
4-bit-AXI4-Lite-ALU/
|
├── README.md
├── .gitignore
|
├── rtl/
|   ├── alu.v
|   ├── axi_alu.v
|   └── axi_alu_slave_lite_v1_0_S00_AXI.v
|
├── Simulation/
|   └── alu_tb.v
|
└── Vivado/
    └── design_1.tcl
```

## Technologies Used

- Verilog HDL
- RTL Design
- FPGA Design
- AMD Vivado 2026.1
- XSim
- AXI4-Lite
- Zynq-7000
- AXI SmartConnect
- PYNQ
- Python

## Current Status

| Stage | Status |
|-------|--------|
| RTL Design | Completed |
| RTL Simulation | Completed |
| AXI4-Lite IP Packaging | Completed |
| Block Design Integration | Completed |
| Synthesis | Completed |
| Implementation | Completed |
| Timing Analysis | Completed |
| Bitstream Generation | Completed |
| Physical PYNQ-Z2 Testing | Pending hardware availability |

## Project Goal

This project was developed to gain hands-on experience in:

- Verilog RTL design
- Combinational datapath design
- ALU architecture
- AXI4-Lite interfacing
- Custom Vivado IP development
- Zynq processor-FPGA integration
- RTL verification
- FPGA synthesis and implementation
- Timing analysis