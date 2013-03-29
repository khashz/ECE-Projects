

#spacing check

# x < 50 skip 
    movi r16, 50
    blt r8, r16, skip_counter
	movi r16, 55
	bgt r8, r16, CHECK_1
	br COUNTER
  
  CHECK_1: # 55 < x < 70 skip
  
    movi r16, 70
    blt r8, r16, skip_counter
	movi r16, 75
    bgt r8, r16, CHECK_2
	br COUNTER

   CHECK_2:	# 75 < x < 90
	
	movi r16, 90
    blt r8, r16, skip_counter
	movi r16, 95
    bgt r8, r16, CHECK_3
	br COUNTER
  
  CHECK_3: # 95 < x < 110
  
    movi r16, 110
    blt r8, r16, skip_counter
	movi r16, 115
    bgt r8, r16, CHECK_4
	br COUNTER
	
  CHECK_4: # 115 < x < 130
  
    movi r16, 130
    blt r8, r16, skip_counter
	movi r16, 135
    bgt r8, r16, CHECK_5
	br COUNTER
	
   CHECK_5: # 135 < x < 150
  
    movi r16, 150
    blt r8, r16, skip_counter
	movi r16, 155
    bgt r8, r16, CHECK_6
	br COUNTER
	
	CHECK_6: # 155 < x < 170
  
    movi r16, 170
    blt r8, r16, skip_counter
	movi r16, 175
    bgt r8, r16, CHECK_7
	br COUNTER
	
	CHECK_7: # 175 < x < 190
  
    movi r16, 190
    blt r8, r16, skip_counter
	movi r16, 195
    bgt r8, r16, CHECK_8
	br COUNTER
	
	CHECK_8: # 195 < x < 210
  
    movi r16, 210
    blt r8, r16, skip_counter
	movi r16, 215
    bgt r8, r16, CHECK_9
	br COUNTER
	
	CHECK_9: # 215 < x < 230
  
    movi r16, 230
    blt r8, r16, skip_counter
	movi r16, 235
    bgt r8, r16, CHECK_10
	br COUNTER
	
	CHECK_10: # 235 < x < 250
  
    movi r16, 250
    blt r8, r16, skip_counter
	movi r16, 255
    bgt r8, r16, CHECK_11
	br COUNTER
	
	CHECK_11: # 255 < x < 270
  
    movi r16, 270
    blt r8, r16, skip_counter
	movi r16, 275
    bgt r8, r16, skip_counter
	br COUNTER