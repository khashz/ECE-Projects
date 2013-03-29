#RANDOM MAP GENERATOR
#Hari Halilovic 2013 ECE243

#Generates a random map (maze) for the player to traverse through at the start of the game (after start menu)

  
########################################################
#Generation of map is outlined as follows:
#

# AS OF RIGHT NOW GENERATION OF MAZE IS SLIGHTLY DIFFERENT 
# Horizontal walls are random (based on timer)
# Vertical walls are random+preset (based on timer)
# This change was made to make sure it was actually possible to traverse through the maze

#### BELOW HERE OLD ####

#1)First there is a snapshot taken of the timer (ranges from 0-20)
#2)Then distance data of the "gaps" between walls is calculated (snapshot+10)

##THE BELOW FORMULAS HAVE BEEN REMOVED/CHANGED ***************

#  for vertical walls the formula is: start first gap = rand+15, end first gap = (rand+15)*2, start third gap = (rand+15)*6, end third gap = ((rand+15)*6)+rand
#  This will result of gaps ranging from for ex: 10 (-wall-25-gap-50-wall-150-gap-160-wall-) , 30 (-wall-45-gap-90-wall-180-gap-210-wall)
  
# for Horizontal walls the formula is: first wall = rand, second = rand*2, third = rand*5, fourth = rand*7, fifth = rand*2 + 170
# EX 10: -gap-10(wall)-gap-20(wall)-gap-50(wall)-gap-70(wall)-gap-190(wall)-gap-
  
#new random numbers are obtained after set of vert/horiz walls are spawned
#Total of 11 walls starting at x = 50 going to x = 270
 
######################################################## 





.data
.equ ADDR_VGA, 0x08000000
.equ BACKGROUND_COLOR, 0x000f
.equ WALL_COLOR, 0x0ff0
.equ GOAL_COLOR, 0xfff0
.equ WALL_THICKNESS, 10

.text
.global generate_map
.global main

main:

generate_map:

	movia sp, 0x0008888 #init stack pointer
	
  addi sp, sp, -4
  stw ra, 0(sp)
  

  
  #first start a timer that continues
  #timer is used to generate "random" values (using snapshots at vary times)
  
   movia r7, 0x10002000                   /* r7 contains the base address for the timer */
   movui r2, 240
   stwio r2, 8(r7)                          /* Set the period to be 50 clock cycles */
   stwio r0, 12(r7)

   movui r2, 6
   stwio r2, 4(r7)                          /* Start the timer with continuing */

 
 
  
#r8 = x, r9 = y
#r10 = rand, r11,r12,r13,r14,r15 holds the rand numbers for gaps
#r17 = counter (for how many "strips" of a wall there is) r18 = vert or horiz wall? 0/1
 
   mov r8, r0

   movui r22, 320
   movui r23, 240

  start_spawn:
   
   
  movia r2,ADDR_VGA
  
  mov r17, r0    # set counter to 0 for how many "strips" are needed, this will increment to 5 before changing wall orientation
  movui r4,BACKGROUND_COLOR
  
  movi r16, 50
  
  blt r8, r16, START_PRINTING
  
  movi r16, 270
  
  bgt r8, r16, START_PRINTING
  
  
  call flip_wall #flips r18 on every call in order to alternate types of walls generated

 
  
   FILL_X:
 
	mov r9, r0
	
	bne r0, r17, FILL_Y

	beq r0, r18, RAND_VERT
	
	call random_num
	mov r11, r10
	call random_num
	mov r12, r10
	call random_num
	mov r13, r10
	call random_num
	mov r14, r10
	call random_num
	mov r15, r10

	
	br FILL_Y
	
	RAND_VERT:
	
	
	movi r16, 50
  
	blt r8, r16, START_PRINTING
  
	movi r16, 270
  
	bgt r8, r16, START_PRINTING
	
	
	call random_num2
	
	beq r10, r0, set0
	movi r16, 1
	beq r10,r16, set1
	
	
	movia r11, 0
	
	movia r12, 45
	
	movia r13, 120

	movia r14, 150
	
	movia r15, 200
	
	movia r6, 220

	
	br FILL_Y
	
set1:
	
	movia r11, 60
	
	movia r12, 85
	
	movia r13, 160

	movia r14, 180
	
	movia r15, 210
	
	movia r6, 220
	

	
	br FILL_Y
	
set0:
	
	movia r11, 70
	
	movia r12, 100
	
	movia r13, 120

	movia r14, 150
	
	movia r15, 170
	
	movia r6, 190
	

	
	
FILL_Y:
	
	
	
	movi r16, 50
  
	blt r8, r16, START_PRINTING
  
	movi r16, 270
  
	bgt r8, r16, START_PRINTING
	
	
	beq r0, r18, PRINT_VERT
	

	
	beq r9, r11, WALL_COLOR_CP
	beq r9, r12, WALL_COLOR_CP
	beq r9, r13, WALL_COLOR_CP
	beq r9, r14, WALL_COLOR_CP
	beq r9, r16, WALL_COLOR_CP

	
	

	movui r4,BACKGROUND_COLOR
	
	br START_PRINTING
	
WALL_COLOR_CP:
	
	movui r4,WALL_COLOR
	
	br START_PRINTING
	
	
	
	
PRINT_VERT:
	
	bgt r9, r11, FIRST_GAP_START
	
		movui r4,WALL_COLOR
		br LOAD_BEFORE_PRINT
	
	FIRST_GAP_START:
	
	    movui r4,BACKGROUND_COLOR
		
		bgt r9, r12, FIRST_GAP_END
		br LOAD_BEFORE_PRINT
		
	FIRST_GAP_END:
	
	   movui r4,WALL_COLOR
	   
	   bgt r9, r13, SECOND_GAP_START
	   br LOAD_BEFORE_PRINT
	   
	SECOND_GAP_START:
	
		movui r4,BACKGROUND_COLOR

		bgt r9, r14, SECOND_GAP_END
		br LOAD_BEFORE_PRINT
		
	SECOND_GAP_END:
	
		movui r4,WALL_COLOR
		
		bgt r9, r15, THIRD_GAP_START
		br LOAD_BEFORE_PRINT
		
	THIRD_GAP_START:
	
		movui r4, BACKGROUND_COLOR
		
		bgt r9, r6, THIRD_GAP_END
		br LOAD_BEFORE_PRINT
		
	THIRD_GAP_END:
	
		movui r4, WALL_COLOR
	
		
	
	
LOAD_BEFORE_PRINT:

	#ldw r11, 0(sp)
	#ldw r12, 4(sp)
	#ldw r13, 8(sp)
	#ldw r14, 12(sp)
	#ldw r15, 16(sp)
	#ldw r21, 20(sp)
	#ldw r17, 24(sp)
	#ldw r22, 28(sp)
	#ldw r19, 32(sp)
	#ldw r20, 36(sp)
	
	
	
START_PRINTING:
	
	movi r16, 270
  
	bgt r8, r16, BACKGROUND_COLOR_SET

	br START_PRINTING_SKIP
	
BACKGROUND_COLOR_SET:
	
	movui r4, BACKGROUND_COLOR
	
	movi r16, 289
  
	bgt r8, r16, CHECK_GOAL1
	br START_PRINTING_SKIP
	
	CHECK_GOAL1:
	
	movi r16, 299
  
	blt r8, r16, CHECK_GOAL2
	br START_PRINTING_SKIP
	
	CHECK_GOAL2:
	
	movi r16, 114
  
	bgt r9, r16, CHECK_GOAL3
	br START_PRINTING_SKIP
	
	CHECK_GOAL3:
	
	movi r16, 124
  
	blt r9, r16, CHECK_GOAL4
	br START_PRINTING_SKIP
	
	CHECK_GOAL4:
	
	movui r4, GOAL_COLOR
	
	
START_PRINTING_SKIP:

	muli r20, r8, 2  # store 2*X into r20
	muli r21, r9, 1024 #store y*1024 into r21
	add r20, r21, r20 # store 2*X+1024*Y into r20
	add r20, r2, r20 # store pixel_base + 2*X+1024*Y into r20
  
	sthio r4, 0(r20) # print pixel to (x,y)
	
	addi r9,r9, 1
	
	blt r9, r23, FILL_Y


	movi r16, 50
  
	blt r8, r16, skip_counter
  
	movi r16, 270
  
	bgt r8, r16, skip_counter
 	
	addi r17, r17, 1
	movi r16, WALL_THICKNESS
	bgt r17, r16, start_spawn

skip_counter:
	
	addi r8, r8, 1
    blt r8,r22, FILL_X

	
	#after loop set initial (x,y) 
	movia r8, 25
	movia r9, 120
	
	movia r4, 0
	movia r5, 0
	
end:

	#end loop for testing, remove once function is implemented
	
	br end
	
	ldw ra, 0(sp)
	
	addi sp, sp, 4
	
		
	ret
	
	
	
	
### Utility functions below	###
	
flip_wall:

	beq r0, r18, FLIP_1
	
	movi r18, 0
	
	ret
	
	FLIP_1:
	
	movi r18, 1
	
	ret
	
random_num:

   movia r7, 0x10002000           /* r7 contains the base address for the timer */
   stwio r0,16(r7)              /* Tell Timer to take a snapshot of the timer */
   ldwio r3,16(r7)              /* Read snapshot bits 0..15 */
   mov r10, r3
   addi r10,r10, 10 #does random (0-20)+10 = (10-30)
   
   movia r16, 230
   
   bgt r10, r16, FIX
   
   movia r16, 30
   
   blt r10, r16, FIX_2
   
   ret
   
   FIX:
   
   subi r10, r10, 50
   
   ret
   
   FIX_2:
   
   addi r10, r10, 50
   
   ret
   
   
   
random_num2: # generates random value of 0-1-2 to be used to determine which preset values to use

   movia r7, 0x10002000           /* r7 contains the base address for the timer */
   stwio r0,16(r7)              /* Tell Timer to take a snapshot of the timer */
   ldwio r3,16(r7)              /* Read snapshot bits 0..15 */
   mov r10, r3
   
   movia r16, 80
   
   bgt r10, r16, pass_1
   
   movia r10, 0
   
   ret
   
   pass_1:
   
   movia r16, 160
   
   bgt r10, r16, pass_2
   
   movia r10, 1
   
   ret
   
   pass_2:
   
   movia r10, 2
   
   
   ret
