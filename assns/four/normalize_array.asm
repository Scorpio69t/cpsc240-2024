;****************************************************************************************************************************
; Program name: "Variance".  This program calculates the variance of a list of doubles.     *
;                                                                                                                            *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
; but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
; the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
; <https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************


;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Steven Hicken
;  Author email: sahicken@csu.fullerton.edu
;
;Program information
;  Program name: Variance
;  Programming languages: 3 modules in C, 3 in X86, 1 in C++, and 2 in bash.
;  Date program began: 2024-Mar-1
;  Date of last update: 2024-Mar-17
;  Files in this program: driver.c, manager.asm, isfloat.asm, compute_variance.cpp, r.sh, rg.sh, input_array.asm, output_array.c, compute_mean.asm
;  Testing: done
;  Status: working
;
;Purpose
;  This program inputs arrays (double precision) and calculates variance
;
;This file:
;  File name: file.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l file.lis -o file.o file.asm
;  Assemble (debug): nasm -f elf64 -gdwarf -l file.lis -o file.o file.asm
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: int file();
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

;========= Begin source code ====================================================================================
;Declaration area

; name of "this" asm file/fxn
global normalize_array

section .bss

align 64
; required for xstor and xrstor instructions
backup_storage_area resb 832

section .text

normalize_array:

;BEGIN .TEXT PREREQS
; backup GPRs (General Purpose Registers)
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

; backup all other registers (meaning not GPRs)
mov rax,7
mov rdx,0
xsave [backup_storage_area]
;END .TEXT PREREQS



mov r13, rdi   ; pointer to front of array
mov r14, rsi   ; size of array (# elements)
;mov r15, 0    ; counter = 0 (change to rcx)
sub rsp, 1024  ; set asisde space on stack
mov rcx, r13   ; we're using rcx now

begin:

mov r12, [r13 + 8 * rcx]  ; Copies "float" into r register

shl r12, 12 ; 0x4A93 4D97 C26A F000 <= Shift left 12 bits
shr r12, 12 ; 0x0004 A934 D97C 26AF <= Shift right 12 bits
mov rax, 0x3FF0000000000000 ; Create a mask with 3FF at front
or r12, rax ; Combine the mask with the shifted numb

mov [r13 + 8 * rcx], r12  ; moves in normalized float

loop begin

add rsp, 1024

;BEGIN .TEXT POSTREQS
;Restore the values to non-GPRs
mov rax,7
mov rdx,0
xrstor [backup_storage_area]

;return value size
mov rax, r13

;Restore the GPRs
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp   ;Restore rbp to the base of the activation record of the caller program
ret
;END .TEXT POSTREQS (BROKEN)
