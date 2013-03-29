//
//  FirstTransition.h
//  Menu
//
//  Created by khashayar hosseinzadeh on 12-12-22.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FirstTransition : CCLayer {
    CCTMXTiledMap *theMap;
    CCTMXLayer *bgLayer;
    CCSprite *dude;
    CCTMXLayer *stLayer; //special tiles, collision
}

@property(nonatomic, retain) CCTMXTiledMap *theMap;
@property(nonatomic, retain) CCTMXLayer *bgLayer;
@property(nonatomic, retain) CCSprite *dude;
@property(nonatomic, retain) CCTMXLayer *stLayer;
-(void)setCenterOfScreen:(CGPoint) position;
-(void) setPlayerPosition:(CGPoint)position;
-(CGPoint)tileCoordForPosition:(CGPoint)position;





+(id)scene;
@end
