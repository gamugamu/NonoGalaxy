//
//  PCCheckValidityTmx.h
//  picrossGame
//
//  Created by loïc Abadie on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PCCheckValidityTmx : NSObject
+ (void)validateMap:(CCTMXTiledMap*)map forStageSet:(CCTMXTiledMap*)stageSets;
@end
