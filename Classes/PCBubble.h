//
//  PCBubble.h
//  picrossGame
//
//  Created by loïc Abadie on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum{
	messageWithNone,
	messageWithConstelation,
	messageWithCancelButton,
	messageWithVictory,
	messageWithCheckNewMap,
    messageWithOkButton,
	messageWithInApp,
}bubbleStyle;

typedef enum{
	buttonCancelPressed,
	buttonBuyItPressed,
}buttonStyle;

@protocol PCMrNonoBubbleDelegate <NSObject>
@optional
- (void)buttonSelected:(NSUInteger)idx forBubleStyle:(bubbleStyle)bubbleStyle;
@end

@interface PCBubble : CCNode
- (id)initWithDelegate:(id<PCMrNonoBubbleDelegate>)delegate;
- (void)changeBubbleStyle:(bubbleStyle)bubbleStyle;
- (void)popUpBubbleWithMessages:(NSArray*)messages;
- (void)unPopBubble;
@property(nonatomic, assign)id<PCMrNonoBubbleDelegate> delegate;
@end
