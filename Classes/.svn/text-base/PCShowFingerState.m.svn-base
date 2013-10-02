//
//  PCShowFingerState.m
//  picrossGame
//
//  Created by loïc Abadie on 18/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCShowFingerState.h"
#import "GameConfig.h"

@interface PCShowFingerState()
@property(nonatomic, retain)CCSprite*	_currentStateDisplay;
@property(nonatomic, assign)fingerState currentState;
@end

@implementation PCShowFingerState
@synthesize _currentStateDisplay,
			currentState;

#pragma mark public
- (void)cancelState{
	self.visible = NO;
}

- (void)changeFingerState:(fingerState)state{
	if(state != currentState){
		[_currentStateDisplay setDisplayFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: (state == fingerMoving)? @"fingerM.png" : @"fingerS.png"]];
	}
	self.visible					= YES;
	currentState					= state;
		//[NSObject cancelPreviousPerformRequestsWithTarget: self];
		//[self performSelector:@selector(unvisible) withObject: nil afterDelay: 1]; 
	//}
}

#pragma mark private
- (void)unvisible{
	currentState = fingerNone;
	self.visible = NO;
}

#pragma mark overide
-(void)onExit{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"fingerState.plist"];//<---
	[super onExit];
}

#pragma mark setup
- (void)setupState{
	self.visible	= NO;
	CCSprite* state = [CCSprite spriteWithSpriteFrameName: @"fingerM.png"];
	state.position	= ccp(IPHONEWIDTHDEMI , IPHONEHEIGHTDEMI - 200);
	[self set_currentStateDisplay: state];
	[self addChild: _currentStateDisplay];
}

#pragma mark alloc / dealloc
- (id)initFingerState{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"fingerState.plist"]; //<---
	if (self = [super initWithFile:@"fingerState.png" capacity: 5]) {
		[self setupState];
	}
	return self;
}

- (void)dealloc{
	[_currentStateDisplay	release];
	[super					dealloc];
}
@end
