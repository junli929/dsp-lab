	.code

	;; TODO: put code to test MAC rounding here
	;; addl;;;;;;;;;;;;;;;;
    set r0,0x0001
    set r1,0x7fff
    set r2,0x0000
    nop
    move acr0.h,r0
    move acr0.l,r2
    move acr1.h,r1
    move acr1.l,r2
    set guards01,0x0000     ;;acr0=0x00,0001,0000
    nop             ;;acr1=0x00,7fff,0000
    addl acr0, acr0,acr1 
    nop
    move r1,acr0
    nop
    out 0x11,r1
    
    ;;subl;;;;;;;;;;;;;;;;;;;;;;;
    set r0,0x0001
    set r1,0x5555
    set r2,0x0000
    nop
    move acr0.h,r0
    move acr0.l,r2
    move acr1.h,r1
    move acr1.l,r2
    set guards01,0x0101     ;;acr0=0x01,0001,0000
    nop             ;;acr1=0x01,5555,0000
    subl acr2, acr0,acr1 
    nop
    move r1,acr2
    nop
    out 0x11,r1
    
    ;;cmpl;;;;;;;;;;;;;;;;;;;;;;;;
    set r0,0x0001
    set r1,0x4444
    set r2,0x0000
    nop
    move acr0.h,r0
    move acr0.l,r2
    move acr1.h,r1
    move acr1.l,r2
    set guards01,0x0000     ;;acr0=0x00,0001,0000
    nop                     ;;acr1=0x00,4444,0000
    cmpl acr0,acr1 
    nop
    move r1,fl0
    nop
    out 0x11,r1
    ;;negl;;;;;;;;;;;;;;;;;;;;;;;;
    set r1,0x0010
    set r2,0x0000
    nop
    move acr1.h,r1
    move acr1.l,r2
    set guards01,0x0000     
    nop                     ;;acr1=0x00,0010,0000
    negl sat acr0,acr1 
    nop
    move r1,acr0
    nop
    out 0x11,r1
    ;;absl;;;;;;;;;;;;;;;;;;;;;;;;
    set r1,0x8000
    set r2,0x0000
    nop
    move acr1.h,r1
    move acr1.l,r2
    set guards01,0x0000     
    nop                     ;;acr1=0x00,8000,0000
    absl acr0,acr1 
    nop
    move r1,acr0
    nop
    out 0x11,r1
    
    set r1,0x0000
    set r2,0x0000
    nop
    move acr0.h,r1
    move acr0.l,r2
    set guards01,0xffff     
    nop                     ;;acr0=0xff,0000,0000
    absl acr1,acr0 
    nop
    move sat r1,acr1
    nop
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
