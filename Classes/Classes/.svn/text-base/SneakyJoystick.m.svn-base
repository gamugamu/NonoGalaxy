//
//  joystick.m
//  SneakyJoystick
//
//  Created by Nick Pannuto.
//  2/15/09 verion 0.1

#import "SneakyJoystick.h"

#define SJ_PI 3.14159265359f
#define SJ_PI_X_2 6.28318530718f
#define SJ_RAD2DEG 180.0f/SJ_PI
#define SJ_DEG2RAD SJ_PI/180.0f

@interface SneakyJoystick(hidden)
- (void)updateVelocity:(CGPoint)point andEventPhase:(UITouchPhase)touchPhase;
- (void)setTouchRadius;
@end

@implementation SneakyJoystick

@synthesize		stickPosition,
				degrees,
				velocity,
				autoCenter,
				isDPad,
				hasDeadzone,
				numberOfDirections,
				joystickRadius,
				thumbRadius,
				deadRadius,
				joyStickDelegate;

- (void)onEnterTransitionDidFinish{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
													 priority:1 
											  swallowsTouches:YES];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

-(void)updateVelocity:(CGPoint)point andEventPhase:(UITouchPhase)touchPhase{
	float dx	= point.x;													// Calculate distance and angle from the center.
	float dy	= point.y;
	float dSq	= dx * dx + dy * dy;
	float cosAngle;
	float sinAngle;
	
	if(dSq <= deadRadiusSq){
		velocity		= CGPointZero;
		degrees			= 0.0f;
		stickPosition	= point;
		[joyStickDelegate updatePositions:stickPosition withTouchPhase:touchPhase];
		return;
	}
	
	float angle = atan2f(dy, dx);											// in radians
	
	if(angle < 0)
		angle += SJ_PI_X_2;
	
	if(isDPad){
		float anglePerSector = 360.0f / numberOfDirections * SJ_DEG2RAD;
		angle = roundf(angle/anglePerSector) * anglePerSector;
	}
	
	cosAngle = cosf(angle);
	sinAngle = sinf(angle);

	if (dSq > joystickRadiusSq || isDPad) {									// Velocity goes from -1.0 to 1.0.
		dx = cosAngle * joystickRadius;
		dy = sinAngle * joystickRadius;
	}
	
	velocity = CGPointMake(dx/joystickRadius, dy/joystickRadius);
	degrees = angle * SJ_RAD2DEG;	
	stickPosition = ccp(dx, dy);											// Update the thumb's position
	[joyStickDelegate updatePositions:stickPosition withTouchPhase:touchPhase];
}

#pragma mark setter
- (void)setIsDPad:(BOOL)boolean{
	isDPad = boolean;
	if(isDPad){
		hasDeadzone = YES;
		self.deadRadius = 10.0f;
	}
}

- (void)setJoystickRadius:(float)radius{
	joystickRadius		= radius;
	joystickRadiusSq	= radius*radius;
}

- (void)setThumbRadius:(float)radius{
	thumbRadius			= radius;
	thumbRadiusSq		= radius*radius;
}

- (void)setDeadRadius:(float)radius{
	deadRadius			= radius;
	deadRadiusSq		= radius*radius;
}

#pragma mark CocosTargetTouch Delegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL:[touch locationInView:[touch view]]];
	
	location = [self convertToNodeSpace:location];							//Do a fast rect check before doing a circle hit check
	
	if(location.x < -joystickRadius || location.x > joystickRadius 
	   || location.y < -joystickRadius || location.y > joystickRadius){
		return NO;
	}
	else{
		float dSq = location.x*location.x + location.y*location.y;
		if(joystickRadiusSq > dSq){
			[self updateVelocity:location andEventPhase:[touch phase]];
			return YES;
		}
	}
	return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location	= [[CCDirector sharedDirector] 
										convertToGL:[touch locationInView:[touch view]]];
	
	location = [self convertToNodeSpace:location];
	[self updateVelocity:location andEventPhase:[touch phase]];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = CGPointZero;
	if(!autoCenter){
		location = [[CCDirector sharedDirector] 
							convertToGL:[touch locationInView:[touch view]]];
		location = [self convertToNodeSpace:location];
	}
	
	[self updateVelocity:location andEventPhase:[touch phase]];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
	[self ccTouchEnded:touch withEvent:event];
}

#pragma mark alloc/dealloc
-(id)initWithRect:(CGRect)rect{
	if(self = [super init]){
		stickPosition		= CGPointZero;
		degrees				= 0.0f;
		velocity			= CGPointZero;
		autoCenter			= YES;
		isDPad				= NO;
		hasDeadzone			= NO;
		numberOfDirections	= 4;
		self.joystickRadius = rect.size.width/2;
		self.thumbRadius	= 32.0f;
		self.deadRadius		= 0.0f;
		position_			= rect.origin;									//Cocos node stuff
	}
	return self;
}

- (void) dealloc{
	[super dealloc];
}
@end
