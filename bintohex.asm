.model small
.stack 100h
.data
    ; messages
    msgstar     db 0dh, 0ah, 0dh, 0ah, "*******************************************************************************", 0dh, 0ah, "$"
    msgintro    db "PROGRAM FUNCTION", 0dh, 0ah, "TO CONVERT 4-BIT BINARY NUMBER INTO HEXADECIMAL NUMBER", "$"
    msginput    db 0dh, 0ah, 0dh, 0ah, "Enter a 4-Bit Binary Number: $"
    msgafter    db "Hexadecimal Conversion: $"
    msgagain    db 0dh, 0ah, 0dh, 0ah, "Do you want to try again? (Y/N): $", 0dh, 0ah, "$"
    msginvalid  db 0dh, 0ah, "Invalid input! Please enter a valid 4-bit binary number.", 0dh, 0ah, "$"
    msgexit     db 0dh, 0ah, "Exiting the program...", 0dh, 0ah, "$"

.code
main proc
    mov ax, @data
    mov ds, ax

    mov dx, offset msgstar ; display start (decoration)
    mov ah, 9
    int 21h

    mov dx, offset msgintro ; display intro message
    mov ah, 9
    int 21h

    mov dx, offset msgstar ; display start (decoration)
    mov ah, 9
    int 21h

input_loop:
    mov dx, offset msginput ; display input message
    mov ah, 9
    int 21h

    mov cx, 4 ; set maximum 4 bits

    xor bx, bx ; clear BX register for storing the binary number
    xor dx, dx ; clear DX register for hexadecimal conversion

input:
    mov ah, 01h ; read a character
    int 21h

    cmp al, 0Dh ; check for Enter key
    je convert

    cmp al, '0' ; compare with '0'
    je set_bit_0
    cmp al, '1' ; compare with '1'
    je set_bit_1

    jmp invalid_input

set_bit_0:
    shl bx, 1 ; shift left by 1
    jmp input

set_bit_1:
    shl bx, 1 ; shift left by 1
    or bx, 1 ; set the lowest bit to 1
    jmp input

convert:
    mov dl, bl ; copy the 4-bit segment to DL register

    cmp dl, 9 ; check if it's 0-9
    jbe convert_digit
    add dl, 7 ; convert to A-F

convert_digit:
    add dl, 30h ; convert to ASCII character

    jmp try_again

try_again:
    mov dx, offset msgafter ; display hexadecimal conversion message
    mov ah, 9
    int 21h

    mov dl, bl ; copy the 4-bit segment to DL register

    cmp dl, 9 ; check if it's 0-9
    jbe convert_digit_after
    add dl, 7 ; convert to A-F

convert_digit_after:
    add dl, 30h ; convert to ASCII character

    mov ah, 02h ; print character
    int 21h

    jmp ask_try_again

ask_try_again:
    mov dx, offset msgagain ; prompt to try again
    mov ah, 9
    int 21h

    mov ah, 01h ; read a key
    int 21h

    cmp al, 'Y'
    je input_loop

exit_program:
    mov dx, offset msgexit ; display exit message
    mov ah, 9
    int 21h

    mov ah, 4Ch ; terminate program function
    mov al, 0 ; return code
    int 21h

invalid_input:
    mov dx, offset msginvalid ; display invalid input message
    mov ah, 9
    int 21h

    jmp ask_try_again

main endp
end main
