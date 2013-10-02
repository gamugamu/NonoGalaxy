//
//  PCAnvil.h
//  picrossGame
//
//  Created by loïc Abadie on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GGBasicStruct.h"

@interface PCAnvil : CCNode
- (id)initWith4GColor:(color4Gl)color;
- (void)setStage:(uint)stage time:(uint)time;
- (void)setHilight:(BOOL)highlight;
- (void)copyDisplay:(PCAnvil*)anvil;
@end