.data
.equ ADDR_JP1, 0x10000060   /*Address GPIO JP1*/
.equ DR, 0x0   
.equ DIR, 0x4
  
#used by VGA 
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000

.equ DontMove,     3
.equ MediumMove,   8
.equ HardMove,     12


.equ SOFT_DISP, 2
.equ MED_DISP, 3
.equ HARD_DISP, 5


.equ CURSOR_COLOR, 0xffff   /* white */
.text
.global main

/*
			REGISTERS
r16 - /base address for ADDR_JPI
r17 - holds the instruction going to the lego controller
r18 - will read the message from lego
r19 - TOPleftsensor
r20 - TOPrightsensor
r21 - BOTTOMleftsensor
r22 - BOTTOMrightsensor
r23 -
*/

main:
	
	#
	# PUT CALL TO START SCREEN FUNCTION HERE
	#
	
	movia  r16, ADDR_JP1 
	movia  r17, 0x07f557ff   #set sensors to inputs
	stwio  r17, 4(r16)

	movia sp, 0x0008888 #init stack pointer
	
	call generate_map

	
begin:    

	call VGA_MAIN # print cursor onto screen, includes timer

	movi r16, 1
	beq r5, r16, FAIL_GAME_OVER
	
	movi r16, 2
	beq r5, r16, WIN_GAME_OVER
	
	
	
/* read sensor 0, then 'and' the values to see if they are valid */
TOPleftsensor:
   movia  r17, 0xfffffbff      /* enable sensor 0, disable all motors BIT 10*/
   stwio  r17, 0(r16)			/* give lego our instruction */
   ldwio  r18,  0(r16)           /* checking for valid data sensor 0 (bit 11)*/
   srli   r18,  r18, 11           /* bit 11 (valid bit for sensor 0) is low, means we are good*/      
   andi   r18,  r18,0x1        /* if the sensors 0 has the value 0, it means good
   bne    r0,  r18, TOPleftsensor        /* checking if low indicated polling data at sensor 0 is valid*/
                        /* if its equal, it means we can read it, so move onto good */

   ldwio  r19, 0(r16)         /* read sensor0 value (into r19) */
   srli   r19, r19, 27       /* shift to the right by 27 bits so that 4-bit sensor value is in lower 4 bits */
   andi   r19, r19, 0x0f   /*disregard bit 31 */
 
 
  /* /////////////////////////////////// */ 
 TOPrightsensor:
   movia  r17, 0xffffefff      /* enable sensor 1, disable all motors BIT 10*/
   stwio  r17, 0(r16)			/* give lego our instruction */
   ldwio  r18,  0(r16)           /* checking for valid data sensor 0 (bit 11)*/
   srli   r18,  r18, 13           /* bit 13 (valid bit for sensor 0) is low, means we are good*/      
   andi   r18,  r18,0x1        /* if the sensors 0 has the value 0, it means good
   bne    r0,  r18, TOPrightsensor        /* checking if low indicated polling data at sensor 0 is valid*/
                        /* if its equal, it means we can read it, so move onto good */

   ldwio  r20, 0(r16)         /* read sensor0 value (into r19) */
   srli   r20, r20, 27       /* shift to the right by 27 bits so that 4-bit sensor value is in lower 4 bits */
   andi   r20, r20, 0x0f   /*disregard bit 31 */
 
 
 /* /////////////////////////////////// */ 
 BOTTOMleftsensor:
   movia  r17, 0xFFFFBFFF      /* enable sensor 2, disable all motors BIT 10*/
   stwio  r17, 0(r16)			/* give lego our instruction */
   ldwio  r18,  0(r16)           /* checking for valid data sensor 0 (bit 11)*/
   srli   r18,  r18, 15         /* bit 11 (valid bit for sensor 0) is low, means we are good*/      
   andi   r18,  r18,0x1        /* if the sensors 0 has the value 0, it means good
   bne    r0,  r18, BOTTOMleftsensor        /* checking if low indicated polling data at sensor 0 is valid*/
                        /* if its equal, it means we can read it, so move onto good */

   ldwio  r21, 0(r16)         /* read sensor0 value (into r19) */
   srli   r21, r21, 27       /* shift to the right by 27 bits so that 4-bit sensor value is in lower 4 bits */
   andi   r21, r21, 0x0f   /*disregard bit 31 */
 
  
 /* /////////////////////////////////// */ 
 BOTTOMrightsensor:
   movia  r17, 0xFFFEFFFF      /* enable sensor 3, disable all motors BIT 10*/
   stwio  r17, 0(r16)			/* give lego our instruction */
   ldwio  r18,  0(r16)           /* checking for valid data sensor 0 (bit 11)*/
   srli   r18,  r18, 17           /* bit 17 (valid bit for sensor 0) is low, means we are good*/      
   andi   r18,  r18,0x1        /* if the sensors 0 has the value 0, it means good
   bne    r0,  r18, BOTTOMrightsensor        /* checking if low indicated polling data at sensor 0 is valid*/
                        /* if its equal, it means we can read it, so move onto good */

   ldwio  r22, 0(r16)         /* read sensor0 value (into r19) */
   srli   r22, r22, 27       /* shift to the right by 27 bits so that 4-bit sensor value is in lower 4 bits */
   andi   r22, r22, 0x0f   /*disregard bit 31 */
 
/* r19 - TOPleftsensor      */
/* r20 - TOPrightsensor     */
/* r21 - BOTTOMleftsensor   */
/* r22 - BOTTOMrightsensor  */
/* higher the number means closer to the ground */
/* can use r17, r18, r23 */


compare:

							/*  CHECK FOR X DIRECTIONAL MOVEMENT */
blt r19, r20, moveRight       /* top left < top right, if true go right */
							/* if its not true, either equal or move left */
beq r19, r20, noXmovement  

/* if we get here, we have to move left */
/* sub r23, regGreater, regSmaller */
sub r23, r19, r20
movi r18, HardMove
bge r23, r18, hardMoveXneg
movi r18, MediumMove
bge r23, r18, mediumMoveXneg
movi r18, DontMove
bge r23, r18, softMoveXneg	 
br noXmovement


 
moveRight:
/* find delta and compare the states the delta can be in, based on that, move by that much */ 
sub r23, r20, r19
movi r18, HardMove
bge r23, r18, hardMoveXpos
movi r18, MediumMove
bge r23, r18, mediumMoveXpos
movi r18, DontMove
bge r23, r18, softMoveXpos

noXmovement: 
movi r4, 0


/* after we incrememt x, we must return here */

								
								
								
								
								
								/*  CHECK FOR Y DIRECTIONAL MOVEMENT */
Ydirection:
blt r19, r21, moveDown       /* top left < bottom left, if true move down */
beq r19, r21, noYmovement

/* if we get here, we have to move upwards  */
sub r23, r19, r21
movi r18, HardMove
bge r23, r18, hardMoveYpos
movi r18, MediumMove
bge r23, r18, mediumMoveYpos
movi r18, DontMove
bge r23, r18, softMoveYpos 
br noYmovement
 
moveDown:
sub r23, r21, r19
movi r18, HardMove
bge r23, r18, hardMoveYneg
movi r18, MediumMove
bge r23, r18, mediumMoveYneg
movi r18, DontMove
bge r23, r18, softMoveYneg	
 
 

noYmovement:
movi r5, 0
br begin   /* repeat the entire process again */ 


hardMoveXneg:
movi r4, 5
br Ydirection   

mediumMoveXneg:
movi r4, 3
br Ydirection   

softMoveXneg:
movi r4, 1
br Ydirection   

hardMoveYpos:
movi r5, 5
br begin   /* repeat the entire process again */ 

mediumMoveYpos:
movi r5, 3
br begin   /* repeat the entire process again */ 

softMoveYpos:
movi r5, 1
br begin   /* repeat the entire process again */ 

hardMoveXpos:
movi r4, 6
br Ydirection   

mediumMoveXpos:
movi r4, 4
br Ydirection   

softMoveXpos:
movi r4, 2
br Ydirection   

hardMoveYneg:
movi r5, 6
br begin   /* repeat the entire process again */ 

mediumMoveYneg:
movi r5, 4
br begin   /* repeat the entire process again */ 

softMoveYneg:
movi r5, 2
br begin   /* repeat the entire process again */ 
 
 
 FAIL_GAME_OVER:
 
 #call function that prints game over screen (LOSS) should implement a way to reset the game
 
 WIN_GAME_OVER:
 
 #call function that prints game over screen (WIN) should implement a way to reset the game
 
 
 
 
 
 
 
 
 
 
 