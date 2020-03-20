	.file	"mdriver.c"
	.text
	.type	clear_ranges, @function
clear_ranges:
.LFB74:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, %rbp
	movq	(%rdi), %rdi
	jmp	.L2
.L3:
	movq	16(%rdi), %rbx
	call	free
	movq	%rbx, %rdi
.L2:
	testq	%rdi, %rdi
	jne	.L3
	movq	$0, 0(%rbp)
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE74:
	.size	clear_ranges, .-clear_ranges
	.type	remove_range, @function
remove_range:
.LFB73:
	.cfi_startproc
	movq	(%rdi), %rax
	jmp	.L6
.L9:
	cmpq	%rsi, (%rax)
	jne	.L7
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	16(%rax), %rdx
	movq	%rdx, (%rdi)
	movq	%rax, %rdi
	call	free
	jmp	.L5
.L7:
	.cfi_def_cfa_offset 8
	leaq	16(%rax), %rdi
	movq	16(%rax), %rax
.L6:
	testq	%rax, %rax
	jne	.L9
	rep ret
.L5:
	.cfi_def_cfa_offset 16
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE73:
	.size	remove_range, .-remove_range
	.type	free_trace, @function
free_trace:
.LFB76:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movq	16(%rdi), %rdi
	call	free
	movq	24(%rbx), %rdi
	call	free
	movq	32(%rbx), %rdi
	call	free
	movq	%rbx, %rdi
	call	free
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	free_trace, .-free_trace
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Usage: mdriver [-hvVal] [-f <file>] [-t <dir>]\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"Options\n"
	.section	.rodata.str1.8
	.align 8
.LC2:
	.string	"\t-a         Don't check the team structure.\n"
	.align 8
.LC3:
	.string	"\t-f <file>  Use <file> as the trace file.\n"
	.align 8
.LC4:
	.string	"\t-g         Generate summary info for autograder.\n"
	.align 8
.LC5:
	.string	"\t-h         Print this message.\n"
	.align 8
.LC6:
	.string	"\t-l         Run libc malloc as well.\n"
	.align 8
.LC7:
	.string	"\t-t <dir>   Directory to find default traces.\n"
	.align 8
.LC8:
	.string	"\t-v         Print per-trace performance breakdowns.\n"
	.align 8
.LC9:
	.string	"\t-V         Print additional debug info.\n"
	.text
	.type	usage, @function
usage:
.LFB86:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rcx
	movl	$47, %edx
	movl	$1, %esi
	movl	$.LC0, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$8, %edx
	movl	$1, %esi
	movl	$.LC1, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$44, %edx
	movl	$1, %esi
	movl	$.LC2, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$42, %edx
	movl	$1, %esi
	movl	$.LC3, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$50, %edx
	movl	$1, %esi
	movl	$.LC4, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$32, %edx
	movl	$1, %esi
	movl	$.LC5, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$37, %edx
	movl	$1, %esi
	movl	$.LC6, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$46, %edx
	movl	$1, %esi
	movl	$.LC7, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$52, %edx
	movl	$1, %esi
	movl	$.LC8, %edi
	call	fwrite
	movq	stderr(%rip), %rcx
	movl	$41, %edx
	movl	$1, %esi
	movl	$.LC9, %edi
	call	fwrite
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE86:
	.size	usage, .-usage
	.section	.rodata.str1.1
.LC11:
	.string	"ops"
.LC12:
	.string	"util"
.LC13:
	.string	" valid"
.LC14:
	.string	"trace"
.LC15:
	.string	"%5s%7s %5s%8s%10s%6s\n"
.LC16:
	.string	"Kops"
.LC17:
	.string	"secs"
.LC20:
	.string	"yes"
	.section	.rodata.str1.8
	.align 8
.LC21:
	.string	"%2d%10s%5.0f%%%8.0f%10.6f%6.0f\n"
	.section	.rodata.str1.1
.LC22:
	.string	"-"
.LC23:
	.string	"no"
.LC24:
	.string	"%2d%10s%6s%8s%10s%6s\n"
.LC25:
	.string	"Total       "
.LC26:
	.string	"%12s%5.0f%%%8.0f%10.6f%6.0f\n"
.LC27:
	.string	"%12s%6s%8s%10s%6s\n"
	.text
	.type	printresults, @function
printresults:
.LFB82:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movl	%edi, %r12d
	movq	%rsi, %r13
	pushq	$.LC16
	.cfi_def_cfa_offset 88
	pushq	$.LC17
	.cfi_def_cfa_offset 96
	movl	$.LC11, %r9d
	movl	$.LC12, %r8d
	movl	$.LC13, %ecx
	movl	$.LC14, %edx
	movl	$.LC15, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
	pxor	%xmm7, %xmm7
	movsd	%xmm7, 24(%rsp)
	movsd	%xmm7, 16(%rsp)
	movsd	%xmm7, 8(%rsp)
	movl	$0, %ebp
	jmp	.L17
.L20:
	movslq	%ebp, %rbx
	salq	$5, %rbx
	addq	%r13, %rbx
	cmpl	$0, 8(%rbx)
	je	.L18
	movsd	(%rbx), %xmm1
	movapd	%xmm1, %xmm3
	divsd	.LC18(%rip), %xmm3
	movsd	16(%rbx), %xmm2
	movsd	.LC19(%rip), %xmm0
	mulsd	24(%rbx), %xmm0
	divsd	%xmm2, %xmm3
	movl	$.LC20, %ecx
	movl	%ebp, %edx
	movl	$.LC21, %esi
	movl	$1, %edi
	movl	$4, %eax
	call	__printf_chk
	movsd	8(%rsp), %xmm4
	addsd	16(%rbx), %xmm4
	movsd	%xmm4, 8(%rsp)
	movsd	16(%rsp), %xmm5
	addsd	(%rbx), %xmm5
	movsd	%xmm5, 16(%rsp)
	movsd	24(%rsp), %xmm6
	addsd	24(%rbx), %xmm6
	movsd	%xmm6, 24(%rsp)
	jmp	.L19
.L18:
	pushq	$.LC22
	.cfi_def_cfa_offset 88
	pushq	$.LC22
	.cfi_def_cfa_offset 96
	movl	$.LC22, %r9d
	movq	%r9, %r8
	movl	$.LC23, %ecx
	movl	%ebp, %edx
	movl	$.LC24, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
.L19:
	addl	$1, %ebp
.L17:
	cmpl	%r12d, %ebp
	jl	.L20
	cmpl	$0, errors(%rip)
	jne	.L21
	movsd	16(%rsp), %xmm1
	movapd	%xmm1, %xmm3
	divsd	.LC18(%rip), %xmm3
	pxor	%xmm0, %xmm0
	cvtsi2sd	%r12d, %xmm0
	movsd	24(%rsp), %xmm7
	divsd	%xmm0, %xmm7
	movapd	%xmm7, %xmm0
	mulsd	.LC19(%rip), %xmm0
	movsd	8(%rsp), %xmm7
	divsd	%xmm7, %xmm3
	movapd	%xmm7, %xmm2
	movl	$.LC25, %edx
	movl	$.LC26, %esi
	movl	$1, %edi
	movl	$4, %eax
	call	__printf_chk
	jmp	.L16
.L21:
	subq	$8, %rsp
	.cfi_def_cfa_offset 88
	pushq	$.LC22
	.cfi_def_cfa_offset 96
	movl	$.LC22, %r9d
	movq	%r9, %r8
	movq	%r9, %rcx
	movl	$.LC25, %edx
	movl	$.LC27, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	addq	$16, %rsp
	.cfi_def_cfa_offset 80
.L16:
	addq	$40, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE82:
	.size	printresults, .-printresults
	.section	.rodata.str1.8
	.align 8
.LC28:
	.string	"ERROR [trace %d, line %d]: %s\n"
	.text
	.type	malloc_error, @function
malloc_error:
.LFB85:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdx, %r8
	addl	$1, errors(%rip)
	leal	5(%rsi), %ecx
	movl	%edi, %edx
	movl	$.LC28, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE85:
	.size	malloc_error, .-malloc_error
	.type	app_error, @function
app_error:
.LFB83:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	puts
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE83:
	.size	app_error, .-app_error
	.section	.rodata.str1.8
	.align 8
.LC29:
	.string	"mm_init failed in eval_mm_speed"
	.align 8
.LC30:
	.string	"mm_malloc error in eval_mm_speed"
	.align 8
.LC31:
	.string	"mm_realloc error in eval_mm_speed"
	.align 8
.LC32:
	.string	"Nonexistent request type in eval_mm_valid"
	.text
	.type	eval_mm_speed, @function
eval_mm_speed:
.LFB79:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	(%rdi), %rbp
	call	mem_reset_brk
	call	mm_init
	testl	%eax, %eax
	jns	.L38
	movl	$.LC29, %edi
	call	app_error
.L37:
	movslq	%ebx, %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	addq	16(%rbp), %rax
	movl	(%rax), %edx
	cmpl	$1, %edx
	je	.L31
	cmpl	$1, %edx
	jb	.L32
	cmpl	$2, %edx
	je	.L33
	jmp	.L39
.L32:
	movl	4(%rax), %r12d
	movslq	8(%rax), %rdi
	call	mm_malloc
	testq	%rax, %rax
	jne	.L34
	movl	$.LC30, %edi
	call	app_error
.L34:
	movslq	%r12d, %r12
	salq	$3, %r12
	addq	24(%rbp), %r12
	movq	%rax, (%r12)
	jmp	.L35
.L33:
	movslq	4(%rax), %r12
	salq	$3, %r12
	movq	%r12, %rdx
	addq	24(%rbp), %rdx
	movq	(%rdx), %rdi
	movslq	8(%rax), %rsi
	call	mm_realloc
	testq	%rax, %rax
	jne	.L36
	movl	$.LC31, %edi
	call	app_error
.L36:
	addq	24(%rbp), %r12
	movq	%rax, (%r12)
	jmp	.L35
.L31:
	movslq	4(%rax), %rax
	salq	$3, %rax
	addq	24(%rbp), %rax
	movq	(%rax), %rdi
	call	mm_free
	jmp	.L35
.L39:
	movl	$.LC32, %edi
	call	app_error
.L35:
	addl	$1, %ebx
	jmp	.L29
.L38:
	movl	$0, %ebx
.L29:
	cmpl	8(%rbp), %ebx
	jl	.L37
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE79:
	.size	eval_mm_speed, .-eval_mm_speed
	.section	.rodata.str1.8
	.align 8
.LC33:
	.string	"mm_init failed in eval_mm_util"
	.align 8
.LC34:
	.string	"mm_malloc failed in eval_mm_util"
	.align 8
.LC35:
	.string	"mm_realloc failed in eval_mm_util"
	.align 8
.LC36:
	.string	"Nonexistent request type in eval_mm_util"
	.text
	.type	eval_mm_util, @function
eval_mm_util:
.LFB78:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, %rbx
	call	mem_reset_brk
	call	mm_init
	testl	%eax, %eax
	jns	.L53
	movl	$.LC33, %edi
	call	app_error
.L50:
	movslq	%ebp, %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	addq	16(%rbx), %rax
	movl	(%rax), %edx
	cmpl	$1, %edx
	je	.L44
	cmpl	$1, %edx
	jb	.L45
	cmpl	$2, %edx
	je	.L46
	jmp	.L54
.L45:
	movl	4(%rax), %ecx
	movl	%ecx, (%rsp)
	movl	8(%rax), %r14d
	movslq	%r14d, %r15
	movq	%r15, %rdi
	call	mm_malloc
	testq	%rax, %rax
	jne	.L47
	movl	$.LC34, %edi
	call	app_error
.L47:
	movslq	(%rsp), %rdx
	salq	$3, %rdx
	movq	%rdx, %rcx
	addq	24(%rbx), %rcx
	movq	%rax, (%rcx)
	addq	32(%rbx), %rdx
	movq	%r15, (%rdx)
	addl	%r14d, %r12d
	cmpl	%r12d, %r13d
	cmovl	%r12d, %r13d
	jmp	.L48
.L46:
	movl	8(%rax), %esi
	movl	%esi, (%rsp)
	movq	32(%rbx), %rdx
	movslq	4(%rax), %rax
	leaq	0(,%rax,8), %r14
	movq	(%rdx,%rax,8), %rax
	movq	%rax, 8(%rsp)
	movq	%r14, %rax
	addq	24(%rbx), %rax
	movq	(%rax), %rdi
	movslq	%esi, %r15
	movq	%r15, %rsi
	call	mm_realloc
	testq	%rax, %rax
	jne	.L49
	movl	$.LC35, %edi
	call	app_error
.L49:
	movq	%r14, %rdx
	addq	24(%rbx), %rdx
	movq	%rax, (%rdx)
	addq	32(%rbx), %r14
	movq	%r15, (%r14)
	movl	(%rsp), %eax
	subl	8(%rsp), %eax
	addl	%eax, %r12d
	cmpl	%r12d, %r13d
	cmovl	%r12d, %r13d
	jmp	.L48
.L44:
	movq	32(%rbx), %rdx
	movslq	4(%rax), %rax
	movq	(%rdx,%rax,8), %r14
	movq	24(%rbx), %rdx
	movq	(%rdx,%rax,8), %rdi
	call	mm_free
	subl	%r14d, %r12d
	jmp	.L48
.L54:
	movl	$.LC36, %edi
	call	app_error
.L48:
	addl	$1, %ebp
	jmp	.L42
.L53:
	movl	$0, %r12d
	movl	$0, %r13d
	movl	$0, %ebp
.L42:
	cmpl	8(%rbx), %ebp
	jl	.L50
	pxor	%xmm2, %xmm2
	cvtsi2sd	%r13d, %xmm2
	movsd	%xmm2, (%rsp)
	call	mem_heapsize
	testq	%rax, %rax
	js	.L51
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	jmp	.L52
.L51:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L52:
	movsd	(%rsp), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE78:
	.size	eval_mm_util, .-eval_mm_util
	.section	.rodata.str1.1
.LC37:
	.string	"%s: %s\n"
	.text
	.type	unix_error, @function
unix_error:
.LFB84:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	call	__errno_location
	movl	(%rax), %edi
	call	strerror
	movq	%rax, %rcx
	movq	%rbx, %rdx
	movl	$.LC37, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE84:
	.size	unix_error, .-unix_error
	.section	.rodata.str1.8
	.align 8
.LC38:
	.string	"malloc failed in eval_libc_speed"
	.align 8
.LC39:
	.string	"realloc failed in eval_libc_speed\n"
	.text
	.type	eval_libc_speed, @function
eval_libc_speed:
.LFB81:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	(%rdi), %rbp
	movl	$0, %ebx
	jmp	.L59
.L66:
	movslq	%ebx, %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	addq	16(%rbp), %rax
	movl	(%rax), %edx
	cmpl	$1, %edx
	je	.L61
	cmpl	$1, %edx
	jb	.L62
	cmpl	$2, %edx
	je	.L63
	jmp	.L60
.L62:
	movl	4(%rax), %r12d
	movslq	8(%rax), %rdi
	call	malloc
	testq	%rax, %rax
	jne	.L64
	movl	$.LC38, %edi
	call	unix_error
.L64:
	movslq	%r12d, %r12
	salq	$3, %r12
	addq	24(%rbp), %r12
	movq	%rax, (%r12)
	jmp	.L60
.L63:
	movslq	4(%rax), %r12
	salq	$3, %r12
	movq	%r12, %rdx
	addq	24(%rbp), %rdx
	movq	(%rdx), %rdi
	movslq	8(%rax), %rsi
	call	realloc
	testq	%rax, %rax
	jne	.L65
	movl	$.LC39, %edi
	call	unix_error
.L65:
	addq	24(%rbp), %r12
	movq	%rax, (%r12)
	jmp	.L60
.L61:
	movslq	4(%rax), %rax
	salq	$3, %rax
	addq	24(%rbp), %rax
	movq	(%rax), %rdi
	call	free
.L60:
	addl	$1, %ebx
.L59:
	cmpl	8(%rbp), %ebx
	jl	.L66
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE81:
	.size	eval_libc_speed, .-eval_libc_speed
	.section	.rodata.str1.1
.LC40:
	.string	"libc malloc failed"
.LC41:
	.string	"System message"
.LC42:
	.string	"libc realloc failed"
	.section	.rodata.str1.8
	.align 8
.LC43:
	.string	"invalid operation type  in eval_libc_valid"
	.text
	.type	eval_libc_valid, @function
eval_libc_valid:
.LFB80:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %r12
	movl	%esi, %r13d
	movl	$0, %ebx
	jmp	.L69
.L77:
	movslq	%ebx, %rax
	leaq	(%rax,%rax,2), %rax
	leaq	0(,%rax,4), %rbp
	movq	%rbp, %r14
	addq	16(%r12), %r14
	movl	(%r14), %eax
	cmpl	$1, %eax
	je	.L71
	cmpl	$1, %eax
	jb	.L72
	cmpl	$2, %eax
	je	.L73
	jmp	.L78
.L72:
	movslq	8(%r14), %rdi
	call	malloc
	testq	%rax, %rax
	jne	.L74
	movl	$.LC40, %edx
	movl	%ebx, %esi
	movl	%r13d, %edi
	call	malloc_error
	movl	$.LC41, %edi
	call	unix_error
.L74:
	movslq	4(%r14), %rdx
	salq	$3, %rdx
	addq	24(%r12), %rdx
	movq	%rax, (%rdx)
	jmp	.L75
.L73:
	movslq	4(%r14), %rax
	salq	$3, %rax
	addq	24(%r12), %rax
	movq	(%rax), %rdi
	movslq	8(%r14), %rsi
	call	realloc
	testq	%rax, %rax
	jne	.L76
	movl	$.LC42, %edx
	movl	%ebx, %esi
	movl	%r13d, %edi
	call	malloc_error
	movl	$.LC41, %edi
	call	unix_error
.L76:
	addq	16(%r12), %rbp
	movslq	4(%rbp), %rdx
	salq	$3, %rdx
	addq	24(%r12), %rdx
	movq	%rax, (%rdx)
	jmp	.L75
.L71:
	movslq	4(%r14), %rax
	salq	$3, %rax
	addq	24(%r12), %rax
	movq	(%rax), %rdi
	call	free
	jmp	.L75
.L78:
	movl	$.LC43, %edi
	call	app_error
.L75:
	addl	$1, %ebx
.L69:
	cmpl	8(%r12), %ebx
	jl	.L77
	movl	$1, %eax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE80:
	.size	eval_libc_valid, .-eval_libc_valid
	.section	.rodata.str1.1
.LC44:
	.string	"mdriver.c"
.LC45:
	.string	"size > 0"
	.section	.rodata.str1.8
	.align 8
.LC46:
	.string	"Payload address (%p) not aligned to %d bytes"
	.align 8
.LC47:
	.string	"Payload (%p:%p) lies outside heap (%p:%p)"
	.align 8
.LC48:
	.string	"Payload (%p:%p) overlaps another payload (%p:%p)\n"
	.section	.rodata.str1.1
.LC49:
	.string	"malloc error in add_range"
	.text
	.type	add_range, @function
add_range:
.LFB72:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$1048, %rsp
	.cfi_def_cfa_offset 1104
	movq	%fs:40, %rax
	movq	%rax, 1032(%rsp)
	xorl	%eax, %eax
	movslq	%edx, %rax
	leaq	-1(%rsi,%rax), %rbp
	testl	%edx, %edx
	jg	.L81
	movl	$__PRETTY_FUNCTION__.4613, %ecx
	movl	$388, %edx
	movl	$.LC44, %esi
	movl	$.LC45, %edi
	call	__assert_fail
.L81:
	movq	%rdi, %r14
	movq	%rsi, %rbx
	movl	%ecx, %r12d
	movl	%r8d, %r13d
	testb	$7, %sil
	je	.L82
	movl	$8, %r9d
	movq	%rsi, %r8
	movl	$.LC46, %ecx
	movl	$1024, %edx
	movl	$1, %esi
	movq	%rsp, %rdi
	movl	$0, %eax
	call	__sprintf_chk
	movq	%rsp, %rdx
	movl	%r13d, %esi
	movl	%r12d, %edi
	call	malloc_error
	movl	$0, %eax
	jmp	.L83
.L82:
	call	mem_heap_lo
	cmpq	%rax, %rbx
	jb	.L84
	call	mem_heap_hi
	cmpq	%rax, %rbx
	ja	.L84
	call	mem_heap_lo
	cmpq	%rax, %rbp
	jb	.L84
	call	mem_heap_hi
	cmpq	%rax, %rbp
	jbe	.L85
.L84:
	call	mem_heap_hi
	movq	%rax, %r14
	call	mem_heap_lo
	pushq	%r14
	.cfi_def_cfa_offset 1112
	pushq	%rax
	.cfi_def_cfa_offset 1120
	movq	%rbp, %r9
	movq	%rbx, %r8
	movl	$.LC47, %ecx
	movl	$1024, %edx
	movl	$1, %esi
	leaq	16(%rsp), %rdi
	movl	$0, %eax
	call	__sprintf_chk
	leaq	16(%rsp), %rdx
	movl	%r13d, %esi
	movl	%r12d, %edi
	call	malloc_error
	addq	$16, %rsp
	.cfi_def_cfa_offset 1104
	movl	$0, %eax
	jmp	.L83
.L85:
	movq	(%r14), %r15
	movq	%r15, %rax
	jmp	.L86
.L90:
	movq	(%rax), %rdx
	cmpq	%rdx, %rbx
	jb	.L87
	cmpq	8(%rax), %rbx
	jbe	.L88
.L87:
	cmpq	%rdx, %rbp
	jb	.L89
	cmpq	8(%rax), %rbp
	ja	.L89
.L88:
	pushq	8(%rax)
	.cfi_def_cfa_offset 1112
	pushq	%rdx
	.cfi_def_cfa_offset 1120
	movq	%rbp, %r9
	movq	%rbx, %r8
	movl	$.LC48, %ecx
	movl	$1024, %edx
	movl	$1, %esi
	leaq	16(%rsp), %rdi
	movl	$0, %eax
	call	__sprintf_chk
	leaq	16(%rsp), %rdx
	movl	%r13d, %esi
	movl	%r12d, %edi
	call	malloc_error
	addq	$16, %rsp
	.cfi_def_cfa_offset 1104
	movl	$0, %eax
	jmp	.L83
.L89:
	movq	16(%rax), %rax
.L86:
	testq	%rax, %rax
	jne	.L90
	movl	$24, %edi
	call	malloc
	testq	%rax, %rax
	jne	.L91
	movl	$.LC49, %edi
	call	unix_error
.L91:
	movq	%r15, 16(%rax)
	movq	%rbx, (%rax)
	movq	%rbp, 8(%rax)
	movq	%rax, (%r14)
	movl	$1, %eax
.L83:
	movq	1032(%rsp), %rcx
	xorq	%fs:40, %rcx
	je	.L92
	call	__stack_chk_fail
.L92:
	addq	$1048, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE72:
	.size	add_range, .-add_range
	.section	.rodata.str1.1
.LC50:
	.string	"mm_init failed."
.LC51:
	.string	"mm_malloc failed."
.LC52:
	.string	"mm_realloc failed."
	.section	.rodata.str1.8
	.align 8
.LC53:
	.string	"mm_realloc did not preserve the data from old block"
	.text
	.type	eval_mm_valid, @function
eval_mm_valid:
.LFB77:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	movq	%rdi, %r13
	movl	%esi, 12(%rsp)
	movq	%rdx, %r14
	call	mem_reset_brk
	movq	%r14, %rdi
	call	clear_ranges
	call	mm_init
	testl	%eax, %eax
	jns	.L109
	movl	$.LC50, %edx
	movl	$0, %esi
	movl	12(%rsp), %edi
	call	malloc_error
	movl	$0, %eax
	jmp	.L96
.L108:
	movslq	%r12d, %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	addq	16(%r13), %rax
	movl	4(%rax), %ebx
	movl	8(%rax), %ebp
	movl	(%rax), %eax
	cmpl	$1, %eax
	je	.L98
	cmpl	$1, %eax
	jb	.L99
	cmpl	$2, %eax
	je	.L100
	jmp	.L110
.L99:
	movslq	%ebp, %rax
	movq	%rax, 16(%rsp)
	movq	%rax, %rdi
	call	mm_malloc
	movq	%rax, %r15
	testq	%rax, %rax
	jne	.L101
	movl	$.LC51, %edx
	movl	%r12d, %esi
	movl	12(%rsp), %edi
	call	malloc_error
	movl	$0, %eax
	jmp	.L96
.L101:
	movl	%r12d, %r8d
	movl	12(%rsp), %ecx
	movl	%ebp, %edx
	movq	%rax, %rsi
	movq	%r14, %rdi
	call	add_range
	testl	%eax, %eax
	je	.L96
	movzbl	%bl, %esi
	movq	16(%rsp), %rbp
	movq	%rbp, %rdx
	movq	%r15, %rdi
	call	memset
	movslq	%ebx, %rbx
	salq	$3, %rbx
	movq	%rbx, %rax
	addq	24(%r13), %rax
	movq	%r15, (%rax)
	addq	32(%r13), %rbx
	movq	%rbp, (%rbx)
	jmp	.L102
.L100:
	movslq	%ebx, %rax
	movq	%rax, 24(%rsp)
	salq	$3, %rax
	movq	%rax, 32(%rsp)
	addq	24(%r13), %rax
	movq	(%rax), %rax
	movq	%rax, 16(%rsp)
	movslq	%ebp, %rsi
	movq	%rsi, 40(%rsp)
	movq	%rax, %rdi
	call	mm_realloc
	movq	%rax, %r15
	testq	%rax, %rax
	jne	.L103
	movl	$.LC52, %edx
	movl	%r12d, %esi
	movl	12(%rsp), %edi
	call	malloc_error
	movl	$0, %eax
	jmp	.L96
.L103:
	movq	16(%rsp), %rsi
	movq	%r14, %rdi
	call	remove_range
	movl	%r12d, %r8d
	movl	12(%rsp), %ecx
	movl	%ebp, %edx
	movq	%r15, %rsi
	movq	%r14, %rdi
	call	add_range
	testl	%eax, %eax
	je	.L96
	movq	32(%r13), %rax
	movq	24(%rsp), %rdi
	movq	(%rax,%rdi,8), %rax
	cmpl	%eax, %ebp
	jl	.L104
	movl	%eax, %ebp
.L104:
	movl	$0, %eax
	jmp	.L105
.L107:
	movslq	%eax, %rdx
	movsbl	(%r15,%rdx), %ecx
	movzbl	%bl, %edx
	cmpl	%edx, %ecx
	je	.L106
	movl	$.LC53, %edx
	movl	%r12d, %esi
	movl	12(%rsp), %edi
	call	malloc_error
	movl	$0, %eax
	jmp	.L96
.L106:
	addl	$1, %eax
.L105:
	cmpl	%ebp, %eax
	jl	.L107
	movzbl	%bl, %esi
	movq	40(%rsp), %rbx
	movq	%rbx, %rdx
	movq	%r15, %rdi
	call	memset
	movq	32(%rsp), %rdi
	movq	%rdi, %rax
	addq	24(%r13), %rax
	movq	%r15, (%rax)
	movq	%rdi, %rax
	addq	32(%r13), %rax
	movq	%rbx, (%rax)
	jmp	.L102
.L98:
	movslq	%ebx, %rbx
	salq	$3, %rbx
	addq	24(%r13), %rbx
	movq	(%rbx), %rbx
	movq	%rbx, %rsi
	movq	%r14, %rdi
	call	remove_range
	movq	%rbx, %rdi
	call	mm_free
	jmp	.L102
.L110:
	movl	$.LC32, %edi
	call	app_error
.L102:
	addl	$1, %r12d
	jmp	.L95
.L109:
	movl	$0, %r12d
.L95:
	cmpl	8(%r13), %r12d
	jl	.L108
	movl	$1, %eax
.L96:
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE77:
	.size	eval_mm_valid, .-eval_mm_valid
	.section	.rodata.str1.1
.LC54:
	.string	"Reading tracefile: %s\n"
	.section	.rodata.str1.8
	.align 8
.LC55:
	.string	"malloc 1 failed in read_trance"
	.section	.rodata.str1.1
.LC56:
	.string	"r"
	.section	.rodata.str1.8
	.align 8
.LC57:
	.string	"Could not open %s in read_trace"
	.section	.rodata.str1.1
.LC58:
	.string	"%d"
.LC59:
	.string	"malloc 2 failed in read_trace"
.LC60:
	.string	"malloc 3 failed in read_trace"
.LC61:
	.string	"malloc 4 failed in read_trace"
.LC62:
	.string	"%u %u"
.LC63:
	.string	"%ud"
	.section	.rodata.str1.8
	.align 8
.LC64:
	.string	"Bogus type character (%c) in tracefile %s\n"
	.section	.rodata.str1.1
.LC65:
	.string	"%s"
	.section	.rodata.str1.8
	.align 8
.LC66:
	.string	"max_index == trace->num_ids - 1"
	.section	.rodata.str1.1
.LC67:
	.string	"trace->num_ops == op_index"
	.text
	.type	read_trace, @function
read_trace:
.LFB75:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$2088, %rsp
	.cfi_def_cfa_offset 2128
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 2072(%rsp)
	xorl	%eax, %eax
	cmpl	$1, verbose(%rip)
	jle	.L113
	movq	%rsi, %rdx
	movl	$.LC54, %esi
	movl	$1, %edi
	call	__printf_chk
.L113:
	movl	$40, %edi
	call	malloc
	movq	%rax, %rbx
	testq	%rax, %rax
	jne	.L114
	movl	$.LC55, %edi
	call	unix_error
.L114:
	movl	$1024, %edx
	movq	%r12, %rsi
	leaq	1040(%rsp), %rdi
	call	__strcpy_chk
	movl	$1024, %edx
	movq	%rbp, %rsi
	leaq	1040(%rsp), %rdi
	call	__strcat_chk
	movl	$.LC56, %esi
	leaq	1040(%rsp), %rdi
	call	fopen
	movq	%rax, %rbp
	testq	%rax, %rax
	jne	.L115
	leaq	1040(%rsp), %r8
	movl	$.LC57, %ecx
	movl	$1024, %edx
	movl	$1, %esi
	movl	$msg, %edi
	movl	$0, %eax
	call	__sprintf_chk
	movl	$msg, %edi
	call	unix_error
.L115:
	movq	%rbx, %rdx
	movl	$.LC58, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	leaq	4(%rbx), %rdx
	movl	$.LC58, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	leaq	8(%rbx), %rdx
	movl	$.LC58, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	leaq	12(%rbx), %rdx
	movl	$.LC58, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	movslq	8(%rbx), %rax
	leaq	(%rax,%rax,2), %rax
	leaq	0(,%rax,4), %rdi
	call	malloc
	movq	%rax, 16(%rbx)
	testq	%rax, %rax
	jne	.L116
	movl	$.LC59, %edi
	call	unix_error
.L116:
	movslq	4(%rbx), %r12
	salq	$3, %r12
	movq	%r12, %rdi
	call	malloc
	movq	%rax, 24(%rbx)
	testq	%rax, %rax
	jne	.L117
	movl	$.LC60, %edi
	call	unix_error
.L117:
	movq	%r12, %rdi
	call	malloc
	movq	%rax, 32(%rbx)
	testq	%rax, %rax
	jne	.L118
	movl	$.LC61, %edi
	call	unix_error
.L118:
	movl	$0, 8(%rsp)
	movl	$0, %r12d
	movl	$0, %r13d
	jmp	.L119
.L125:
	movzbl	16(%rsp), %edx
	cmpb	$102, %dl
	je	.L121
	cmpb	$114, %dl
	je	.L122
	cmpb	$97, %dl
	jne	.L129
	leaq	12(%rsp), %rcx
	leaq	8(%rsp), %rdx
	movl	$.LC62, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	movl	%r12d, %eax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	movq	%rax, %rdx
	addq	16(%rbx), %rdx
	movl	$0, (%rdx)
	movq	%rax, %rcx
	addq	16(%rbx), %rcx
	movl	8(%rsp), %edx
	movl	%edx, 4(%rcx)
	addq	16(%rbx), %rax
	movl	12(%rsp), %ecx
	movl	%ecx, 8(%rax)
	cmpl	%edx, %r13d
	cmovb	%edx, %r13d
	jmp	.L124
.L122:
	leaq	12(%rsp), %rcx
	leaq	8(%rsp), %rdx
	movl	$.LC62, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	movl	%r12d, %eax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	movq	%rax, %rdx
	addq	16(%rbx), %rdx
	movl	$2, (%rdx)
	movq	%rax, %rcx
	addq	16(%rbx), %rcx
	movl	8(%rsp), %edx
	movl	%edx, 4(%rcx)
	addq	16(%rbx), %rax
	movl	12(%rsp), %ecx
	movl	%ecx, 8(%rax)
	cmpl	%edx, %r13d
	cmovb	%edx, %r13d
	jmp	.L124
.L121:
	leaq	8(%rsp), %rdx
	movl	$.LC63, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	movl	%r12d, %eax
	leaq	(%rax,%rax,2), %rdx
	leaq	0(,%rdx,4), %rax
	movq	%rax, %rdx
	addq	16(%rbx), %rdx
	movl	$1, (%rdx)
	addq	16(%rbx), %rax
	movl	8(%rsp), %edx
	movl	%edx, 4(%rax)
	jmp	.L124
.L129:
	movsbl	%dl, %edx
	leaq	1040(%rsp), %rcx
	movl	$.LC64, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	movl	$1, %edi
	call	exit
.L124:
	addl	$1, %r12d
.L119:
	leaq	16(%rsp), %rdx
	movl	$.LC65, %esi
	movq	%rbp, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf
	cmpl	$-1, %eax
	jne	.L125
	movq	%rbp, %rdi
	call	fclose
	movl	4(%rbx), %eax
	subl	$1, %eax
	cmpl	%eax, %r13d
	je	.L126
	movl	$__PRETTY_FUNCTION__.4655, %ecx
	movl	$551, %edx
	movl	$.LC44, %esi
	movl	$.LC66, %edi
	call	__assert_fail
.L126:
	cmpl	8(%rbx), %r12d
	je	.L127
	movl	$__PRETTY_FUNCTION__.4655, %ecx
	movl	$552, %edx
	movl	$.LC44, %esi
	movl	$.LC67, %edi
	call	__assert_fail
.L127:
	movq	%rbx, %rax
	movq	2072(%rsp), %rsi
	xorq	%fs:40, %rsi
	je	.L128
	call	__stack_chk_fail
.L128:
	addq	$2088, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE75:
	.size	read_trace, .-read_trace
	.section	.rodata.str1.1
.LC69:
	.string	"ERROR: realloc failed in main"
.LC70:
	.string	"/"
.LC71:
	.string	"f:t:hvVgal"
	.section	.rodata.str1.8
	.align 8
.LC72:
	.string	"ERROR: Please provide the information about your team in mm.c."
	.section	.rodata.str1.1
.LC73:
	.string	"Team Name:%s\n"
	.section	.rodata.str1.8
	.align 8
.LC74:
	.string	"ERROR.  You must fill in all team member 1 fields!"
	.section	.rodata.str1.1
.LC75:
	.string	"Member 1 :%s:%s\n"
	.section	.rodata.str1.8
	.align 8
.LC76:
	.string	"ERROR.  You must fill in all or none of the team member 2 ID fields!"
	.section	.rodata.str1.1
.LC77:
	.string	"Member 2 :%s:%s\n"
	.section	.rodata.str1.8
	.align 8
.LC78:
	.string	"Using default tracefiles in %s\n"
	.section	.rodata.str1.1
.LC79:
	.string	"\nTesting libc malloc"
	.section	.rodata.str1.8
	.align 8
.LC80:
	.string	"libc_stats calloc in main failed"
	.align 8
.LC81:
	.string	"Checking libc malloc for correctness, "
	.section	.rodata.str1.1
.LC82:
	.string	"and performance."
.LC83:
	.string	"\nResults for libc malloc:"
.LC84:
	.string	"\nTesting mm malloc"
	.section	.rodata.str1.8
	.align 8
.LC85:
	.string	"mm_stats calloc in main failed"
	.align 8
.LC86:
	.string	"Checking mm_malloc for correctness, "
	.section	.rodata.str1.1
.LC87:
	.string	"efficiency, "
.LC88:
	.string	"\nResults for mm malloc:"
	.section	.rodata.str1.8
	.align 8
.LC91:
	.string	"Perf index = %.0f (util) + %.0f (thru) = %.0f/100\n"
	.section	.rodata.str1.1
.LC92:
	.string	"Terminated with %d errors\n"
.LC93:
	.string	"correct:%d\n"
.LC94:
	.string	"perfidx:%.0f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB71:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movl	%edi, %ebp
	movq	%rsi, %rbx
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	movq	$0, 24(%rsp)
	movl	$0, 4(%rsp)
	movl	$0, %r15d
	movl	$1, %r14d
	movl	$0, %r13d
	movl	$0, %r12d
	jmp	.L132
.L144:
	subl	$86, %eax
	cmpb	$32, %al
	ja	.L133
	movzbl	%al, %eax
	jmp	*.L135(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L135:
	.quad	.L134
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L177
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L137
	.quad	.L138
	.quad	.L139
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L140
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L133
	.quad	.L141
	.quad	.L133
	.quad	.L142
	.text
.L137:
	movl	$16, %esi
	movq	%r12, %rdi
	call	realloc
	movq	%rax, %r12
	testq	%rax, %rax
	jne	.L143
	movl	$.LC69, %edi
	call	unix_error
.L143:
	movw	$12078, tracedir(%rip)
	movb	$0, tracedir+2(%rip)
	movq	optarg(%rip), %rdi
	call	__strdup
	movq	%rax, (%r12)
	movq	$0, 8(%r12)
	movl	$1, %r13d
	jmp	.L132
.L141:
	cmpl	$1, %r13d
	je	.L132
	movl	$1024, %edx
	movq	optarg(%rip), %rsi
	movl	$tracedir, %edi
	call	__strcpy_chk
	movl	$tracedir, %edi
	movl	$0, %eax
	movq	$-1, %rcx
	repnz scasb
	notq	%rcx
	cmpb	$47, tracedir-2(%rcx)
	je	.L132
	movl	$1024, %edx
	movl	$.LC70, %esi
	movl	$tracedir, %edi
	call	__strcat_chk
	jmp	.L132
.L140:
	movl	$1, %r15d
	jmp	.L132
.L142:
	movl	$1, verbose(%rip)
	jmp	.L132
.L134:
	movl	$2, verbose(%rip)
	jmp	.L132
.L139:
	call	usage
	movl	$0, %edi
	call	exit
.L133:
	call	usage
	movl	$1, %edi
	call	exit
.L138:
	movl	$1, 4(%rsp)
	jmp	.L132
.L177:
	movl	$0, %r14d
.L132:
	movl	$.LC71, %edx
	movq	%rbx, %rsi
	movl	%ebp, %edi
	call	getopt
	cmpb	$-1, %al
	jne	.L144
	testl	%r14d, %r14d
	je	.L145
	movq	team(%rip), %rdx
	cmpb	$0, (%rdx)
	jne	.L146
	movl	$.LC72, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L146:
	movl	$.LC73, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	movq	team+8(%rip), %rdx
	cmpb	$0, (%rdx)
	je	.L147
	movq	team+16(%rip), %rcx
	cmpb	$0, (%rcx)
	jne	.L148
.L147:
	movl	$.LC74, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L148:
	movl	$.LC75, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	movq	team+24(%rip), %rdx
	movzbl	(%rdx), %eax
	testb	%al, %al
	je	.L149
	movq	team+32(%rip), %rcx
	cmpb	$0, (%rcx)
	je	.L150
.L149:
	testb	%al, %al
	jne	.L151
	movq	team+32(%rip), %rcx
	cmpb	$0, (%rcx)
	je	.L151
.L150:
	movl	$.LC76, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L151:
	testb	%al, %al
	je	.L145
	movq	team+32(%rip), %rcx
	movl	$.LC77, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
.L145:
	testq	%r12, %r12
	jne	.L152
	movl	$tracedir, %edx
	movl	$.LC78, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	movl	$11, %r13d
	movl	$default_tracefiles, %r12d
.L152:
	call	init_fsecs
	testl	%r15d, %r15d
	je	.L153
	cmpl	$1, verbose(%rip)
	jle	.L154
	movl	$.LC79, %edi
	call	puts
.L154:
	movslq	%r13d, %rdi
	movl	$32, %esi
	call	calloc
	movq	%rax, %r15
	testq	%rax, %rax
	jne	.L178
	movl	$.LC80, %edi
	call	unix_error
.L159:
	movslq	%ebp, %rbx
	movq	(%r12,%rbx,8), %rsi
	movl	$tracedir, %edi
	call	read_trace
	movq	%rax, %r14
	salq	$5, %rbx
	addq	%r15, %rbx
	pxor	%xmm0, %xmm0
	cvtsi2sd	8(%rax), %xmm0
	movsd	%xmm0, (%rbx)
	cmpl	$1, verbose(%rip)
	jle	.L156
	movl	$.LC81, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
.L156:
	movl	%ebp, %esi
	movq	%r14, %rdi
	call	eval_libc_valid
	movl	%eax, 8(%rbx)
	testl	%eax, %eax
	je	.L157
	movq	%r14, 32(%rsp)
	cmpl	$1, verbose(%rip)
	jle	.L158
	movl	$.LC82, %edi
	call	puts
.L158:
	leaq	32(%rsp), %rsi
	movl	$eval_libc_speed, %edi
	call	fsecs
	movsd	%xmm0, 16(%rbx)
.L157:
	movq	%r14, %rdi
	call	free_trace
	addl	$1, %ebp
	jmp	.L155
.L178:
	movl	$0, %ebp
.L155:
	cmpl	%r13d, %ebp
	jl	.L159
	cmpl	$0, verbose(%rip)
	je	.L153
	movl	$.LC83, %edi
	call	puts
	movq	%r15, %rsi
	movl	%r13d, %edi
	call	printresults
.L153:
	cmpl	$1, verbose(%rip)
	jle	.L160
	movl	$.LC84, %edi
	call	puts
.L160:
	movslq	%r13d, %rdi
	movl	$32, %esi
	call	calloc
	movq	%rax, %r15
	testq	%rax, %rax
	jne	.L161
	movl	$.LC85, %edi
	call	unix_error
.L161:
	call	mem_init
	movl	$0, %ebp
	jmp	.L162
.L167:
	movslq	%ebp, %rbx
	movq	(%r12,%rbx,8), %rsi
	movl	$tracedir, %edi
	call	read_trace
	movq	%rax, %r14
	salq	$5, %rbx
	addq	%r15, %rbx
	pxor	%xmm0, %xmm0
	cvtsi2sd	8(%rax), %xmm0
	movsd	%xmm0, (%rbx)
	cmpl	$1, verbose(%rip)
	jle	.L163
	movl	$.LC86, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
.L163:
	leaq	24(%rsp), %rdx
	movl	%ebp, %esi
	movq	%r14, %rdi
	call	eval_mm_valid
	movl	%eax, 8(%rbx)
	testl	%eax, %eax
	je	.L164
	cmpl	$1, verbose(%rip)
	jle	.L165
	movl	$.LC87, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
.L165:
	leaq	24(%rsp), %rdx
	movl	%ebp, %esi
	movq	%r14, %rdi
	call	eval_mm_util
	movsd	%xmm0, 24(%rbx)
	movq	%r14, 32(%rsp)
	movq	24(%rsp), %rax
	movq	%rax, 40(%rsp)
	cmpl	$1, verbose(%rip)
	jle	.L166
	movl	$.LC82, %edi
	call	puts
.L166:
	leaq	32(%rsp), %rsi
	movl	$eval_mm_speed, %edi
	call	fsecs
	movsd	%xmm0, 16(%rbx)
.L164:
	movq	%r14, %rdi
	call	free_trace
	addl	$1, %ebp
.L162:
	cmpl	%r13d, %ebp
	jl	.L167
	cmpl	$0, verbose(%rip)
	je	.L168
	movl	$.LC88, %edi
	call	puts
	movq	%r15, %rsi
	movl	%r13d, %edi
	call	printresults
	movl	$10, %edi
	call	putchar
.L168:
	movl	$0, %ebx
	pxor	%xmm1, %xmm1
	movapd	%xmm1, %xmm2
	movapd	%xmm1, %xmm3
	movl	$0, %edx
	jmp	.L169
.L171:
	movslq	%edx, %rax
	salq	$5, %rax
	addq	%r15, %rax
	addsd	16(%rax), %xmm3
	addsd	(%rax), %xmm2
	addsd	24(%rax), %xmm1
	cmpl	$0, 8(%rax)
	je	.L170
	addl	$1, %ebx
.L170:
	addl	$1, %edx
.L169:
	cmpl	%r13d, %edx
	jl	.L171
	pxor	%xmm0, %xmm0
	cvtsi2sd	%r13d, %xmm0
	divsd	%xmm0, %xmm1
	movl	errors(%rip), %edx
	testl	%edx, %edx
	jne	.L172
	divsd	%xmm3, %xmm2
	mulsd	.LC89(%rip), %xmm1
	movapd	%xmm1, %xmm0
	ucomisd	.LC90(%rip), %xmm2
	ja	.L179
	divsd	.LC90(%rip), %xmm2
	movapd	%xmm2, %xmm1
	mulsd	.LC68(%rip), %xmm1
	jmp	.L173
.L179:
	movsd	.LC68(%rip), %xmm1
.L173:
	movapd	%xmm1, %xmm2
	addsd	%xmm0, %xmm2
	movsd	.LC19(%rip), %xmm3
	mulsd	%xmm3, %xmm2
	movsd	%xmm2, 8(%rsp)
	mulsd	%xmm3, %xmm0
	mulsd	%xmm3, %xmm1
	movl	$.LC91, %esi
	movl	$1, %edi
	movl	$3, %eax
	call	__printf_chk
	jmp	.L174
.L172:
	movl	$.LC92, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	pxor	%xmm4, %xmm4
	movsd	%xmm4, 8(%rsp)
.L174:
	cmpl	$0, 4(%rsp)
	je	.L175
	movl	%ebx, %edx
	movl	$.LC93, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk
	movsd	8(%rsp), %xmm0
	movl	$.LC94, %esi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk
.L175:
	movl	$0, %edi
	call	exit
	.cfi_endproc
.LFE71:
	.size	main, .-main
	.section	.rodata
	.align 8
	.type	__PRETTY_FUNCTION__.4613, @object
	.size	__PRETTY_FUNCTION__.4613, 10
__PRETTY_FUNCTION__.4613:
	.string	"add_range"
	.align 8
	.type	__PRETTY_FUNCTION__.4655, @object
	.size	__PRETTY_FUNCTION__.4655, 11
__PRETTY_FUNCTION__.4655:
	.string	"read_trace"
	.section	.rodata.str1.1
.LC95:
	.string	"amptjp-bal.rep"
.LC96:
	.string	"cccp-bal.rep"
.LC97:
	.string	"cp-decl-bal.rep"
.LC98:
	.string	"expr-bal.rep"
.LC99:
	.string	"coalescing-bal.rep"
.LC100:
	.string	"random-bal.rep"
.LC101:
	.string	"random2-bal.rep"
.LC102:
	.string	"binary-bal.rep"
.LC103:
	.string	"binary2-bal.rep"
.LC104:
	.string	"realloc-bal.rep"
.LC105:
	.string	"realloc2-bal.rep"
	.data
	.align 32
	.type	default_tracefiles, @object
	.size	default_tracefiles, 96
default_tracefiles:
	.quad	.LC95
	.quad	.LC96
	.quad	.LC97
	.quad	.LC98
	.quad	.LC99
	.quad	.LC100
	.quad	.LC101
	.quad	.LC102
	.quad	.LC103
	.quad	.LC104
	.quad	.LC105
	.quad	0
	.align 32
	.type	tracedir, @object
	.size	tracedir, 1024
tracedir:
	.string	"/afs/cs/project/ics2/im/labs/malloclab/traces/"
	.zero	977
	.comm	msg,1024,32
	.local	errors
	.comm	errors,4,4
	.globl	verbose
	.bss
	.align 4
	.type	verbose, @object
	.size	verbose, 4
verbose:
	.zero	4
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC18:
	.long	0
	.long	1083129856
	.align 8
.LC19:
	.long	0
	.long	1079574528
	.align 8
.LC68:
	.long	2576980378
	.long	1071225241
	.align 8
.LC89:
	.long	858993459
	.long	1071854387
	.align 8
.LC90:
	.long	0
	.long	1092767616
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
