//
//  GCAlertBox.h
//  picrossGame
//
//  Created by loïc Abadie on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@protocol GCAlertBoxDelegate <NSObject>
- (BOOL)buttonPressed:(NSUInteger)button;
@end

@interface GCAlertBox : CCSpriteBatchNode
+ (void)displayMessage:(NSString*)message withButtonsMessages:(NSArray*)buttonMessages delegate:(id <GCAlertBoxDelegate>)delegate;
@end
