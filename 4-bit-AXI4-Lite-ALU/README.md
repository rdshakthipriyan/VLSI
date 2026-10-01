# 4-bit FPGA ALU with AXI4-Lite

## Overview

A 4-bit FPGA ALU implemented in Verilog and integrated
with a Zynq-7000 Processing System using a custom AXI4-Lite interface.

## Architecture

Python / PYNQ
      ↓
Zynq ARM Cortex-A9
      ↓
AXI4-Lite
      ↓
Custom AXI ALU IP
      ↓
4-bit ALU

## ALU Operations

| OP | Operation |
|----|-----------|
| 000 | ADD |
| 001 | SUB |
| 010 | AND |
| 011 | OR |
| 100 | XOR |
| 101 | NOT |
| 110 | SHIFT LEFT |
| 111 | SHIFT RIGHT |

## Register Map

| Address | Function |
|---------|----------|
| 0x00 | A |
| 0x04 | B |
| 0x08 | Operation |
| 0x0C | Result + Flags |

## Verification

- 15/15 RTL test cases passed
- Full design synthesis successful
- Implementation successful
- Timing requirements met
- Bitstream successfully generated

## Target

- FPGA: XC7Z020CLG400-1
- Board: PYNQ-Z2
- Vivado: 2026.1

## Status

RTL simulation, synthesis, implementation and bitstream generation completed.

Physical PYNQ-Z2 validation is pending.