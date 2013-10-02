//
//  CursorView.h
//  UsingTiled
//
//  Created by loïc Abadie on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCTouchGridProtocol.h"
#import "cocos2d.h"

@interface PCCursorView : CCSprite <PCTouchGridProtocol>
@property (nonatomic, assign)CGRect matrix;
@end
