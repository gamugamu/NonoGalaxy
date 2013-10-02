//
//  SquareJoystick.m
//  UsingTiled
//
//  Created by loïc Abadie on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SquareJoystick.h"

@interface SquareJoystick(PrivateClass)
- (void)setUpPad;
- (void)addPadDirection:(NSString*)display position:(CGPoint)point touch:(buttonSide)touchSide;
@end

@implementation SquareJoystick

#define NUMBEROFBUTTONS 4
#define PADSIZE 50
#define TOUCHRADIUS 145
// TOUCHRADIUS == PADSIZE*1.5 + 70px (tolerance)

- (void)setUpPad{
	center				= CGPointMake(PADSIZE*1.5, PADSIZE);
	currentPadButton	= -1;
	[self addPadDirection:@"left.png"	position:CGPointMake(PADSIZE/2, PADSIZE) touch:LEFT];
	[self addPadDirection:@"right.png"	position:CGPointMake(PADSIZE*2.5, PADSIZE) touch:RIGHT];
	[self addPadDirection:@"up.png"		position:CGPointMake(PADSIZE*1.5, PADSIZE*1.5) touch:UP];
	[self addPadDirection:@"down.png"	position:CGPointMake(PADSIZE*1.5, PADSIZE/2) touch:DOWN];
}

- (void)addPadDirection:(NSString*)display position:(CGPoint)point touch:(buttonSide)touchSide{
	CCSprite* padSprite	= [[CCSprite alloc] initWithFile:display];
	padSprite.position	= point;
	[self addChild:padSprite z:0 tag:touchSide];
	[padSprite release];
}

- (void)changePosition:(CGPoint)point{
	self.position	= point;
	center			= ccpAdd(CGPointMake(PADSIZE*1.5, PADSIZE), point);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	if((int)currentPadButton != -1)
		return NO;
	
	CGPoint ct = [[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]];
	
	if(ccpDistance(center, ct) > TOUCHRADIUS)
		return NO;

	CGPoint pnt = ccpAdd(ct, ccpNeg(center));
	
	(pnt.x - pnt.y < 0)?	(fabs(pnt.x) < fabs(pnt.y))? 
									(currentPadButton = UP):	(currentPadButton = LEFT):
							(fabs(pnt.x) > fabs(pnt.y))?	
									(currentPadButton = RIGHT): (currentPadButton = DOWN);
	
	[(CCSprite*)[self getChildByTag:currentPadButton] setOpacity:100];
	[squarePaddelegate padPressed:currentPadButton];
		return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	[(CCSprite*)[self getChildByTag:currentPadButton] setOpacity:250];
	[squarePaddelegate padReleashed:currentPadButton];
	currentPadButton = -1;
}

#pragma mark subscrib_CCTouch
- (void)onEnterTransitionDidFinish{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)onExitDidFinish{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

#pragma mark alloc/dealloc
- (id)initWithDelegate:(id <squarePadDelegate>)delegate{
	if(self = [super init]){
		squarePaddelegate = delegate;
		[self setUpPad];
	}
	return self;
}

- (void)dealloc{
	[super dealloc];
}
@end
