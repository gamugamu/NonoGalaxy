//
//  PCTutoStageBoard.m
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCTutoStageBoard.h"
#import "PCStageBoardHiddenMethod.h"
#import "PCTutoEffectHint.h"
#import "GameConfig.h"

@interface PCTutoStageBoard()
@property(nonatomic, assign) id<tutoStageBoardDelegate> delegate;
@property(nonatomic, assign) CCArray* _picError;
@property(nonatomic, retain) CCArray* _hintLayer;
@end

@implementation PCTutoStageBoard
@synthesize _picError,
            _hintLayer,
			delegate,
			needAllAction;

// used discretly by tutoPicrossGame
- (void)simulate_ccTouchesEnded{
	super.touchHasForcedEnd = NO;
	[super ccTouchesEnded: nil withEvent: nil];
}

- (void)simulateHint:(NSSet*)hintList{
    for(NSValue* value in hintList) {
        PCTutoEffectHint effect;
        [value getValue: &effect];
        CGPoint pnt                     = invertCoordinateHelper(effect.pnt);
        pnt                             = multiplyMatrix(pnt, TILESIZE);
        CCColorLayer* layerColor        = [CCColorLayer layerWithColor: (ccColor4B){0, 255, 255, 135} width: TILESIZE height: TILESIZE];
        CCRepeatForever* outAndIn		= [CCRepeatForever actionWithAction: [CCSequence actions: [CCFadeTo actionWithDuration: .5f opacity: 50] , [CCFadeTo actionWithDuration: .5f opacity: 180] ,nil]];

        [layerColor runAction: outAndIn];
        layerColor.position         = pnt;

        [_hintLayer addObject: layerColor];
        [self._stageDisplay addChild: layerColor];
    }
}

- (void)clearHint{
    for(CCColorLayer* layer in _hintLayer){
        [layer removeFromParentAndCleanup: YES];
    }
}

#pragma mark ovveride methode

- (void)cancel{
	if([delegate allowCancel]){
		[super._fingerState	cancelState];
		[super._hintBar		cancelTouchPoint];
		[super._cursor		cancelTouchPoint];
		[delegate cancelHasBeenDone];
	}
}

- (void)updateDone{
	if([delegate allowingTouch]){
		[delegate touchesDone: _picError];
		[_picError removeAllObjects];
	}
	[super updateDone];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(![delegate allowingTouch]) return;
	[super ccTouchesBegan: touches  withEvent: event];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(![delegate allowingTouch]) return;
	[super ccTouchesMoved: touches withEvent: event];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(![delegate allowingTouch]) return;
	
	CCArray* tmpMove	= super._tmpMoveEngine._tmpMove; // because CCArray is dumb

	// before computing the data, analyse it and inform delegate for errors
	for(int i = 0; i < [tmpMove count]; i++){
		NSValue* pntv	= [tmpMove objectAtIndex: i];
		CGPoint pnt		= [pntv CGPointValue];
		[_picError addObject: [NSValue valueWithCGRect: CGRectMake(pnt.x, pnt.y, [self tileForCoordinateTouch: pnt], 0)]];
	}
	
	//compute then inform controller;
	[super ccTouchesEnded: touches withEvent: event];
}

- (id)initWithStage:(CCTMXLayer*)stage stageLevel:(uint)level delegate:(id<tutoStageBoardDelegate>)delegate_ forConstelationName:(NSString *)constelationName{
	if(self = [super initWithStage: stage stageLevel: level delegate: delegate_ forConstelationName: constelationName]){
        delegate = delegate_;
        [self setUpDefault];
	}
	return self;
}

- (void)dealloc{
	[_picError release];
    [_hintLayer release];
	[super dealloc];
}

#pragma mark ---------------------------------- private -----------------------------------------------
#pragma mark ------------------------------------------------------------------------------------------

- (void)setUpDefault{
    _picError       = [[CCArray alloc] init];
    self._hintLayer = [CCArray array];
}

@end
