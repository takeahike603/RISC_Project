# AJC_RISC
An 8-bit reduced instruction set computer complete with 16 instructions. This is a 3-bus Harvard design with Separate-Mapped Input/Output peripherals.
# Instructions:
1. Add
2. Subtract
3. Increment
4. Decrement
5. Shift Right Arithmetic
6. Shift Left Logic
7. Rotate Right Through Carry
8.  Copy
9.  AND
10. OR
11. XOR
12. Load
13. Store
14. In
15. Out
16. Jump
# Files
AJCRISC_CU
  Control unit for RISC. Described behaviorally with case statement, determines which control signals are needed based on the current machine cycle.
AJCRISC_DP
  Data path for RISC. Described structurally using modules designed in previous labs. Also included a RAM and ROM, created using Quartus' megafunction wizard. Manipulates data based on signals passed from the CU.
AJCRISC_HSMIOP
  .mif file that initialized the ROM. Includes the instructions to be executed.
