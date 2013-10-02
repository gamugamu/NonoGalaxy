//
//  PCBagroundAntiTouch.m
//  picrossGame
//
//  Created by loïc Abadie on 26/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCBagroundAntiTouch.h"
#import "cocos2d.h"

@implementation PCBagroundAntiTouch
@synthesize priority;

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	return [[[self alloc] initWithColor:color width:w height:h] autorelease];
}

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h{
	if(self = [super initWithColor: color width: w height: h])
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority: 0 swallowsTouches:YES];

	return self;
}

- (void)cancelDSwallow{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}
@end
