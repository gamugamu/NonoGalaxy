//
//  PicrossPad.h
//  UsingTiled
//
//  Created by loïc Abadie on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PadButtons.h"
#import "SquareJoystick.h"

@interface PicrossPad : CCNode{
}
- (id)initWithDelegate:(id <buttonPadDelegate, squarePadDelegate>)delegate;
- (void)changeButtonState:(buttonType)btnState;
- (void)lockInput;
- (void)unlockInput;
@property(nonatomic, retain, readonly)PadButtons* _pad;

@end
