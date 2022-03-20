	.code

    ;;;;;;;;clr;;;;;
	set r0,0x2345
    set r1,0x6789
    nop
    move	acr0.h,r0
	move	acr0.l,r1
	set	guards01,0xff
	nop
	nop
	;; acr0=0xff23456789
	clr acr0
	nop
	move	r0,acr0	 	 ; r0 = 0x0000
	move	r1, mul65536 acr0	 ; r1 = 0x0000
	out 0x11,r0
	out 0x11,r1
    
    ;;addl;;;;;;
    set r0,0x2345
    set r1,0x6789
    set r2,0x0011
    clr acr2
    nop
    move	acr0.h,r0
	move	acr0.l,r2
	set	guards01,0x0000
	move	acr1.h,r1
	move	acr1.l,r2
	nop
	nop
	;; acr0=0xff23456789
	addl acr2, acr1, acr0
	move	r0,acr2
	move	r1,mul65536 acr2
	out 0x11,r0
	out 0x11,r1
    
    ;;subl;;;;;;;;;
    set r0,0x2345
    set r1,0x6789
    set r2,0x0011
    set r3,0x0010
    clr acr2
    nop
    move	acr0.h,r0
	move	acr0.l,r3
	set	guards01,0x0000
	move	acr1.h,r1
	move	acr1.l,r2
	nop
	nop
	;; acr0=0xff23456789
	subl acr2, acr1, acr0
	move	r0,acr2
	move	r1,mul65536 acr2
	out 0x11,r0
	out 0x11,r1
    ;;cmpl;;;;;;;;;;;
    set r0,0x2345
    set r1,0x6789
    set r2,0x0011
    clr acr0
    clr acr1
    nop
    move	acr0.h,r0
	move	acr0.l,r2     ;; acr0=0x0023450011
	set	guards01,0x0000    ;; acr1=0x0067890011
	move	acr1.h,r1
	move	acr1.l,r2
	nop
	nop
	cmpl   acr1, acr0
	nop
	move	r0,fl0    ;;0000
	nop
	out 0x11,r0
	;;negl;;;;;;;;;;;;;;
	set r0,0x2345
    set r1,0x6789
    clr acr0
    clr acr1
    nop
    move	acr0.h,r0
	move	acr0.l,r1
	set	guards01,0x0000    ;;acr0=0x0023456789
	nop
	nop
	negl   acr1, acr0
	move	r0,acr1
	move	r1,mul65536 acr1
	out 0x11,r0
	out 0x11,r1
    ;;absl;;;;;;;;;;;;;;
    set r0,0x2345
    set r1,0x6789
    clr acr0
    clr acr1
    nop
    move	acr0.h,r0
	move	acr0.l,r1
	set	guards01,0x0000    ;;acr0=0x0023456789
	nop
	nop
	absl   acr1, acr0
	move	r0,acr1
	move rnd r1,acr1
	move	r1,mul65536 acr1
	out 0x11,r0
	out 0x11,r1
    
    ;;mulss;;;;;;;;;;;;;;;;
    set r0,0x0101
    set r1,0x8000
    clr acr0
    nop                     
    mulss acr0,r0,r1 ;;acr0=0xff,ff80,8000
    nop
    move rnd r1,acr0
    nop
    out 0x11,r1         ;;r1=0xff81
    
    ;;macss;;;;;;;;;;;;;;;
    set r0,0x0080
    set r1,0x0000
    clr acr0
    nop
    set guards01,0x0000
    move acr0.h,r0
    move acr0.l,r1
    set r0,0x8000
    set r1,0x4
    nop
    macss acr0,r0,r1
    nop
    move r1,acr0
    nop             ;;;r1=0x0082
    out 0x11,r1
    
    ;;mdmss;;;;;;;;;;;;;;;;;;
    set r0,0x0080
    set r1,0x0000
    clr acr0
    nop
    set guards01,0x0000
    move acr0.h,r0
    move acr0.l,r1
    set r0,0x8000
    set r1,0x4
    nop
    mdmss acr0,r0,r1
    nop
    move r1,acr0
    nop         ;;;r1=0x007e
    out 0x11,r1
    
    
    
    
	;; terminate simulation
	out	0x12,r0
	nop
