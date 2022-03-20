	.code


	;; TODO: test the 'min' and 'max' instructions
	;; ...
    ;;max
    set r1,0x0005 ;;opb
    set r0,0x0004 ;;opa
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x0005
    
    set r1,0xf005 ;;opb
    set r0,0xf004 ;;opa
    nop
    nop
    max r2,r1,r0
    nop
    out 0x11,r2;;0x0005
    
    ;;min;;;;;;;;;;;;;;;;;;
    
	;; terminate simulation
	out	0x12,r0
	nop
