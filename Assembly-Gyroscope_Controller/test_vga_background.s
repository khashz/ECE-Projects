
.data
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000

.equ SOFT_DISP, 2
.equ MED_DISP, 3
.equ HARD_DISP, 5

.equ BACKGROUND_COLOR, 0x200f
.equ CURSOR_COLOR, 0xffff   /* white */

.text
.global main


##### COPY BELOW THIS AT RUNTIME AND ONLY RUN ONCE #####
main:

  movia r2,ADDR_VGA
  movui r4,BACKGROUND_COLOR 
  
   mov r8, r0

   movui r22, 320
   movui r23, 240

   FILL_X:
 
	mov r9, r0
	
	FILL_Y:
	
	muli r20, r8, 2  # store 2*X into r20
	muli r21, r9, 1024 #store y*1024 into r21
	add r20, r21, r20 # store 2*X+1024*Y into r20
	add r20, r2, r20 # store pixel_base + 2*X+1024*Y into r20
  
	sthio r4, 0(r20) # print pixel to (x,y)
	
	addi r9,r9, 1
	
	blt r9, r23, FILL_Y
  
	addi r8, r8, 1
    blt r8,r22, FILL_X

	#after loop set initial (x,y) 
	movia r8, 160
	movia r9, 120

	
	
  