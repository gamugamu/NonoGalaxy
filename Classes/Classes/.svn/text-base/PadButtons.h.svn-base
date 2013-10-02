//
//  PadButtons.h
//  UsingTiled
//
//  Created by loïc Abadie on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
	FILL,
	CROSS,
	BTNTYPELENGHT,
}buttonType;

@protocol buttonPadDelegate
- (void)buttonPressed:(buttonType)state;
- (void)buttonReleashed:(buttonType)state;
@end

@interface PadButtons : CCNode<CCTargetedTouchDelegate>{
	CGRect* buttonPadArray;
	id <buttonPadDelegate> padDelegate;
}

@property(nonatomic, assign)BOOL islocked;
- (CCNode*)buttonForTag:(buttonType)BType;
- (id)initWithDelegate:(id <buttonPadDelegate>)bpd;
- (void)changeButtonState:(buttonType)btnType;
@end
