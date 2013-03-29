# GYROSCOPE VGA FUNCTIONS 
# Hari Halilovic 2013 ECE243

#vga controller, print pixels on the screen first (create "background")
#then use conditions to print a single pixel around the screen
#and replace it's previous place with the background colour

# Pixel Buffer: 0x08000000
# pixel base+{y[7:0],x[8:0],1'b0} corresponds to pixel (x,y)
# colors are represented by a 16-bit halfword  
# Red 15...11 Green 10...5 Blue 4...0 

# For example, a red color would be represented by a value 0xF800, 
#a purple color by a value 0xF81F, white by 0xFFFF, and gray by 0x8410. 

# save r16-r23 
# r8, r9 hold (x,y) respectively.

#function takes in r4 (predetermined values for left/right orientation) and r5(same for up/down)
#code:
# value    r4            r5   
#   0   no change       "  "
#   1   soft left      soft up
#   2   soft right    soft down
#   3   medium left   medium up
#   4   medium right  medium down
#   5   hard left     hard up
#   6   hard right    hard down
#########################################################################


.data
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000


.equ SOFT_DISP, 2
.equ MED_DISP, 3
.equ HARD_DISP, 5

.equ BACKGROUND_COLOR, 0x200f /*dark blue*/
.equ CURSOR_COLOR, 0xffff   /* white */
.equ WALL_COLOR, 0x0ff0
.equ GOAL_COLOR, 0xfff0

.global VGA_MAIN
.text
.align 2
VGA_MAIN:  
  
    #PROLOGUE
	addi sp, sp, -36
  
	stw r16,0(sp)
	stw r17,4(sp)
	stw r18,8(sp)
	stw r19,12(sp)
	stw r20,16(sp)
	stw r21,20(sp)
	stw r22,24(sp)
	stw r23,28(sp)
	stw ra, 32(sp)
	
	#save previous values of x/y to fill in dot after call
	mov r17, r8 
	mov r18, r9 
	
	beq r4,r0, NO_CHANGE_HORIZ
	movia r16, 1
	beq r4, r16, SOFT_LEFT
	movia r16, 2
	beq r4,r16, SOFT_RIGHT
	movia r16, 3
	beq r4,r16, MED_LEFT
	movia r16, 4
	beq r4,r16, MED_RIGHT
	movia r16, 5
	beq r4,r16, HARD_LEFT
	movia r16, 6
	beq r4,r16, HARD_RIGHT
	
	br EPILOGUE

  
NO_CHANGE_HORIZ:
  
	br CHECK_VERT
  
SOFT_LEFT:
  
	movia r16, SOFT_DISP
	sub r8, r8, r16
	
	call check_x
    br CHECK_VERT
	
SOFT_RIGHT:
  
	movia r16, SOFT_DISP
	add r8, r8, r16
	
	call check_x
	br CHECK_VERT
  
MED_LEFT:
  
	movia r16, MED_DISP
	sub r8, r8, r16
	
	call check_x
	br CHECK_VERT
	
MED_RIGHT:
  
	movia r16, MED_DISP
	add r8, r8, r16
	
	call check_x
	br CHECK_VERT
  
HARD_LEFT:
  
	movia r16, HARD_DISP
	sub r8, r8, r16
	
	call check_x
	br CHECK_VERT
  
HARD_RIGHT:
	movia r16, HARD_DISP
	add r8, r8, r16
	
	call check_x
	br CHECK_VERT
	
CHECK_VERT:
  
    beq r5,r0, NO_CHANGE_VERT
	movia r16, 1
	beq r5, r16, SOFT_UP
	movia r16, 2
	beq r5,r16, SOFT_DOWN
	movia r16, 3
	beq r5,r16, MED_UP
	movia r16, 4
	beq r5,r16, MED_DOWN
	movia r16, 5
	beq r5,r16, HARD_UP
	movia r16, 6
	beq r5,r16, HARD_DOWN
	
	br EPILOGUE
	
NO_CHANGE_VERT:
	
	br PRINT_PIXEL
	
SOFT_UP:
	movia r16, SOFT_DISP
	add r9, r9, r16
	
	call check_y
    br PRINT_PIXEL

SOFT_DOWN:
	movia r16, SOFT_DISP
	sub r9, r9, r16
	
	call check_y
	br PRINT_PIXEL
	
MED_UP:
	movia r16, MED_DISP
	add r9, r9, r16
	
	call check_y
	br PRINT_PIXEL
	
MED_DOWN:
	movia r16, MED_DISP
	sub r9, r9, r16
	
	call check_y
	br PRINT_PIXEL
	
HARD_UP:
	movia r16, HARD_DISP
	add r9, r9, r16
	
	call check_y
	br PRINT_PIXEL

HARD_DOWN:
	movia r16, HARD_DISP
	sub r9, r9, r16
	
	call check_y
	br PRINT_PIXEL
	


PRINT_PIXEL:	
  
   movia r2,ADDR_VGA 
   
   #prints cursor into newly calculated location
    movui r4,CURSOR_COLOR  /* White pixel */
  
	muli r20, r8, 2  # store 2*X into r20
	muli r21, r9, 1024 #store y*1024 into r21
	add r20, r21, r20 # store 2*X+1024*Y into r20
	add r20, r2, r20 # store pixel_base + 2*X+1024*Y into r20
	
	ldwio r5, 0(r20) # get color stored in target (x,y)

	movia r16, WALL_COLOR
	
	beq r5, r16, HIT_WALL
	
	movia r16, GOAL_COLOR
	
	beq r5, r16, HIT_GOAL
	
	movi r5, 0 # Did not hit wall nor goal
  
	sthio r4, 0(r20) # print pixel to (x,y)
	
	bne r8, r17, X_CHANGE
	
	NO_X_CHANGE: 
	
	beq r9,r18, NO_CHANGE
	
	X_CHANGE:
	#colors the last position of the cursor with the background color
	movui r4, BACKGROUND_COLOR
	
	muli r20, r17, 2  # store 2*X into r20
	muli r21, r18, 1024 #store y*1024 into r21
	add r20, r21, r20 # store 2*X+1024*Y into r20
	add r20, r2, r20 # store pixel_base + 2*X+1024*Y into r20
  
	sthio r4, 0(r20) # print pixel to (x,y)
	
	NO_CHANGE:
	
	call timer
	br EPILOGUE
	
	HIT_WALL:
	
	movi r5, 1 #failure hit wall
	br NO_CHANGE
	
	HIT_GOAL:
	
	movi r5, 2 #success hit final goal
	br NO_CHANGE
	
  EPILOGUE:
  
  #EPILOGUE
	  
	  ldw r16,0(sp)
	  ldw r17,4(sp)
	  ldw r18,8(sp)
	  ldw r19,12(sp)
	  ldw r20,16(sp)
	  ldw r21,20(sp)
	  ldw r22,24(sp)
	  ldw r23,28(sp)
	  ldw ra, 32(sp)
  
	  addi sp, sp, 36
  
	  ret
  
  
  #functions to check r8 (x) and r9 (y) so they can't go under 0 or over 320/240
  
  
  check_x:
	
	movia r16, 320
	
	bgt r8, r16, TOO_BIG_X
	blt r8, r0, TOO_SMALL_X
	
	ret
	
	TOO_BIG_X:
	
	movia r8, 320
	
	ret
	
	TOO_SMALL_X:
	
	mov r8, r0
	
	ret
	
 check_y:
 
	movia r16, 240
	
	bgt r9, r16, TOO_BIG_Y
	blt r9, r0, TOO_SMALL_Y
	
	ret
	
	TOO_BIG_Y:
	
	movia r9, 240
	
	ret
	
	TOO_SMALL_Y:
	
	mov r9, r0
	
	ret
	
  
  
  # TIMER 
  # using 0xCDFE60 as period , in decimal: 13500000 = 1/4 a second
  timer:

   movia r16, 0x10002000                   /* r7 contains the base address for the timer */
   movui r2, 0xFE60 
   movui r3, 0x000D
   stwio r2, 8(r16)                          /* Set the period to be N clock cycles stored in r4 + r5 (passed into function) */
   stwio r3, 12(r16)

   movui r2, 4
   stwio r2, 4(r16)                          /* Start the timer without continuing or interrupts */

 loop_check:

   ldwio r20, 0(r16)    /*loads value of timeout bit and checks if timer has timedout */
   andi r20, r20, 1 			
   beq r20, r0, loop_check
   
   stwio r0, 0(r16)
    
   ret 
  
  
  
  
  
  
  
  