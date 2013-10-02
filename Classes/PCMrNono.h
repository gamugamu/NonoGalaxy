//
//  PCMrNono.h
//  picrossGame
//
//  Created by loïc Abadie on 31/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PCBubble.h"
#import "PCNonoDisplay.h"

@protocol PCMrNonoDelegate <PCMrNonoDisplay, PCMrNonoBubbleDelegate>
@end

@interface PCMrNono : CCNode
- (id)initWithDelegate:(id<PCMrNonoDelegate>)delegate_ appearance:(nonoStyle)style bubbleAppearance:(bubbleStyle)bubbleStyle;
- (void)changeAppearance:(nonoStyle)nonoStyle bubbleStyle:(bubbleStyle)bubbleStyle;
- (void)moveToPoints:(CGPoint*)pnt lenght:(uint)lenght matrice:(CGSize)size inverseY:(uint)invertY;
- (void)talk:(NSArray*)messages;
- (void)stopTalkin;
- (void)informAboutPrice:(float)price;
- (BOOL)canRepositionOnTheSameMap:(NSString*)currentMap;
@property(nonatomic, assign)CGPoint displayPosition;
@property(nonatomic, assign)CGPoint currentPosition;
@property(nonatomic, assign)BOOL isMoving;
@property(nonatomic, assign)id<PCMrNonoDelegate> delegate;
@end
