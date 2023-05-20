;two-digit decimal to binary (fail)
print macro str 
    mov ah, 09h 
    lea dx, str
    int 21h
    endm

.MODEL SMALL
.STACK 100H
.DATA

	msginp db "Enter 2-digit Hexadecimal Number: $"
	msgout db "Binary Number: $"
	lfcr db 0ah, 0dh, 24h

.CODE
  
MAIN PROC
	mov ax, @data
	mov ds, ax
	
	print msginp

input:
    mov ah, 00h
    int 16h
    cmp ah, 1ch
    je exit

    mov dl, al          ; Move the input character to DL
    mov ah, 02h
    int 21h             ; Display the input character

    cmp al, '0'
    jb input
    cmp al, '9'
    ja uppercase
    sub al, 30h
    call process
    jmp input

uppercase:
	cmp al, 'A'
	jb input
	cmp al, 'F'
	ja lowercase
	sub al, 37h
	call process
	jmp input

lowercase:
	cmp al, 'a'
	jb input
	cmp al, 'f'
	ja input
	sub al, 57h
	call process
	jmp input

exit:
	int 20h
 
process:
	mov ch, 4
	mov cl, 3
	mov bl, al

print lfcr
print msgout

convert:
	mov al, bl
	ror al, cl
	and al, 01
	add al, 30h

	mov ah, 02h
	mov dl, al
	int 21h

	dec cl
	dec ch
	jnz convert

	ret

MAIN ENDP
END MAIN
