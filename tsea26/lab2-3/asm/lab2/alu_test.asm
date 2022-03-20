	.code


	;; TODO: test the 'add' instruction
	;; ...
    set r0,1
    set r1,0x7fff
    nop
    nop
    add r0,r1
    nop
    out 0x11,r0 ;;0x8000
    
    set r0,1
    set r1,0xffff
    nop
    nop
    add r0,r1
    nop
    out 0x11,r0 ;;0x0000
    
    set r0,0xfffe
    set r1,0x8000
    nop
    nop
    add r0,r1
    nop
    out 0x11,r0 ;;0x7ffe

	;; TODO: test the 'addc' instruction
	;; ...
    set r0,1
    set r1,0x7fff
    nop
    nop
    addc r0,r1
    nop
    out 0x11,r0 ;;0x8001

    set r0,1
    set r1,0xffff
    nop
    nop
    addc r0,r1
    nop
    out 0x11,r0 ;;0x0000
    
    set r0,0xfffe
    set r1,0x8000
    nop
    nop
    addc r0,r1
    nop
    out 0x11,r0 ;;0x7fff
    
	;; TODO: test the 'sub' instruction
	;; ...
    set r0,0x0000
    set r1,0x0001
    nop
    nop
    sub r0,r1
    nop
    out 0x11,r0 ;;0xffff

    set r0,0x8000
    set r1,0x0001
    nop
    nop
    sub r0,r1
    nop
    out 0x11,r0 ;;0x7fff
    
    set r0,0xffff
    set r1,0x0001
    nop
    nop
    sub r0,r1
    nop
    out 0x11,r0 ;;0xfffe

    set r0,0x0004
    set r1,0x0001
    nop
    nop
    sub r0,r1
    nop
    out 0x11,r0 ;;0x003
    
	;; TODO: test the 'subc' instruction
	;; ...
    set r0,0x0000
    set r1,0x0001
    nop
    nop
    subc r0,r1
    nop
    out 0x11,r0 ;;0xfffe

    set r0,0x8000
    set r1,0x0001
    nop
    nop
    subc r0,r1
    nop
    out 0x11,r0 ;;0x7fff
    
    set r0,0xffff
    set r1,0x0001
    nop
    nop
    subc r0,r1
    nop
    out 0x11,r0 ;;0xfffe
    
    set r0,0x0004
    set r1,0x0001
    nop
    nop
    subc r0,r1
    nop
    out 0x11,r0 ;;0x0003
	;; TODO: test the 'abs' instruction
	;; ...
    set r0,0x8003
    nop
    nop
    abs r0,r0
    nop
    out 0x11,r0
    
    set r0,0xffff
    nop
    nop
    abs r0,r0
    nop
    out 0x11,r0

	;; TODO: test the 'cmp' instruction
	set	r0,4
	set	r1,2485
	nop
	nop
	cmp	r0,r1
	nop
	nop
	move	r0,fl0		; read flags register
	nop
	nop
	out	0x11,r0
	;; ...


	;; TODO: test the 'min' and 'max' instructions
	;; ...
    ;;max
    set r0,0x0005
    set r1,0x0004
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x0005
    
    set r0,0x8007
    set r1,0x000a
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x8007
    
    set r0,0x8007
    set r1,0x8001
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x8007
    
    set r0,0x000b
    set r1,0x8001
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x000b
    
    set r0,0xf001
    set r1,0xf002
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x8002
    
    set r0,0x8000
    set r1,0x8001
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x8000
    
    set r0,0x0001
    set r1,0x0002
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x2

    set r0,0x0010
    set r1,0x0011
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x0011
    
    set r0,0xf001
    set r1,0x0010
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x0010
    
    set r0,0xf000
    set r1,0xf001
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x8011
    
    set r0,0x0001
    set r1,0x0010
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x0010
    
    ;;min;;;;;;;;;;;;;;;;;;
    set r0,0xffff
    set r1,0x0001
    nop
    nop
    min r2,r1,r0
    nop
    out 0x11,r2;;0x0001
    
    set r0,0xfffe
    set r1,0xffff
    nop
    nop
    min r2,r1,r0
    nop
    out 0x11,r2;;0xfffe
    
    set r0,0xff01
    set r1,0xff10
    nop
    nop
    min r2,r1,r0
    nop
    out 0x11,r2;;0xff01
    
    set r0,0x0000
    set r1,0xffff
    nop
    nop
    min r2,r1,r0
    nop
    out 0x11,r2;;0xffff
    
    set r0,0x0001
    set r1,0x0010
    nop
    nop
    min r2,r1,r0
    nop
    out 0x11,r2;;0x0001
    
    set r0,0x0010
    set r1,0x0001
    nop
    nop
    min r2,r1,r0
    nop
    out 0x11,r2;;0x0001
    
	;; terminate simulation
	out	0x12,r0
	nop
