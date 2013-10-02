//
//  PicrossPad.m
//  UsingTiled
//
//  Created by loïc Abadie on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PicrossPad.h"
@interface PicrossPad()
@property(nonatomic, retain)PadButtons* _pad;
@end

@implementation PicrossPad
@synthesize _pad;

- (void)changeButtonState:(buttonType)btnState{
	[_pad changeButtonState: btnState];
}

- (void)lockInput{
	_pad.islocked = YES;
}

- (void)unlockInput{
	_pad.islocked = NO;
}

#pragma mark alloc/dealloc
- (id)initWithDelegate:(id <buttonPadDelegate, squarePadDelegate>)delegate{
	if (self = [super init]) {
		_pad = [[PadButtons alloc] initWithDelegate:delegate];
		[self addChild: _pad];
		/*SquareJoystick* squarJoystick	= [[SquareJoystick alloc] initWithDelegate:delegate];
		 [squarJoystick changePosition:ccp(10, 10)];
		 [self addChild:squarJoystick];
		 [squarJoystick release];*/
	}
	return self;
}

-(void)dealloc{
	[_pad release];
	[super dealloc];
}
@end
