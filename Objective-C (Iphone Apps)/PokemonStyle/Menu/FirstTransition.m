//
//  FirstTransition.m
//  Menu
//
//  Created by khashayar hosseinzadeh on 12-12-22.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import "FirstTransition.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldLayer.h"
CCSprite *seeker1;

@implementation FirstTransition
@synthesize theMap;
@synthesize bgLayer;
@synthesize dude;
@synthesize stLayer;


+(id) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	FirstTransition *layer = [FirstTransition node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		self.theMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        self.bgLayer = [theMap layerNamed:@"bg"];
        
        self.stLayer = [theMap layerNamed:@"st"];
        stLayer.visible = NO; 
        
        // retreived the object layer
        CCTMXObjectGroup *objects = [theMap objectGroupNamed:@"oj"];
        // gets the information of that object layer in a dict
        NSMutableDictionary *startPoint = [objects objectNamed:@"StartPoint"];
        // gets the coordinatines for the object layer
        int x = [[startPoint valueForKey:@"x"]intValue];
        int y = [[startPoint valueForKey:@"y"]intValue];
        self.dude = [CCSprite spriteWithFile:@"ash.png"];
        dude.position = ccp(x,y);
        
        
        CCMenuItemFont *quitBlock = [CCMenuItemFont itemFromString:@"quit" target:self selector:@selector(doThat:)];
        quitBlock.position = ccp(-220,-70);
        quitBlock.color = ccc3(1, 1, 1);
        
        CCMenu *menu = [CCMenu menuWithItems:quitBlock, nil];
        
        //changing the camera to folow the center of the player
        [self setCenterOfScreen: dude.position];
        [self addChild:menu];
        self.isTouchEnabled = YES;
        [self addChild: dude];
        [self addChild: theMap z:-1];
    }
	return self;
}


-(void)doThat:(id)sender{
    // the CCDirector changes to the next class or file or whatever
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1 scene:[HelloWorldLayer node]]];
}


-(void)setCenterOfScreen:(CGPoint) position{
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    
    // use the max of either, so we dont get black corners
    int x = MAX(position.x, screenSize.width/2);
    int y = MAX(position.y, screenSize.height/2);
    
    //opposite corner
    x = MIN(x, theMap.mapSize.width * theMap.tileSize.width - screenSize.width/2);
    y = MIN(y, theMap.mapSize.height * theMap.tileSize.height - screenSize.height/2);
    
    // will be the ideal point for the camera
    CGPoint goodPoint = ccp(x,y);
    
    CGPoint centerOfScreen = ccp(screenSize.width/2, screenSize.height/2);
    CGPoint difference = ccpSub(centerOfScreen, goodPoint);
    self.position = difference; // moves the entire layer, by however much we need to move
    // we are actually tricking the computer, we move the layer to the iphone page
}

-(void) registerWithTouchDispatcher{
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    // where in the view did we touch and store into touchLocation
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    // uses the map coordinates, not the iphone coordinates
    touchLocation = [self convertToNodeSpace:touchLocation];
                             
    CGPoint playerPos = dude.position;
    CGPoint diff = ccpSub(touchLocation, playerPos);
    //move in the max direction if u click a diagonal
    // find the difference in x and y and see which is greater, that is the one u move
    if (abs(diff.x) > abs(diff.y)){
        if(diff.x > 0){ // right or left
            playerPos.x += theMap.tileSize.width;
        } else {
            playerPos.x -= theMap.tileSize.width;
        }
    } else { // up and down
        if(diff.y > 0){
            playerPos.y += theMap.tileSize.height;
        } else {
            playerPos.y -= theMap.tileSize.height;
        }
    }
                             
    // make sure the new position isnt off the map
    if (playerPos.x <= (theMap.mapSize.width * theMap.tileSize.width) && playerPos.y <= (theMap.mapSize.height * theMap.tileSize.height) && playerPos.y >= 0 && playerPos.x >= 0){
        // set player position
        
        [self setPlayerPosition: playerPos];
        
        
    }
    
    [self setCenterOfScreen:dude.position];
                        
}

-(void) setPlayerPosition:(CGPoint)position{
    CGPoint tileCoord = [self tileCoordForPosition:position];
    
    int tileGid = [stLayer tileGIDAt:tileCoord];
    
    if (tileGid){
        
        NSDictionary *properties = [theMap propertiesForGID:tileGid];
        // gets the position we want to move to, checks the collidable's value, if its true then we know its a bound. it returns so it doesnt do anything
        if(properties){
            NSString *collision = [properties valueForKey:@"Collidable"];
            if (collision && [collision compare:@"True"] ==NSOrderedSame){
                return;
            }
        }
    }
    dude.position = position; 
}

-(CGPoint)tileCoordForPosition:(CGPoint)position{
    int x = position.x/theMap.tileSize.width;
    int y = ((theMap.mapSize.height * theMap.tileSize.height)-position.y)/theMap.tileSize.height;
    return ccp(x,y);
}


- (void) dealloc
{
    self.theMap = nil;
    self.bgLayer = nil;
    self.dude = nil;
    self.stLayer = nil;
	[super dealloc];
}


@end
