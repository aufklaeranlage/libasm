# NASM

## Construction of NASM source lines

**  label:    instruction operand     ; comment**

labels and comments are optional the combination of instruction and operand are determined by their context.

Backslashes '\' are used as the line continuation character.

## Labels

Valid characters in labels are letters, number, _, $, #, @, ~, ., and ?. The only characters whhich may be used as the *first* character of an identifier are letters, ., _ and ?. An identifier may also be prefixed with a $ to indicate that it is intended to be readd as an identifier and not a reserved word.

### Local Lables

NASM gives special treatment to symbols beginning with a period. A label beginnign with a single period is treated as a *local* label, which means that it is associated with the previous non-local label. So for example:

    label1  ; some code

    .loop
            ; some more code

            jne     .loop
            ret

    label2  ; some code

    .loop
            ; some more code

            jne .loop
            ret

In the above code fragment, each **JNE** instruction jumps to the line immediately before it, because the two definitions of **.loop** are kept separate by virtue of each being associated with the previous non-local lable.

This form of local lable handling is borrowed from the old Amiga assembler *DevPac*; howeve, NASM goes one step further, in allowing access to local lables from other parts of the code. This is achieved by means of *defining* a local lable in terms of the previous non-local lable; the first definition of **.loop** above is really defining a symbol called **lable1.loop**, and the second one defines a symbol called **label2.loop**. So if you really neeeded to, you could write:

    lable3  ; some more code
            ; and some more

            jmp lable1.loop

## Instruction

The instruction field may contain any machine instruction, including even undocumented instructions. The instruction may be prefixed by, **LOCK**, **REP**, **REPE**/**REPZ**, **REPNE**, **REPNZ**, **XACQUIRE**/**XRELEASE**, or **BND**/**NOBND** in the usual way. Explicit operand-size prrefixes **A16**, **A32**, **A64**, **O16**, **O32**, and **O64** are provided.

## Pseudo Instructions

## Declaring Data

### Initialzed Data

Initialized Data is generally created with D'x' where x is a specifier of the size of a single element of the declared data

    DB  : declare Byte (8 bits)
    DW  : declare Word (16 bits)
    DD  : declare Double Word (32 bits)
    DQ  : declare Quad Word (64 bits)

Examples:

    db    0x55                ; just the byte 0x55 
    db    0x55,0x56,0x57      ; three bytes in succession 
    db    'a',0x55            ; character constants are OK 
    db    'hello',13,10,'$'   ; so are string constants 
    dw    0x1234              ; 0x34 0x12 
    dw    'a'                 ; 0x61 0x00 (it's just a number) 
    dw    'ab'                ; 0x61 0x62 (character constant) 
    dw    'abc'               ; 0x61 0x62 0x63 0x00 (string) 
    dd    0x12345678          ; 0x78 0x56 0x34 0x12 
    dd    1.234567e20         ; floating-point constant 
    dq    0x123456789abcdef0  ; eight byte constant 
    dq    1.234567e20         ; double-precision float 
    dt    1.234567e20         ; extended-precision float

DT, DO, DY, and DZ do not accept integer numeric constants.

The use of **$** (current address) in a D'x' statement is undefined in the current version of NASM, except in the following cases:

    For the first expression in the statement, either a **DUP** or data item.
    
    An expression of the form "value - $", which is converted to a self-relative\
    relocation.

There is no such restiction on usinng **$$** or section-relative symbols.

### Uninitialized Data

Uninitialized Data is generally created with RES'x' where x is a specifier of the size of a single element of the reserved data

    RESB  : reserve Byte (8 bits)
    RESW  : reserve Word (16 bits)
    RESD  : reserve Double Word (32 bits)
    RESQ  : reserve Quad Word (64 bits)

Examples:

    buffer:         resb    64              ; reserve 64 bytes 
    wordvar:        resw    1               ; reserve a word 
    realarray       resq    10              ; array of ten reals 
    ymmval:         resy    1               ; one YMM register 
    zmmvals:        resz    32              ; 32 ZMM registers

## Including External Binary Files

**INCBIN** includes binary file data verbatim into the output file. This can be handy for (f.e.) including graphics and sound data directly into a game executable file. It can be called in one of these three ways:

    incbin  "file.dat"             ; include the whole file 
    incbin  "file.dat",1024        ; skip the first 1024 bytes 
    incbin  "file.dat",1024,512    ; skip the first 1024, and 
                                   ; actually include at most 512

## EQU: Defining Constants

**EQU** defines a symbol to a given constant value: when EQU is used the source line must contain a label. The action of **EQU** is to define the given label name to the value of its (only) operand. This definiton is absolute, and cannot chage later. So for example,

    message         db      'hello, world' 
    msglen          equ     $-message

defines msglen to be the contant 12. **msglen*** mayy not the be redefined later. This is not a preprocessor definition either: the value of **msglen** is evaluated once, using the value of **$** at the point of definition, rather than being evaluated wherever it is referenced and using the value of **$** at the point of reference.

## TIMES:  Repeating Instructions or Data

The **TIMES** prefix causes the instruction to be assembled multiple times. This is partly present as NASM's equivalent of the **DUP** syntax supported by the MASM-compatible assemblers, in that you can code:

    zerobuf:    times 64 db 0

or similar things, but **TIMES** is more versatile than that. The argument to **TIMES** is not just a numeric constant, but a numeric *expression*, so you cvan do things like

    buffer: db      'hello, world' 
            times 64-$+buffer db ' '

which will store exactly enough spaces to make the total length of **buffer** up to 64.
Finally **TIMES** can be applied to ordinary instructions, so you can code trivial unrolled loops in it:

    times 100 movsb

## Effective Addresses

An effective address is any operand to an instruction which references memory. Effective addresses, in NASM, have a very simple syntax: they consist of an expression evaluating to the desired address, enclosed in square brackets. For example:

    wordvard    dw      123
                mov     ax,[wordvar]
                mov     ax,[wordvar+1]
                mov     ax,[es:wordvar+bx]

Anything not conforming to this simple syntax is not a valid mempry reference in NASM, for example **es:wordvar[bx]**.

More complicated effective addresses, such as those involving more than one register, work in exactly the same way:

    mov     eax,[ebx*2+ecx+offset]
    mov     ax,[bp,di*8]

NASM is capable of doing algebra on these effective addresses, so that things which don't necessarily *look* legal are perfectly alright:

    mov     eax,[ebx*5]             ; assembles as [ebx*4+ebx]
    mov     eax,[label1*2-label2]   ; ie [lable1+(lable1-lable2)]

You can force NASM to generate an effective adddress in a particular form by the use of the keywords **BYTE**, **WORD**, **DWORD**, and **NOSPLIT**. If you need **[eax+3]** to be assembled using a double-word offset field instead of the one byte NASM will normally generate, you can code **[dword eax+3]**. Similarly, you can force NASM to use a byte offset for a small value which it hasn't seen on the first pass by using **[byte eax+offset]**.
This can also be useful to access data in a 32-bit segment from within 16-bit code.

## Constants

### Numeric Constants

A numeric constant is simply a number. NASM allows you to specify numbers in a variety of number bases, in a variety of way: you can suffix **H** or **X**, **D** or **T**, **Q** or **O**, and **B** or **Y** for hexadecimal, decimal, octal and binary respectively. Or you can prefix **0h** or **0x**, **0d** or **0t**, **0q** or **0o**, and **0b** or **0y** in the style of C. A **0** prefix by itself does *not* imply an octal constant.

Numeric constants can have underscorse (_) intersped to break up long strings.

### Character Strings

A character string consists of up to eight characters enclosed in either single qoutes ('...'), double qoutes ("..."), or backqoues (´...´). Single or double qoutes are equivalent in NASME (except of course that surrounding the constant with single quotes allows double quotes to appear within and vice versa).

### Character Constants

A character constant consists of a string up to eight bytes long, used in an expression context. It is treated as if it was an integer.
A character constant with more than one byte will be arranged with little-endian order in mind: if you code 

    mov     eax, 'abcd'

then the constant generated is nt **0x61626364**, but **0x64636261**, so that if you were then to store the value in memoryy it would read **abcd** rather than **dcba**.

### String Constants

String constants are character strings used in the context of some pseudo-instructions, mamely the **DB** family and **INCBIN** (where it represents a filename). They are also ised in vertain preprocessor directives.

A string constant looks like a character constant, only longer. It is treated as a concatenation of maximum-size character constants for the conditions. So the following is equivalent:

    db      'hello'                 ; string constant
    db      'h','e','l','l','o'     ; equivalent character constant

### Unicode Strings

The special operators **__?utf16?__**, **__?utf16le?__**, **__?utf16be?__**, **__?utf32?__**, **__?utf32le?__**, and **__?utf32be?__** allows definition of Unicode strings. They take a string in UTF-8 format and convert it to UTF-16 or UTF-32, repectively. Unless the **be** forms are specified, the output is little endian.

For example:

    %define u(x) __?utf16?__(x) 
    %define w(x) __?utf32?__(x) 

          dw u('C:\WINDOWS'), 0       ; Pathname in UTF-16 
          dd w(`A + B = \u206a`), 0   ; String in UTF-32

### Floating Point Constants

Floating point constants are acceptable only as arguments to **DB**, **DW**, **DD**, **DQ**, **DT**, and **DO**, or as arguments to the special operators of the **__?float*X*?__** family.

The special tokens **__?Infinity?__**, **__?QNaN?__**, (or **__?NaN?__**) and **__?SNaN?__** cna be used to generate infinites, quiet NaNs, and signalling NaNs, respecively. These are normally used as macros.

## Expressions

Expressions in NASM are similar in syntax to those in C. Expressions are evaluated as 64-bit integers which are then adjusted to the appropriate size.

NASM supports two special tokens in expressions, allowing calcilations to involve the current assembly position: the **$** and **$$** tokens.
**$** evaluates to the assembly position at the beginning of the line containing the expression; so you can code an infinite loop using **JMP $**.
**$$** evaluates to the beginning of the current section; so you can tell how far into the section you are by using **($-$$)**.

The arithmetic operators provided by NASM are listed here, in increasing oder of precedence.

A *boolean* value is true if nonzero and false if zero. The operators which return a boolean value always return 1 for true and 0 for false.

### ? (...) : : Conditional Operator

The syntax of this operator, similar to the C conditional operator is:

    boolean ? trueval : falseval

This operator evaluates to *trueval* if *boolean* is ture, otherwise to falseval.

### || : Boolean OR Operator

FACTCHECK

The **||** operator gives a boolean OR: it evaluates to 1 if both sides of the expression are nonzero, otherwise 0.

### ^^ : Boolean XOR Operator

FACTCHECK

The **^^** operator gives a boolean XOR: it evaluates to 1 if any side of the expression is nonzero, otherwise 0.

### && : Boolean AND Operator

The **&&** operator gives a boolean AND: it evaluates to 1 if both sides of the expression are nonzero, otherwise 0.

### Comparison Operators

NASM supports the following comparison operators:

- **=** or **==** compare for equality.
- **!=** or **<>** compare for inequality.
- **<** compares singed less than.
- **<=** compares signed less than or equal.
- **>** compares singed greater than.
- **>=** compares signed greates than or equal.

These operators evaluate to 0 for false and 1 fr true.

- **<=>** does a asinged comparison, and evaluates to -1 for less than, 0 for equal, and 1 for greater than.

### Bitwise Operators

**|**   : bitwise OR, exactly as performed by the **OR** machine instruction.
**^**   : bitwise XOR operation.
**&**   : bitwise AND operation.

### Bitshift operators

**<<**  : gives a bit-shift to the left, jsut as it does in C.
**>>**  : gives an *unsigned* (logical) bit-shift to the right; the bits shifted in from the left are set to zero.

**<<<** : gives a bit-shift to the left exactly equivalent to the **<<** operator; it is included for completeness.
**>>>** : gives an *signed* (arithmetic) bit-shift to the right; the bits shifted in from the left are filled with copies of the most significant (sign) bit.

## STRICT: Inhibiting Optimization

When assembling with the optimizer set to level 2 or higher NASM will use size specifiers, but will give them the smallest possible size. The keyword **STRICT** can be used to inhibit optimization and force a particular operand to be emitted in the specified size.

## Syntax and Quirks

### APX (Advanced Performance Extensions=

Intel APX introduces multiple new features, mostly to existing instructions. APX is only available in 64-bit mode.

### APX : Suppress Modifying FLags (NF)

The **{nf}** prefix on a suppported instruction inhibits the update of the flags, for example:

    {nf} add    rax, rbx

... will add **RAX** and **RBX** together, storing the result in **RAX**; while leaving the flags register unchanged.

NASM also allows the **{nf}** prefix (or any other curly.brace prefix) to be specified *after* the instruction mnemonic. Spaces around curly-brace prefixes are optional:

     {nf} add rax, rbx       ; Standard syntax 
     {nf}add  rax, rbx       ; Prefix without space 
     add {nf} rax, rbx       ; Suffix syntax 
     add{nf}  rax, rbx       ; Suffix without space 

### APX : Zero Upper (ZU)

the **{zu}** prefix can be used meaning - "zero upper", which disables retaining the upper parts of the registers and instead zero-extands the value into the full 64-bit register when the operand size if 8 or 16 bits.

### APX and the NASM optimizer

When the optimizer is enabled, NASM may apply a number of optimizationsm some of which may apply non-APX instructions to what would be APX form. Some examples are:

- The **{nf}** prefix may be ignored on instructions that already don't modify the arithmetic flags.
- When the **{nf}** prefix is specified, NQASM may generate another instruction which would not modify the flags register. For example, **{nf} ror rax, rcx, 3** can be translated into **rorx rax, rcx, 3**.
- The **{zu}** prefix may be ignored on instructions that already zero the upper parts of the destination register.
- When the **{zu}** prefix is specified, NASM may generate another instruction which would zero the upper part of the register. For example, **{zu} mov ax, cs** can be translated into **mov eax, cs**.

## The NASM Preprocessor

1. The Preprocessor first collapses all lines which end with a backslask (\\) into a single line.
2. After concatenation, comments are removed. Comments begin with the character ; unless contained inside a quoted string or a handful of other special contexts.
3. **%line** directives are processed.
4. Conditionals (**%if** family), Multi-line macros (**%macro**, **%imacro**) and preprocessor loops (**%rep**) are processed and stored but not yet expanded.
5. The remaining preprocessor directives are processed.
6. Inline macros, preprocessor functions, macro indirection and token concatenations are expanded. Macro-local lables are converted into unique strings.
7. Multi-line Macros are expanded
8. Detokenization.

### Single-Line Macros

Single-line macros are defined using the **%define** preprocessor directive. The definitions work in a similar way to C; so you can do things like:

    %define ctrl    0x1F &
    %define param(a,b) ((a)+(a)*(b))

        mov     byte [param(2,ebx)], ctrl 'D'

which will expand to

        mov     byte [(2)+(2)*(ebx)], 0x1F & 'D'

When the expansion of a single-line macro contains tokens which invoke another macro, the expansion is performed at invocation time. Thus the code:

    %define a(x)    1+b(x)
    %define b(x)    2*(x)

        mov         ax,a(8)

will evaluate in the expected way to **mov ax,1+2\*8**, even though the macro **b** wasn't defined at the time of definition of **a**.
If instead you want to have a reference to an embedded single-line macro resoved at the time that the embedding macro is *defined*, as opposed to when the embedding macro is *expanded*, you need a different mechanism to the one offered by **%define**. The solutionis to use **%xdefine**, or it's case insensitive coutnerpart **%ixdefine**.

**%define** is case sensitive, if you want to use the case insensitve version instead use **%idefine**.

### Macro indirection: %[...]

The **%[...]** construct can be used to expand macros in contexts where macro expansion would otherwise not occur, including in the names of other macros. For example, if you have a set of macros named **Foo16**, **Foo32** and **Foo64**, you could write:

    mov ax,Foo%[__?BITS?__] ; The Foo value

to use the builtin macro **__?BITS?__** to automatically select between them. Similarly, the two statements:

    %xdefine Bar         Quux    ; Expands due to %xdefine 
    %define  Bar         %[Quux] ; Expands due to %[...]

have, in fact, exactly the same effect.

### Concatenating Single Line Macro Tokens: %+

Individual tokens in single line macros can be concatenated, to produce longer tokens for later processing. This can be useful if there are several similar macros that perform similar functions.

An example, considering the following:

    %define BDASTART 400h                ; Start of BIOS data area

    struc   tBIOSDA                      ; its structure 
            .COM1addr       RESW    1 
            .COM2addr       RESW    1 
            ; ..and so on 
    endstruc

Now, if we need to acces the elements of *tBIOSDA* in different places, we can end uo with:

    mov     ax,BDASTART + tBIOSDA.COM1addr
    mov     bx,BDASTART + tBIOSDA.COM2addr

This will become pretty ugly (and tedious) if ised in many places, and can be reduced in size significantly by using the following macro:

    ; Macro to access BIOS variables by their names (from tBDA):

    %define BDA(x)  BDASTART + tBIOSDA. %+ x

Now the above code can be written as:

    mov     ax,BDA(COM1addr)
    mov     bx,BDA(COM2addr)

### The Macro Name Itself: %? and %??

The special symbols **%?** and **%??** can be used to reference the macro name itself inside a macro expansion, this is supported for both single-and multi-line macros. **%?** refers to the macro name as *invoked*, whereas **%??** refers to the macro name as *declared*. The two are always the same for case-sensitive macros, but for case-insensitive macro, they can differ.

For example:

    %imacro Foo 0
            mov %?,%??
    %endmacro

            foo
            FOO

will expand to:

            mov foo,Foo
            mov FOO,Foo

### The Single-Line Macro Name: %\*? and %\*??

If the tokens **%?** and **%??** are used inside a multi-line macro, they are expanded before any directives are processed. As a result,

    %imacro Foo 0 
          %idefine Bar _%? 
          mov BAR,bAr 
    %endmacro 

          foo 
          mov eax,bar

will expand to:

          mov _foo,_foo 
          mov eax,_foo

which may or may not be what you expected. The tokens **%\*?** and **%\*??** behave like **%?** and **%??** but are onl expanded inside single-line macros. Thus:

    %imacro Foo 0 
          %idefine Bar _%*? 
          mov BAR,bAr 
    %endmacro 

          foo 
          mov eax,bar

will expand to:

          mov _BAR,_bAr 
          mov eax,_bar

### Undefining Single-Line Macros: %undef

Single-line macros can be removed with the **%undef** directive.

## Memory allocation in Assembly

### Making memory writeable

Assembly has certain sections that are statically allocated. They differ in their use (read/write, read-only), and their initialization (pre-initialized with certain data, pre-initialized to zeros).

| NAME | USE | DESCRIPTION |
| ---- | --- | ----------- |
| .data | r/w data | Inititalized, potentially with pre set values, can be modified. |
| .rodata | r/o data | Initialized, can't be modified. |
| .bss | r/w space | Initialized to zero, can be modified. |
| .text | r/o code | The programs executable code. |

In C and C++, global or static variables get stored in `.data` if you give them an initial value. If they don't have an initial value, they're put into `.bss` to get zero-initialized on load. If they are `const`, they go in `.rodata`.

### Dynamic allocation with malloc

`malloc` is the standard C way to allocate memory from "the heap", the area of memory where most of a program's stuff is stored.

In assembly `malloc` can be called by declaring it as an external function and calling it with the proper parameters set in the registers. If the C library is linked againt this code it will work.

```
    extern malloc

section .text
    mov     rdi, 8 ; a byte count to allocate (8 * BYTE = QWORD)
    call    malloc
    mov     QWORD rax[], 0x3 ; rax contains a pointer to our writeable byte
```

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
