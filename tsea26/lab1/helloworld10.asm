	set   sp,stackarea	; Set the stackpointer
	
	set   r0,0		; Loop counter
	
    repeat loopend, 43			
	
	out   0x11,r0		; Output data
    add   r0,1

loopend



	out   0x13,r0		; Exit the simulator.

	
	.ram1
stackarea
	.skip 100
