;two-digit decimal to binary (fail)
print macro str 
    mov ah, 09h 
    lea dx, str
    int 21h
    endm

.model small
.stack 100h
.data 
    msg db "Enter 2-digit Decimal Number: $"
    msg1 db 0dh, 0ah, "Binary Number is: $"
    numhold db 0

.code 
main proc
    mov ax, @data
    mov ds, ax

    print msg

    mov cx, 2

    loop1:
        cmp cx, 1
        je loop2 ; cx=2 false 
        mov ah, 01h
        int 21h
        sub al, 48
        mov cl, al 
        mov al, cl 
        mov bl, 10
        mul bl ; ax
        add numhold, al
        loop loop2

    loop2:
        mov ah, 01h
        int 21h
        sub al, 48
        add numhold, al 


    mov al, numhold
    mov ah, 0
    mov bx, 8
    mov dx, 0

    mov cx, 0

    again: 
        div bx
        push dx
        mov ah, 0
        inc cx
        cmp ax, 0
        jne again

    print msg1 

    disp:
        pop dx
        add dx, 48
        mov ah, 02h
        int 21h
        loop disp
        

    mov ah, 4ch
    int 21h
main endp
end main 
