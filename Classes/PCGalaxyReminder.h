//
//  PCGalaxyReminder.h
//  picrossGame
//
//  Created by loïc Abadie on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PCGalaxyReminder : CCNode
- (void)updatecompleted:(uint)completed forTotal:(uint)total;
- (id)initWithDisplay:(NSString*)galaxyName andGalaxyName:(NSString*)galaxyName;
@end
