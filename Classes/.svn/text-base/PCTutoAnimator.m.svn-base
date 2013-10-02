//
//  PCTutoAnimator.m
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCTutoAnimator.h"

@interface PCTutoAnimator()
-(CCAction*)runAction:(CCAction*) action;
-(void)stopAllActions;
@property(nonatomic, assign)PCTutorialPicrossGame*	delegate;
@property(nonatomic, assign)uint					nextShowCell;
@property(nonatomic, assign)CGPoint*				_listOfPoint;
@end

@implementation PCTutoAnimator
@synthesize delegate,
			nextShowCell,
			_listOfPoint;

#pragma mark public
- (void)animateShowCells{
	[self stopAllActions];
	id sequence		= [CCSequence actions:	[CCCallFunc actionWithTarget: self selector:@selector(askMoveCursor)],
											[CCDelayTime actionWithDuration: .5f], nil];
	id sequenceF	= [CCRepeatForever actionWithAction: sequence];
	
	[self runAction: sequenceF];
}

- (void)animateFullColumn:(CGPoint*)pnt forLenght:(uint)lenght{
	delegate.isBlocking = YES;
	
	CCArray* sequences	= [CCArray arrayWithCapacity: lenght * 2 - 1];

	for (int i = 0; i < lenght - 1; i++){
		[sequences addObject: [CCCallBlock actionWithBlock:BCA(^{[delegate simulateInMovingTouch: pnt[i] isOrigin: (i == 0)];})]];
		[sequences addObject: [CCDelayTime actionWithDuration: .2f]];
	}
	
	[sequences addObject: [CCCallBlock actionWithBlock:BCA(^{	[delegate simulateInMovingTouch: pnt[lenght - 1] isOrigin: NO];
																[delegate animationDone];})]];

	[self runAction: [CCFiniteTimeAction getActionSequence: sequences]];
}

#pragma mark private
- (void)askMoveCursor{
	CGPoint pnt = ccp(nextShowCell % 5, nextShowCell % 5);
	nextShowCell++;
	[delegate simulateFingerTouch: pnt forFingerState: simulateSimpleMove size: 5 - 1];
}

#pragma mark override
-(void)stopAllActions{
	[[CCActionManager sharedManager] removeAllActionsFromTarget: self];
}

-(CCAction*)runAction:(CCAction*) action{
	NSAssert( action != nil, @"Argument must be non-nil");
	
	[[CCActionManager sharedManager] addAction: action target: self paused: NO];
	return action;
}

#pragma mark alloc/dealloc
- (id)initWithDelegate:(PCTutorialPicrossGame*)delegate_{
	if(self = [super init]){
		delegate = delegate_;
	}
	return self;
}

- (void)dealloc{
	[self stopAllActions];
	free(_listOfPoint);
	[super dealloc];
}
@end
