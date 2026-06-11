# Calling Conventions

<https://cs61.seas.harvard.edu/site/2018/Asm2/>

Harvard focuses on the x86-64 calling conventions for Linux.

<https://en.wikipedia.org/wiki/X86_calling_conventions#x86-64_calling_conventions>

These are shared with may other OSes and officially called **System V AMD64 ABI** (offficial specification <https://software.intel.com/sites/default/files/article/402129/mpx-linux64-abi.pdf>)


## Argument passing and stack frames

On x86-64 Linux, the first six function arguments are passed in the registers **%rdi**, **%rsi**, **%rdx**, **%rcx**, **%r8**, and **%r9** respectively. The seventh and subsequent arguments are passed on the stack. The return value is passed in register **%rax**.

There are a couple of exceptions for this concering structs floats and large return values:

1. A struct argument that first in a single machine word (64 bits/8bytes) is passed in a single register.
2. A struct that fits in two or four machine words (16-32 bytes) is passed in sequential registers, as if it were multiple arguments.
3. A struct that's larger than four machine words is always passed on the stack.
4. Floating point arguments are generally passed in special registes, the **SSE registers**.
5. If the return value takes more than eight bytes, then the *caller* reserves space for the return value, and passes the *address* of that space as the first argument of the function. The callee will fill in that space when it returns.

The portion of the stack reserved for a function is called that function's **stack frame**. Stack frames are aligned: x86-64 requires that each stack frame be a multiple of 16 bytes, an when a **CALL** instruction begins execution, the **RSP** register must be 16-byte aligned. This means that every function's entry **RSP** address will be 8 bytes off a multiple of 16.

## Return address, entry and exit sequence

The steps required to call a function are sometimes called the *entry sequence* an the steps required to  return are caled the *exit sequence*. Both caller and callee have reponsibilities in each sequence.

To prepare a function call, the caller performs the following tasks in its entry sequence:

1. The caller stores the first six arguments in the correspondign registers.
2. If the callee takes more than six arguments, of if some of its arguments are large, the caller must store the surplus arguments on its stack fram. It stores these in increasing order, so that the 7th argument has a smaller address than the 8th argument and so forth. The 7th argument must be stored at **RSP** when the caller executes its **CALL** instruction.
3. The caller saves any caller-saved registers.
4. The caller executes **CALL** *FUNCTION*, which has an effect like **PUSH QWORD $NEXT_INSTRUCTION**; JMP *FUNCTION***, where **$NEXT_INSTRUCTION** is the address of the instruction immediately following **CALL**.

To return from a function:

1. The callee places its return value in **RAX**.
2. The callee restores the stack pointer ot its value at entry, if necessary.
3. The callee executes the **RET** instruction.
4. The caller then cleans up any space it prepared for arguments and restores caller-saved registers if necessary.

## Callee-saved registers and caller-saved registers

The calling convention gives callers and callees certain guarantees and responsibilities about the values of registes across function calls. Function implementations may expect these guarantees to hold, and must work to fulfill their reponsibilities.

The most important rsponsibility is that certain register's values *must be preserved across function calls*. A callee may use these registers, but if it changes them, it must restore them to their original values before returning. These registers are called **callee-saved registers**. All other registers are **caller-saved**.

On x86-64 Linux, **RSP**, **RBX**, **R12**, **R13**, **R14**, and **R15** are callee-saved, as (sort of) are **RSP** and **RIP**.

## Base pointer

The **RBP** register is called the base pointer. For complex functions **RBP** is used in a specific pattern that facilitates debugging. It works like this:

1. The first instruction executed on function entry is **PUSH QWORD RBP** this saves the caller's value for **RBP** into the callee's stack.
2. The second instruction is **MOV QWORD RSP, RBP**. This saves the current stack pointer in **RBP** (so **RBP** = entry **RSP** - 8).

This adjusted value of **RBP** is the callee's *frame pointer*. The ccvallee will not change this value until it returns. The frame pointer provides a stable reference point for local variables and caller arguments.
This also ensures that the value stored at  **[RBP]** is the *caller's* **RBP** and the value stored a **[RBP+8]** is the return address. THis information can be used to trace backwards through caller's stack frames by functions such as debuggers.

3. The function ends with **MOV QWORD RBP, RSP; POP QWORD RBP; RET**. This sequence restores the caller's **RBP** and entry **RSP** before returning.

## Branches

Branches are jumps to specific instructions without saving the return address on the stack.
They come in two flavors, unconditional and conditional. The **JMP** instruction executes an unnconditional branch. All other branch instructions are conditional: they branch if some condition holds. That condition is represented by **condition flags** that are set as a side effect of every arithmetic operation.

Arithmetic instructions change part of the **FLAGS** register as a side effect of their operation. The most often used flags are:

- **ZF** (zero flag): set if the result was zero.
- **SF** (sign flag): set if themost significant bit (the sign bit) of the result was one (i.e., the result was negative if considered as a signed integer).
- **CF** (carry flag): set if the result overflowed when considered as a unsigned (i.e., the result was greater than 2^(W)-1).
- **OF** (overflow flag): set if the result overflowed when considered as signed (i.e., the result was greater than 2^(W)-1 or less than 2^(W-1))

The **TEST** and **CMP** instructions are fequently seen before a conditional branch. These operatiosn perform arithmetic but throw away the result, except for condition codes. **TEST** performs binary-and, **CMP** performs subtraction.

