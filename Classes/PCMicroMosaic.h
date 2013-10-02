//
//  PCMicroMosaic.h
//  picrossGame
//
//  Created by loïc Abadie on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PScannerDelegate.h"
#import "PCTouchGridProtocol.h"
#import "cocos2d.h"

@interface PCMicroMosaic : CCSprite <PCTouchGridProtocol>
- (id)initWithGrid:(CGSize)gridSize microLeftBoard:(CCTMXTiledMap*)mLeftBoard microUpBoard:(CCTMXTiledMap*)mUpBoard;
- (void)updateExceedDisplay:(CGSize)exceed;
- (void)updateGrid:(CGPoint)pnt withCrossState:(picrossState)picState;
@end
