//
//  PCFallingStar.m
//  picrossGame
//
//  Created by loïc Abadie on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCFallingStar.h"
#import "GameConfig.h"

@interface  PCFallingStar()
@property(nonatomic, retain)NSTimer* _timer;
@end

@implementation PCFallingStar
@synthesize _timer;

- (void)fall:(NSTimer*)timer{
	if(rand()%3)
		return;
	
	self.visible		= YES;
	self.position		= ccp(rand()%IPHONEWIDTH, IPHONEWIDTH);
	id a1				= [CCMoveTo actionWithDuration: 8 position:ccp(rand()%IPHONEWIDTH, -150)];
	id ease				= [CCEaseInOut actionWithAction: a1 rate: 2];
	id actionCallFunc	= [CCCallFunc actionWithTarget:self selector:@selector(endFalling)];
	id actionSequence	= [CCSequence actions: ease, actionCallFunc, nil];
	
	[self runAction: actionSequence];
}

- (void)endFalling{
	self.visible		= NO;
}

#pragma mark
- (void)onExit{
	[_timer	invalidate];
	[self	stopAllActions];
	[super	onExit];
}

#pragma mark alloc/dealloc
- (id)init{
	if(self = [super initWithColor:ccc4(0, 250, 0, 250) width:50 height:50]){
		srand(time(0));
		self.visible	= NO;
		//[self set_timer:  [NSTimer scheduledTimerWithTimeInterval: 10 target: self selector: @selector(fall:) userInfo: nil repeats: YES]];
	}
	return self;
}

- (void)dealloc{
	[_timer release];
	[super	dealloc];
}
@end
