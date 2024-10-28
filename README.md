# Pipelined-RV32I-Processor

## Project Overview
This repository contains the design and implementation of a single-cycle RISC-V processor supporting the RV32I instruction set architecture (ISA). Our processor is developed to execute all the RV32I instructions accurately within a single clock cycle, providing efficient processing capabilities for 32-bit RISC-V based applications.

### Contributors
- *Kareem Elnaghy*
- *Jana Elfeky*

## Features
- **Complete RV32I Instruction Support**: The processor currently supports all mandatory RV32I instructions as specified in the RISC-V ISA.
- **Single-Cycle Execution**: Designed with a single-cycle datapath, ensuring that each instruction completes in one clock cycle.
- **Modular Verilog Design**: The project is organized modularly to separate components such as ALU, Control Unit, and Register File, ensuring easier testing and maintenance.

## Release Notes

### Assumptions
- **No Additional Assumptions Made**: All design decisions strictly adhere to the RV32I specification.

### Implemented Functionality
- **Supported Instructions**: All RV32I instructions are implemented and verified to function correctly.
- **Execution Flow**: Instructions execute in a single clock cycle with correct state updates to registers and memory.

### Unimplemented Instructions
The following instructions are defined as no-operations (`NOP`) within this implementation:
- `ebreak`
- `pause`
- `fence`
- `fence.tso`

These instructions are placeholders and have no functional impact on the processor's current operation.

### Known Issues
- **None**: There were no issues encountered during the development or testing phases of this implementation.

