//
//  TempMovesEngine.m
//  picrossGame
//
//  Created by loïc Abadie on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCTempMovesEngine.h"

@interface PCTempMovesEngine()
@property(nonatomic, assign) CGPoint	origin;
@property(nonatomic, assign) CGPoint	last;
@property(nonatomic, retain) CCArray*	_tmpMove;
@property(nonatomic, assign) BOOL		isOn;				// when the state machine is on
@property(nonatomic, assign) BOOL		isExecuting;		// when the state is on and executing.
@property(nonatomic, copy)BOOL (^callBack)(CGPoint, BOOL);
//@property(nonatomic, retain) NSTimer*	_timer;
@end

@implementation PCTempMovesEngine
@synthesize last,
			origin,
			delegate,
			isOn,
			isExecuting,
			timePerUpdate			= _timePerUpdate,
			callBack				= _callBack,
			genuineCurrentPosition	= _genuineCurrentPosition,
			_tmpMove;

// lock the position into X or Y axis, and keep traks of the set of moves
- (CGPoint)positionLocked:(CGPoint)tmpPnt isOrigin:(BOOL)isOrigin{
	if(isExecuting || (!isOrigin && !isOn))	
		return ([_tmpMove count])? [[_tmpMove lastObject] CGPointValue]: (CGPoint){-1,-1};
	
	isOn			= YES;
	CGPoint ftsPnt	= (isOrigin)? (origin = tmpPnt) : origin;
	CGPoint diffPnt	= CGPointMake(ftsPnt.x - tmpPnt.x, ftsPnt.y - tmpPnt.y);
	CGPoint iterPnt = CGPointZero;
	CGPoint movePnt = CGPointZero;
	
	(fabs(diffPnt.x) < fabs(diffPnt.y))?	(iterPnt.y = tmpPnt.y - ftsPnt.y): 
	(iterPnt.x = tmpPnt.x - ftsPnt.x);	
	switch ((int)iterPnt.x) {
		case 0:{	
			int moves	= fabsf(iterPnt.y);
			[self set_tmpMove: [CCArray arrayWithCapacity: moves]];
			
			for(int i = 0; i <= moves; i++){
				movePnt = (CGPoint){ftsPnt.x, (iterPnt.y <= 0)? (int)(ftsPnt.y - i) : (int)(ftsPnt.y + i)};
				[_tmpMove addObject: [NSValue valueWithCGPoint: movePnt]];
			}
		}break;
			
		default:{	
			int moves	= fabsf(iterPnt.x);
			[self set_tmpMove: [CCArray arrayWithCapacity: moves]];
			
			for(int i = 0; i <= moves; i++){
				movePnt = (CGPoint){ (iterPnt.x <= 0)? (ftsPnt.x - i) : (ftsPnt.x + i), ftsPnt.y};
				[_tmpMove addObject: [NSValue valueWithCGPoint: movePnt]];
			}
		}break;
	}
	
	last = [[_tmpMove lastObject] CGPointValue];
	[delegate updateDisplayInLockPosition: ftsPnt  lastPoint: last];
	
	return last;
}

- (void)executeMove:(BOOL (^)(CGPoint, BOOL)) updateBlock{
	if(!isOn || isExecuting){
		self.callBack	= nil;
		return;
	}
	
	self.callBack = updateBlock;
	
	isExecuting	= YES;
	// il est préférable de faire l'appel sur le même thread. Tout les perFormUpdate
	// doivent être appelé sur une thread différente de celle appelé. Sinon il est possible
	// que le delegate recoit les informations dans le désordre ou avec les mauvaises assertions.
	[self performSelector: @selector(performUpdate) withObject: nil afterDelay: 0];

//	[self performUpdate];
}

- (void)cancel{
	if(isExecuting) 
		return;
	
	[_tmpMove removeAllObjects];
	[delegate	tempMoveCanceled];
	isOn		= NO;
}

- (void)performUpdate{
	static uint counter						= 0;
	_genuineCurrentPosition					= [[_tmpMove objectAtIndex: counter] CGPointValue];		// pnt used for the controller
	BOOL isLast								= !(counter++ < [_tmpMove count] - 1);
	BOOL stopAction							= _callBack(_genuineCurrentPosition, isLast);
	
	if(!stopAction && !isLast){
		CGPoint pnt		= [[_tmpMove objectAtIndex: counter] CGPointValue]; // pnt used for the view
		[delegate updateDisplay: pnt  lastPoint: last];
		//[self performUpdate];
		[self performSelector: @selector(performUpdate) withObject: nil afterDelay: _timePerUpdate];
	}else{
		counter			= 0;
		isExecuting		= NO;
		self.callBack	= nil;
		isOn			= NO;
		[delegate updateDone];
	}
}

#pragma mark alloc/dealloc

- (id)init{
	if(self = [super init]){
		_timePerUpdate = .1f;
	}
	return self;
}

- (void)dealloc{
	[_callBack	release];
	[_tmpMove	release];
	[super		dealloc];
}
@end
