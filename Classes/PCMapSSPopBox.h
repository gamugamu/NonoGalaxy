//
//  PCMapSSPopBox.h
//  picrossGame
//
//  Created by loïc Abadie on 01/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ProtocolHelpers.h"

@interface PCMapSSPopBox : CCLayer
- (void)popOutBox;
- (void)popInBox;
- (id)initWithDelegate:(id<GGButonPressedDelegate>) delegate;
@property(nonatomic, readonly)BOOL isPoping;
@property(nonatomic, assign)id<GGButonPressedDelegate> delegate;
@end
