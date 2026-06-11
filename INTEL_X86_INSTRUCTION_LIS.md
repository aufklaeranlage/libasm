# Intel x86 Instruction List

r : register
m : memory address
imm : immediate

DF : Direction flag

| Instruction | Meaning | Notes |
| :---------- | :------ | :---- |
| ADC | Add with carry | |
| ADD | Add | |
| AND | Logical AND | |
| CALL | Call procedure | push eip; eip points to the instruction directly after the call |
| CBW | Convert byte ot word | AX = AL ; signe extended |
| CLC | Clear carry flag | CF = 0 |
| CLD | Clear direction flag | DF = 0 |
| CLI | Clear interrupt flag | IF = 0 |
| CMC | Complement carry flag | CF = !CF |
| CMP | Compare operands | |
| CMPSB | Compare bytes. | Only compare the lowest byte of the specified registers or memory. |
| CMPSW | Compare words. | Only compare the lowest word of the specified registers or memory. |
| CWD | Convert word to doubleword | |
| DEC | Decrement by 1 | |
| DIV | Unsigned divide | (1) AX = DX:AX / r/m; DX = remainder (2) AL = AX / r/m; AH = remainder; |
| IDIV | Signed divide | ie |
| IMUL | Signed multiply in one-operand form | (1) DX:AX = AX * r/m; (2) AX = AL * r/m; |
| IN | Input from port | |
| INC | Increment by 1 | |
| INT | Call to interrupt | |
| INTO | Call to interrupt if overflow |
| IRET | Return from interrupt | |
| Jcc | Jump if condition | Conditions are created by combining J with at least one and at max three of the following letters that hold a meaning that can be combinied for certain cases: 'A' : above, 'B' : below, 'E' : equal, 'G' : greater, 'L' : lower, 'N' : not , 'Z' : zero, 'S' : sign, 'O' : overflow | 
| JCXZ | Jump if CX is zero | JECXZ for ECX instead of CX in 32 bit mode |
| JMP | Unconditional jump | |
| LAHF | Load FLAGS into AH register | |
| LDS | Load DS:r with far pointer |r = m; DS = 2 + m; |
| LEA | Load Effective Address | |
| LES | Load ES:r with far pointer | r = m; ES = 2 + m; |
| LOCK | Assert BUS LOCK# signal | for multiprocessing |
| LODSB | Load string byte. may be used with REP prefix to repeat the instruction CX times. | if (DF==0) AL = *SI++; else AL = *SI-- |
| LODSW | Load string word. May be used with REP rpefix to repeat the instruction CX times | if (DF==0) AX = *SI++; else AX = *SI--; |
| LOOP / LOOPx | Loop control | (LOOPE, LOOPNE, LOOPNZ, LOOPZ) if (x && --CX) goto lbl; |
| MOV | Move | |
| MOVSB | Move byte from string to string. May be used with a REP prefix to repeat the instruction CX times | |
| MOVSW | Move word from string to string. May be used with a REP prefix to repeat the instruction CX times | |
| MUL | Unsigned multiply | (1) DX:AX = AX * r/m; (2) AX = AL * r/m; |
| NEG | Two's complement negation | r/m = 0 - r/m |
| NOP | No operation | |
| NOT | Negate the operand, logical NOT | r/m ^= -1; |
| OR | Logical OR | (1) r |= r/m/imm; (2) m |= r/imm; |
| OUT | Output to port | |
| POP | Pop data from stack | r/m/sreg = *SP++; |
| POPF | Pop FLAGS register from stack | FLAGS = *SP++; |
| PUSH | Push data onto stack | *--SP = r/m/sreg; |
| PUSHF | Push FLAGS onto stack | *--SP = FLAGS; |
| RCL | Rotate left (with carry) | |
| RCR | Rotate right (with carry) | |
| REPxx | Repeat MOVX/STOS/CMPS/LODS/SCAS | REP, REPE REPNE, REPNZ, REPZ |
| RET | Return from procedure | |
| RETN | Return from near procedure | |
| RETF | Return from far procedure | |
| ROL | Rotate left | |
| ROR | Rotate right | |
| SAHF | Store AH into FLAGS | |
| SAL | Shift arithmetically left (signed shift left ) | (1) r/m <<= 1; (2) r/m <<= CL; |
| SAR | Shift arithmetically rigth (signed shift rigth) | (1) r/m >>= 1; (2) r/m >>= CL; |
| SCASB | Compare byte string | if (DF==0) AL - *ES:DI++; else AL - *ES:DI--; |
| SCASW | Compare byte string | if (DF==0) AX - *ES:DI++; else AX -*ES:DI--; |
| SHL | Shift left (unsigned shift left) | Same as SAL since logical left shiftts and arithmetical lefft shifts are equal. |
| SHR | Shift right (unsigned shift right) | |
| STC | Set carry flag | CF = 1; |
| STD | Set direction flag | DF = 1; |
| STI | Set interrupt flag | IF = 1; |
| STOSB | Store byte in string. May be used with a REP prefixx to repeat the instruction CX times. | if (DF==0) *ES:DI++ = AL; else *ES:DI-- = AL; |
| STOSW | Store word in string. May be used with a REP prefixx to repeat the instruction CX times. | if (DF==0) *ES:DI++ = AX; else *ES:DI-- = AX; |
| SUB | Subtraction | (1) r -= r/m/umm; (2) m -= r/imm; |
| TEST | Logical compare (AND) | |
| WAIT | Wait until not busy | Waits untily BUSY# pin is inactive. |
| XOR | Exclusive OR | |
