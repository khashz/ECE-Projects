//
//  HelloWorldLayer.m
//  NinjaMonkey
//
//  Created by khashayar hosseinzadeh on 12-12-25.
//  Copyright University of Toronto 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "GameImp.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		CCMenuItemFont *item1 = [CCMenuItemFont itemWithString:@"Click to Start" target:self selector:@selector(doThis:)];
        
        CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"Developers Website" target:self selector:@selector(doWebsite:)];
        item2.position = ccp(110,-135);
        
        CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];
        //[menu alignItemsVerticallyWithPadding:5];
        [self addChild:menu];
        
	}
	return self;
}


-(void)doThis:(id)sender{
    // the CCDirector changes to the next class or file or whatever
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipAngular transitionWithDuration:1 scene:[GameImp node]]];
}
-(void)doWebsite:(id)sender{
    // the CCDirector changes to the next class or file or whatever
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com"]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
