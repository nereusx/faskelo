section .data
	bgn_of_message	db	"Πάρτα άρρωστε!", 0xa
	end_of_message	db	0

section .text
	global _start
_start:
	mov	rax, bgn_of_message
	mov rdx, end_of_message
	sub rdx, rax		; RDX = end - begin, the string length
	mov	rsi, bgn_of_message
	mov	rdi, 1			; file handle, (1) 0 = stdout
	mov	rax, 1			; kernel's syscall, file write routine
	syscall				; call kernel - print string
	xor	rdi, rdi		; exit code
	mov	rax, 0x3c		; kernel's syscall, exit routine
	syscall				; call kernel - end of programm
