	set   sp,stackarea	; Set the stackpointer
	
	set   r0,0		; Loop counter
	set   r1,43		; Loop end

loop
	out   0x11,r0		; Output data
	add   r0,1
	cmp   r1,r0		; And check if we have reached the end of the loop
	jump.ne loop

	out   0x13,r0		; Exit the simulator.

	
	.ram1
stackarea
	.skip 100
