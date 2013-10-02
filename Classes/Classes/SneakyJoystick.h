//
//  joystick.h
//  SneakyJoystick
//
//  Created by Nick Pannuto.
//  2/15/09 verion 0.1

#import "cocos2d.h"

@protocol JoyStickDelegate
- (void)updatePositions:(CGPoint)position withTouchPhase:(UITouchPhase)touchPhase;
@end

@interface SneakyJoystick : CCNode <CCTargetedTouchDelegate> {
	BOOL autoCenter;
	BOOL isDPad;
	BOOL hasDeadzone;							// Turns Deadzone on/off for joystick, always YES if ifDpad == YES
	NSUInteger numberOfDirections;				// Used only when isDpad == YES
	float degrees;
	float joystickRadius;						/*_	Size of deadzone in joystick */
	float thumbRadius;							/*	(how far you must move before input starts). */
	float deadRadius;							/*	Automatically set if isDpad == YES */					
	float joystickRadiusSq;						/*_ Optimizations (keep Squared values of all */
	float thumbRadiusSq;						/*	radii for faster calculations) */
	float deadRadiusSq;							/*	(updated internally when changing joy/thumb radii) */
	CGPoint stickPosition;
	CGPoint velocity;
	id <JoyStickDelegate> joyStickDelegate;
}

-(id)initWithRect:(CGRect)rect;

@property (nonatomic, readonly) CGPoint stickPosition;
@property (nonatomic, readonly) float degrees;
@property (nonatomic, readonly) CGPoint velocity;
@property (nonatomic, assign) BOOL autoCenter;
@property (nonatomic, assign) BOOL isDPad;
@property (nonatomic, assign) BOOL hasDeadzone;
@property (nonatomic, assign) NSUInteger numberOfDirections;
@property (nonatomic, assign) float joystickRadius;
@property (nonatomic, assign) float thumbRadius;
@property (nonatomic, assign) float deadRadius;
@property (nonatomic, assign) id <JoyStickDelegate> joyStickDelegate;

@end
