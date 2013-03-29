//
//  MonkeySprite.m
//  NinjaMonkey
//
//  Created by khashayar hosseinzadeh on 12-12-31.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import "MonkeySprite.h"
#import "GameImp.h"


@implementation MonkeySprite

/*
 -(void)updateSprite:(ccTime)dt{

CGSize winSize = [CCDirector sharedDirector].winSize;

[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
 @"monkey_default.plist"];

CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                  batchNodeWithFile:@"monkey_default.png"];
[self addChild:spriteSheet];

NSMutableArray *walkAnimFrames = [NSMutableArray array];

if ((abs(_startPoint.x - _endPoint.x) < abs(_startPoint.y - _endPoint.y))) { //location.y > 130
    for(int i = 1; i <= 4; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"monkeyjump%d.png", i]]];
    }
}
else if (CGPointEqualToPoint(_startPoint,_endPoint) == YES && _startPoint.y < 130) { //location.y > 130
    for(int i = 1; i <= 2; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"monkeyshoot%d.png", i]]];
    }
}
else{
    for(int i = 1; i <= 2; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"monkeywalk%d.png", i]]];
    }
}

CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.2f];
self.monkey = [CCSprite spriteWithSpriteFrameName:@"monkeywalk1.png"];        
_monkey.position = ccp(50, winSize.height/2 - 70);
self.walkAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkAnim]];
[_monkey runAction:_walkAction];
[spriteSheet addChild:_monkey];



[self schedule:@selector(updateSprite:)];

}

*/
/*
-(void)addToLayer{

    CCMenuItemFont *quitBlock = [CCMenuItemFont itemWithString:@"quit" target:self selector:@selector(doThat:)];
    quitBlock.position = ccp(-215,140); // -215,140
    //quitBlock.color = ccc3(0, 0, 0);
    

    CCMenuItemImage *left = [CCMenuItemImage itemWithNormalImage:@"leftArrow.png" selectedImage:@"leftArrow.png" target:self selector:@selector(moveLeft:)];
    left.position = ccp(-210,-140); //-210 -140
    
    CCMenuItemImage *right = [CCMenuItemImage itemWithNormalImage:@"rightArrow.png" selectedImage:@"rightArrow.png" target:self selector:@selector(moveRight:)];
    right.position = ccp(-152,-140);
   

    
    CCMenu *menu = [CCMenu menuWithItems:left, right, quitBlock, nil];
    [GameImp addChild:menu];
}
*/
    
@end
