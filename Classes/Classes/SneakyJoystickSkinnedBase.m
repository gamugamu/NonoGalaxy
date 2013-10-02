//
//  SneakyJoystickSkinnedBase.m
//  SneakyJoystick
//
//  Created by CJ Hanson on 2/18/10.
//  Copyright 2010 Hanson Interactive. All rights reserved.
//

#import "SneakyJoystickSkinnedBase.h"

@implementation SneakyJoystickSkinnedBase

@synthesize backgroundSprite, 
			thumbSprite,
			joystick,
			joyStickDelegate;

#pragma mark joystick Display
- (void)setBackgroundSprite:(CCSprite *)aSprite{
	if(backgroundSprite){
		if(backgroundSprite.parent)
			[backgroundSprite.parent removeChild:backgroundSprite cleanup:YES];
		[backgroundSprite release];
	}
	
	backgroundSprite = [aSprite retain];
	
	if(aSprite){
		[self addChild:backgroundSprite z:0];
		
		[self setContentSize:backgroundSprite.contentSize];
	}
}

- (void)setThumbSprite:(CCSprite *)aSprite{
	if(thumbSprite){
		if(thumbSprite.parent)
			[thumbSprite.parent removeChild:thumbSprite cleanup:YES];
		
		[thumbSprite release];
	}
	
	thumbSprite = [aSprite retain];
	
	if(aSprite){
		[self addChild:thumbSprite z:1];
		[joystick setThumbRadius:thumbSprite.contentSize.width/2];
	}
}

- (void)setJoystick:(SneakyJoystick *)aJoystick{
	if(joystick){
		if(joystick.parent)
			[joystick.parent removeChild:joystick cleanup:YES];
		
		[joystick release];
	}
	joystick = [aJoystick retain];
	
	if(aJoystick){
		[joystick setJoyStickDelegate:self];
		[self addChild:joystick z:2];
		
		if(thumbSprite)
			[joystick setThumbRadius:thumbSprite.contentSize.width/2];
		else
			[joystick setThumbRadius:0];
		
		if(backgroundSprite)
			[joystick setJoystickRadius:backgroundSprite.contentSize.width/2];
	}
}

#pragma mark joyStick Protocol
- (void)updatePositions:(CGPoint)position withTouchPhase:(UITouchPhase)touchPhase{
	if(joystick && thumbSprite)
		[thumbSprite setPosition:position];
	
	[joyStickDelegate updatePositions:joystick.velocity withTouchPhase:touchPhase];
}

#pragma mark alloc/dealloc
- (void) dealloc{
	joyStickDelegate = nil;
	[backgroundSprite release];
	[thumbSprite release];
	[joystick release];
	[super dealloc];
}

- (id) init{
	if(self = [super init]){
		joyStickDelegate	= nil;
		backgroundSprite	= nil;
		thumbSprite			= nil;
		joystick			= nil;
	}
	return self;
}
@end
