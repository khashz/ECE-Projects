//
//  GameImp.h
//  NinjaMonkey
//
//  Created by khashayar hosseinzadeh on 12-12-25.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
CCSprite *_nextProjectile;


@interface GameImp : CCLayer {
    CCProgressTimer *progressTimer;
    float _monkeyPointsPerSecX;
    CCSprite *_monkey;
    CCAction *_walkAction;
    CCSprite *_monkeyJump;
    CCAction *_JumpAction;
    CCAction *_moveAction;
                        //draw line
    CGPoint _startPoint;
    CGPoint _endPoint;
    BOOL _moving;
}

@property (nonatomic, retain) CCSprite *monkey;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCSprite *monkeyJump;
@property (nonatomic, retain) CCAction *jumpAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCProgressTimer *progressTimer;
@end
    