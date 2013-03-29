//
//  GameImp.m
//  NinjaMonkey
//
//  Created by khashayar hosseinzadeh on 12-12-25.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import "GameImp.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "MonkeySprite.h"
#define MONKEYTRANSITIIONTONORMALRIGHTIMAGESPEED 0.4
#define AmountTochangeTotheRight _monkey.position.x + 5
#define AmountTochangeTotheLeft _monkey.position.x - 5
#define thresholdProjectiles 130

NSMutableArray * _projectiles;
@implementation GameImp

CCSprite *healthBar;
CCTMXTiledMap *map;


// At the top, under @implementation
@synthesize monkey = _monkey;
@synthesize moveAction = _moveAction;
@synthesize monkeyJump = _monkeyJump;
@synthesize jumpAction = _jumpAction;
@synthesize walkAction = _walkAction;
@synthesize progressTimer;


+(id) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameImp *layer = [GameImp node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	if( (self=[super init]) ) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
                                  
        //                        Menu
        CCMenuItemFont *quitBlock = [CCMenuItemFont itemWithString:@"quit" target:self selector:@selector(doThat:)];
        quitBlock.position = ccp(-215,140); // -215,140
        //quitBlock.color = ccc3(0, 0, 0);
        
        
                            
        //                      ArrowHeads
        CCMenuItemImage *left = [CCMenuItemImage itemWithNormalImage:@"leftArrow.png" selectedImage:@"leftArrow.png" target:self selector:@selector(moveLeft:)];
        left.position = ccp(-210,-140); //-210 -140
        
        CCMenuItemImage *right = [CCMenuItemImage itemWithNormalImage:@"rightArrow.png" selectedImage:@"rightArrow.png" target:self selector:@selector(moveRight:)];
        right.position = ccp(-152,-140);
        

        
        //                      Map
        map = [CCTMXTiledMap tiledMapWithTMXFile:@"jungle.tmx"];
        [map runAction:[CCRepeatForever actionWithAction:[CCMoveBy actionWithDuration:0.4 position:ccp(-32,0)]]];
        [self addChild:map];
        [self schedule:@selector(step:)];
        
        //                      Projectiles
        _projectiles = [[NSMutableArray alloc] init];
        
        
        
        //                    Health Bar
        // create and initialize our seeker sprite, and add it to this layer
        healthBar = [CCSprite spriteWithFile: @"GreenBar.png"];
        self.progressTimer = [CCProgressTimer progressWithSprite:healthBar];
        self.progressTimer.percentage = 100;
        self.progressTimer.position = ccp(winSize.width - 65, 20);
        
        NSString *healthbar;
        healthbar = @"Monkey's Health";
        CCLabelTTF * label = [CCLabelTTF labelWithString:healthbar fontName:@"Arial" fontSize:18];
        label.position = ccp(winSize.width/2 + 48, 20);
        [self addChild:label];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"monkey_default.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                          batchNodeWithFile:@"monkey_default.png"];
        [self addChild:spriteSheet];
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"monkeywalk%d.png", i]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.2f];
        self.monkey = [CCSprite spriteWithSpriteFrameName:@"monkeywalk1.png"];        
        _monkey.position = ccp(50, winSize.height/2 - 70);
        self.walkAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkAnim]];
        
        [_monkey runAction:_walkAction];
        [spriteSheet addChild:_monkey];

        /*
        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
            [jumpAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"monkeyjump%d.png", i]]];
        }
        CCAnimation *jumpAnim = [CCAnimation animationWithFrames:jumpAnimFrames delay:0.3f];
        self.monkeyJump = [CCSprite spriteWithSpriteFrameName:@"monkeyjump1.png"];        
        _monkeyJump.position = ccp(50, winSize.height/2 - 70);
        self.jumpAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:jumpAnim restoreOriginalFrame:NO]];
        
        _monkeyJump.visible = NO;
        [_monkeyJump runAction:_jumpAction];
        [spriteSheet addChild:_monkeyJump];
        */
        
        CCMenu *menu = [CCMenu menuWithItems:left, right, quitBlock, nil];
        [self addChild:menu];
        [self addChild:self.progressTimer];
        [self setIsTouchEnabled:YES];
        [self schedule:@selector(gravity:)];
        [self schedule:@selector(gameLogic:) interval:1.0];

    }
	return self;
}

-(void)step:(ccTime)dt{
    if(map.position.x < -608){
        [map setPosition:ccp(-32,0)];
        [map runAction:[CCRepeatForever actionWithAction:[CCMoveBy actionWithDuration:0.4 position:ccp(-32,0)]]];
    }
}

// accelerometer
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
#define kFilteringFactor 0.1
#define kRestAccelX -0.6
#define kMonkeyMaxPointsPerSec (winSize.height*0.5)        
#define kMaxDiffX 0.2
    
    UIAccelerationValue rollingX, rollingY, rollingZ;
    
    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));    
    rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));    
    rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float accelDiff = accelX - kRestAccelX;
    float accelFraction = accelDiff / kMaxDiffX;
    float pointsPerSec = kMonkeyMaxPointsPerSec * accelFraction;
    
    _monkeyPointsPerSecX = pointsPerSec;
    
}

// Add new update method
- (void)update:(ccTime)dt {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float maxX = winSize.width - _monkey.contentSize.width/2;
    float minX = _monkey.contentSize.width/2;
    
    float newX = _monkey.position.x + (_monkeyPointsPerSecX * dt);
    newX = MIN(MAX(newX, minX), maxX);
    _monkey.position = ccp(newX, _monkey.position.y);
  
    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _startPoint = location;
        _endPoint = location;
    }
}
 

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint = location;
    }
}
 
-(void)jump{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if (_monkey.position.y == winSize.height/2 - 70){
        id theAction = [CCJumpTo actionWithDuration:1.6 position:ccp(_monkey.position.x,_monkey.position.y) height:50 jumps:1];
        [_monkey runAction:theAction];
    }
}

-(void)gravity:(ccTime)dt{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    if (_monkey.position.y != winSize.height/2 - 70){
    _monkey.position = ccp(_monkey.position.x, _monkey.position.y - 1);
    }
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    //CGSize winSize = [CCDirector sharedDirector].winSize;

    //if (CGPointEqualToPoint(_startPoint,_endPoint) == NO && location.y > 130) { //location.y > 130
    if ((abs(_startPoint.x - _endPoint.x) < abs(_startPoint.y - _endPoint.y))) { // go into jump phase        
        //_monkey.visible=NO;
        //_monkeyJump.visible=YES;
        [self jump];
    }
    else if (location.y < thresholdProjectiles){ // shoot a projectile phase
    //_monkey.visible=YES;
    //_monkeyJump.visible=NO;

    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"projectile.png"];
    projectile.position = ccp(_monkey.position.x + 20, _monkey.position.y);
    
    
    // Determine offset of location to projectile, difference
    CGPoint offset = ccpSub(location, projectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) {
        [self addChild:projectile];
        
        int realX = winSize.width + (projectile.contentSize.width/2);
        float ratio = (float) offset.y / (float) offset.x;
        int realY = (realX * ratio) + projectile.position.y;
        CGPoint realDest = ccp(-realX, -realY);
        
        // Determine the length of how far you're shooting
        int offRealX = realX - projectile.position.x;
        int offRealY = realY - projectile.position.y;
        float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
        float velocity = 480/1; // 480pixels/1sec
        float realMoveDuration = length/velocity;
        
        // Move projectile to actual endpoint
        [projectile runAction:
         [CCSequence actions:
          [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [node removeFromParentAndCleanup:YES];
         }],
          nil]];
        
    }else {
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [node removeFromParentAndCleanup:YES];
     }],
      nil]];
    //[[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    }
   }
    if (location.x > _monkey.position.x || location.y > thresholdProjectiles) {
        _monkey.flipX = NO;
    } else {
        _monkey.flipX = YES;
        [self scheduleOnce:@selector(flipBack:) delay:MONKEYTRANSITIIONTONORMALRIGHTIMAGESPEED];
    }
    
}

-(void)doThat:(id)sender{
    // the CCDirector changes to the next class or file or whatever
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer node]]];
}

-(void)moveLeft:(id)sender{
    _monkey.position = ccp(AmountTochangeTotheLeft, _monkey.position.y);
    _monkey.flipX = YES;
    [self scheduleOnce:@selector(flipBack:) delay:MONKEYTRANSITIIONTONORMALRIGHTIMAGESPEED];

}

-(void)moveRight:(id)sender{
    _monkey.position = ccp(AmountTochangeTotheRight, _monkey.position.y);
    _monkey.flipX = NO;

}
-(void)flipBack:(id)sender{
    _monkey.flipX = NO;
}


-(void)gameLogic:(ccTime)dt {
    [self addMonster];
}

- (void) addMonster {
    
    CCSprite * monster = [CCSprite spriteWithFile:@"object_banana.png"];
    monster.scale = 0.3;
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = 130;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                                position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}


@end
