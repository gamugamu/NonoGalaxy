//
//  MoveTile.h
//  picrossGame
//
//  Created by loïc Abadie on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "buttonPad.h"

@interface PCMoveTile : NSObject {
}

- (void)newMap:(CCTMXLayer*)mapp;
- (void)moveTileInGrid:(CCNode*)tile;
- (CGPoint)getTilePosition;

@property (nonatomic, assign) buttonSide padState;
@end
