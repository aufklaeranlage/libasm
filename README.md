# libasm - an introduction to 64-bit assembly

## Calling convention

The subject only asks for 64-bit calling conventions. But I couldn't find anything that specified just 64-bit callign conventions so I decided to go for the x86 calling conventions since the system this was written on is a x86-64 system.

Calling conventiosn describe the interface of called code:

- The order in which atomic (scalar) parameters, or individual parts of a complex parameter, are allocated
- How parameters are passed (pushed on the stack, placed in registers, or a mix of both)
- Which registers the called function must preserver for the caller (also known as: callee-saved registers or non-volatile registers)
- How the task of preparing the stack for, and restoring after, a function call is divided between the called and the callee

### Register preservation

#### Caller-saved (volatile) registers

EAX, EDX and ECX are to be free for use withing a procedure, and need not be preserved.

AS the name implies, these general-purpose registers usually hold temporary (volatile) information, that can be overwritten by any subroutine.

Therefore, it is the callers responsibility to push each of these registers onto the stack, if it would like to restore their values after a subrouting call.

#### Callee-saved (non-volatile) registers

The other registers are used to hold long-lived values (non-volatile), that should be preserved across calls.

In other words, when the caller makes a procedure call, it can expect that those registers will hold the same value after the callee returns.

Thus, making it the callees responsibility to both save (push at the start) and restore (pop accordingly) them before returning to the caller. As in the prior case, this practice should only be done on registers that the callee changes.

### Passing arguments

Integer and pointers are passed to the callee in registers for argument 1-6 and
on the stack for arguments 7 and above.

The integer and pointer arguments are stored in the registers in this order:

    RDI, RSI, RDX, RCX, R8, R9

The floating point arguments are passed in the floating point registers for argument 1-8 and excess arguments are passed on the stack.

The floating point arguments are stored in the registers in this order:

    XMM0, XMM1, XMM2, XMM3, XMM4, XMM5, XMM6, XMM7

Since the stack also contains the original stack pointer and the address in the code we want to return to we need to access the parameters on the stack with an offset of 0x10 (size of 2 * 64bits for two pointers).

Since the stack grows downwards we need to push the later arguments before the earlier once.
