//
//  PCTutorialPicrossGame.m
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCTutorialPicrossGame.h"
#import "PCTutoStageBoard.h"
#import "PCDialogue.h"
#import "PCFilesManager.h"
#import "PCPicrossGameHiddenMethod.h"
#import "PCStageBoardHiddenMethod.h"
#import "PCTutoAnimator.h"
#import "PCNonoDisplay.h"
#import "PCTutoEffectHint.h"

@interface PCPicrossGame()
- (void)exitGame;
@end

@interface PCPicrossGame(privateM)
- (void)setUpDefault;
@end

@interface PCTutorialPicrossGame() <GCDialogueDelegate>{
    BOOL isAllowedToSwapTouch;
}
- (void)forceFill:(CGPoint)pnt forState:(picrossState)state;
- (void)undoAction:(CCArray*)actions;
- (void)addATempMove:(CGPoint)position;
- (void)allowActionForPlayer:(NSMutableSet*)actions;
- (void)actionsBeenDone;
- (void)tutoIsEnd;
@property(nonatomic, retain)NSMutableArray*		_stateDialogue;
@property(nonatomic, retain)PCDialogue*			_tutoDialogue;
@property(nonatomic, retain)PCTutoAnimator*		_tutoAnimator;
@property(nonatomic, retain)NSMutableSet*		_allowedActions;
@property(nonatomic, assign)CGPoint*			_columnPnt;
@property(nonatomic, assign)PCTutoStageBoard*	S_stageBoard;
@property(nonatomic, assign)PCStateDialogue*	lastDialogue;
@property(nonatomic, retain)PCNonoDisplay*      _nonoDisplay;
@property(nonatomic, retain)NSSet*              _allowedTap;
@property(nonatomic, assign)int					currentStep;
@property(nonatomic, assign)BOOL				hasAction;
@property(nonatomic, assign)BOOL				userTouchAllowed;
@property(nonatomic, assign)BOOL				allShouldBeActivatedInOn;
@property(nonatomic, assign)BOOL				waitingACancelAction;
@property(nonatomic, assign)SEL					functionSpecialEvent;
@end

@implementation PCTutorialPicrossGame
@synthesize currentStep,
			S_stageBoard,
			isBlocking,
			lastDialogue,
			hasAction,
			functionSpecialEvent,
			userTouchAllowed,
			allShouldBeActivatedInOn,
			waitingACancelAction,
            _allowedTap,
            _nonoDisplay,
			_columnPnt,
			_allowedActions,
			_stateDialogue,
			_tutoDialogue,
			_tutoAnimator;

#pragma mark public
- (void)simulateInMovingTouch:(CGPoint)pnt isOrigin:(BOOL)isOrigin{
	PCStateDialogue* d = [_stateDialogue objectAtIndex: currentStep];
	[S_stageBoard._tmpMoveEngine positionLocked: pnt isOrigin: isOrigin];
	[S_stageBoard._cursor 	newTouchPointIntoMatrice: invertCoordinateHelper(pnt)];
	[S_stageBoard._hintBar 	newTouchPointIntoMatrice: pnt];
	d.stateDisplay |= wasInMoving | wasInTouch;
}

- (void)simulateFingerTouch:(CGPoint)pnt forFingerState:(simulateFinger)state size:(uint)size{
	PCStateDialogue* d = [_stateDialogue objectAtIndex: currentStep];
	[S_stageBoard._cursor 	newTouchPointIntoMatrice: pnt];
    // Note: n'est utilisé que par le tuto 1.
	[S_stageBoard._hintBar 	newTouchPointIntoMatrice: (CGPoint){pnt.x, size - pnt.y}];
	d.stateDisplay |= wasInTouch;
}

- (void)simulateHint:(NSSet*)hintList{
    [S_stageBoard simulateHint: hintList];
}

- (void)tutoIsAnimating:(BOOL)isAnimating{

}

- (void)disableActions{
	[_tutoAnimator		stopAllActions];
	allShouldBeActivatedInOn	= NO;
	waitingACancelAction		= NO;
	hasAction					= NO;
}

#pragma mark tutoAction

- (void)performEvent:(PCStateDialogue*)state{
	[self disableActions];
	[self performSelector: functionSpecialEvent withObject: state];
    
	if((lastDialogue.stateDisplay & wasInTouch) == wasInTouch){
		[S_stageBoard._cursor			cancelTouchPoint];
		[S_stageBoard._hintBar			cancelTouchPoint];
		lastDialogue.stateDisplay ^= wasInTouch;
	}
	
	if((lastDialogue.stateDisplay & wasInMoving) == wasInMoving){
		[S_stageBoard._tmpMoveEngine	cancel];
		lastDialogue.stateDisplay ^= wasInMoving;
	}
}

- (void)displaySpecialEvent_tutoOne:(PCStateDialogue*)state{
    isAllowedToSwapTouch = YES;
	switch (state.stateEvent) {
        case 0: [self clearHint];                                               break;
		case 1: [_tutoAnimator animateShowCells];                               break;
		case 2: [_tutoDialogue displayTutoImage: 0];							break;
		case 3: [_tutoDialogue displayTutoImage: 1];							break;
#warning leaks
		case 4: {
                    [self changeStateTouch: FILL];
                    _columnPnt		= malloc(sizeof(CGPoint)*5);
					_columnPnt[0]	= CGPointMake(2, 0);
					_columnPnt[1]	= CGPointMake(2, 1);
					_columnPnt[2]	= CGPointMake(2, 2);
					_columnPnt[3]	= CGPointMake(2, 3);
					_columnPnt[4]	= CGPointMake(2, 4);
				[_tutoAnimator animateFullColumn: _columnPnt forLenght: 5];		break;}
		case 5:
                    [self changeStateTouch: FILL];
                    [S_stageBoard simulate_ccTouchesEnded];
                                                                                break;
		case 6: {
                    [self changeStateTouch: FILL];
                    isAllowedToSwapTouch = NO;
                    [self allowActionForPlayer: [NSMutableSet setWithObjects:	[NSValue valueWithCGRect: CGRectMake(1, 4, PICFILLED, 0)],
                                                                                [NSValue valueWithCGRect: CGRectMake(3, 4, PICFILLED, 0)], nil]];
                    NSValue* value              = [NSValue valueWithCGPoint: CGPointMake(1, 4)];
                    NSValue* value2             = [NSValue valueWithCGPoint: CGPointMake(3, 4)];
                    self._allowedTap            = [NSSet setWithObjects: value, value2, nil];

                    [self simulateHint: _allowedTap];
                                                                                break;}
		case 7:  {	_columnPnt		= malloc(sizeof(CGPoint)*5);
					_columnPnt[0]	= CGPointMake(3, 0);
					_columnPnt[1]	= CGPointMake(3, 1);
					_columnPnt[2]	= CGPointMake(3, 2);
					_columnPnt[3]	= CGPointMake(3, 3);
					_columnPnt[4]	= CGPointMake(3, 4);
					[self changeStateTouch: CROSS];
					[_tutoAnimator animateFullColumn: _columnPnt forLenght: 4];	break;}
		case 8:
                [self changeStateTouch: CROSS];
                [S_stageBoard simulate_ccTouchesEnded];
                [self clearHint];                                               break;
		case 9:
                [self changeStateTouch: CROSS];
                isAllowedToSwapTouch = NO;
                [self allowActionForPlayer:
                [NSMutableSet setWithObjects:
                [NSValue valueWithCGRect: CGRectMake(1, 3, PICCROSSED, 0)], nil]];
                NSValue* value              = [NSValue valueWithCGPoint: CGPointMake(1, 3)];
                self._allowedTap            = [NSSet setWithObjects: value, nil];
                [self simulateHint: _allowedTap];
                                                                                break;
		case 10: [self clearHint];
                 [self simulateHint: nil];                                      break;
		case 11: [self changeStateTouch: FILL];
                 [self allowActionForPlayer:[NSMutableSet setWithObjects:	[NSValue valueWithCGRect: CGRectMake(1, 1, PICFILLED, 0)], nil]];
																				break;
		case 12: [_tutoDialogue hidePrevious: YES];                             break;
        case 13: [self tutoIsEnd];                                              break;
	}
    
    isAllowedToSwapTouch? [self._picrossPad unlockInput] : [self._picrossPad lockInput];
}

- (void)displaySpecialEvent_tutoTwo:(PCStateDialogue*)state{
    NSLog(@"state evenr %u", state.stateEvent);
	switch (state.stateEvent) {
        case 0: [self clearHint];                                               break;
		case 1: [_tutoDialogue displaySequencesImage: [NSArray arrayWithObjects: @"tuto_2_0.png", @"tuto_2_1.png", nil]];
																				break;
		case 2: {allShouldBeActivatedInOn = YES;
            self._allowedTap            = [NSSet setWithObjects:
                                           [NSValue valueWithCGPoint: CGPointMake(0, 4)],
                                           [NSValue valueWithCGPoint: CGPointMake(1, 4)],
                                           [NSValue valueWithCGPoint: CGPointMake(2, 4)],
                                           [NSValue valueWithCGPoint: CGPointMake(3, 4)],
                                           [NSValue valueWithCGPoint: CGPointMake(4, 4)],nil];
            [_tutoDialogue displaySequencesImage: [NSArray arrayWithObjects: @"tuto_2_0.png", @"tuto_2_1.png", nil]];
            [self simulateHint: _allowedTap];
            
			[self allowActionForPlayer:[NSMutableSet setWithObjects:		[NSValue valueWithCGRect: CGRectMake(0, 4, PICFILLED, 0)],
																			[NSValue valueWithCGRect: CGRectMake(1, 4, PICFILLED, 0)],
																			[NSValue valueWithCGRect: CGRectMake(2, 4, PICFILLED, 0)],
																			[NSValue valueWithCGRect: CGRectMake(3, 4, PICFILLED, 0)],
																			[NSValue valueWithCGRect: CGRectMake(4, 4, PICFILLED, 0)],nil]];
																				break;}
		case 3:[_tutoDialogue displaySequencesImage: [NSArray arrayWithObjects: @"tuto_2_0.png", @"tuto_3_1.png", nil]];
																				break;
		case 4:{ waitingACancelAction	= YES;
            	[_tutoDialogue hideNext: YES];
                [_tutoDialogue displaySequencesImage: [NSArray arrayWithObjects: @"tuto_2_0.png", @"tuto_3_1.png", nil]];
                                                                                break;}
		case 5: userTouchAllowed		= YES;
            [_tutoDialogue hidePrevious: YES];                                  break;
	}
}

- (void)displaySpecialEvent_tutoThree:(PCStateDialogue*)state{
	switch (state.stateEvent) {
        case 0: [self clearHint];                                               break;
		case 1: [self clearHint];
                [_tutoDialogue displayTutoImage: 5];                            break;
        case 2: [self clearHint];
            _columnPnt		= malloc(sizeof(CGPoint)*3);
            _columnPnt[0]	= CGPointMake(1, 0);
            _columnPnt[1]	= CGPointMake(2, 0);
            _columnPnt[2]	= CGPointMake(3, 0);
            [self changeStateTouch: FILL];
            [_tutoDialogue displayTutoImage: 5];
            [_tutoAnimator animateFullColumn: _columnPnt forLenght: 3];         break;
            
                [self simulateHint: [NSSet setWithObjects:
                                 [NSValue valueWithCGPoint: CGPointMake(1, 0)],
                                 [NSValue valueWithCGPoint: CGPointMake(2, 0)],
                                 [NSValue valueWithCGPoint: CGPointMake(3, 0)], nil]];
                                                                                break;
		case 3:
            [self changeStateTouch: FILL];
            [S_stageBoard simulate_ccTouchesEnded];
            [self clearHint];
            [self simulateHint: [NSSet setWithObjects:
                                [NSValue valueWithCGPoint: CGPointMake(2, 2)],nil]];
            break;
        case 4:
            [_tutoDialogue hidePrevious: YES];
            userTouchAllowed = YES;                                             break;
            
        case 5: [S_stageBoard simulate_ccTouchesEnded];                         break;
	}
}

- (void)displaySpecialEvent_tutoFour:(PCStateDialogue*)state{
    switch (state.stateEvent) {
        case 1:
            [_tutoDialogue hidePrevious: YES];
            userTouchAllowed = YES;                                        break;
    }
}

#pragma mark private
// remove crossed or filled action when undoing 
- (void)undoAction:(CCArray*)actions{
	for (int i = 0; i < [actions count]; i++){
		CGRect actionData = [[actions objectAtIndex: i] CGRectValue];
		// if it's not a filled state, that can only be a crossed state
		[self forceFill: actionData.origin forState:((uint)actionData.size.width == PICFILLED)? PICUNFILLED : PICUNCROSSED];
	}
}

- (void)forceFill:(CGPoint)pnt forState:(picrossState)state{
	[super._engine		hasPicrossedTo: pnt		forState: state];
	// normalement comme on force, il ne devrait pas y avoir d'erreur
	[super._stageBoard	setStateFill: state	IntoCoordinate: pnt wasAnError: NO];
}

- (void)allowActionForPlayer:(NSMutableSet*)actions{
	// first we block next dial
	[_tutoDialogue hideNext: YES];
	hasAction               = YES;
	self._allowedActions    = actions;
}

- (void)setIsBlocking:(BOOL)isBlocking_{
	isBlocking = isBlocking_;
	[_tutoDialogue hideNext: isBlocking_];
	[_tutoDialogue hidePrevious: isBlocking_];
}

- (void)actionsBeenDone{
	hasAction = NO;
	((PCStateDialogue*)[_stateDialogue objectAtIndex: currentStep]).isUndoIsForced = YES;
	[self askNext];
}

- (void)addATempMove:(CGPoint)position{
	if(userTouchAllowed)
        return;
	
	PCStateDialogue* d = [_stateDialogue objectAtIndex: currentStep];
	
	if(!d._actions)
		[d set_actions: [CCArray arrayWithCapacity: 5]];
	
	CCArray*  a = d._actions;
	// using a CGRect object instead of a custom struct because i'm too lazy;
	[a addObject: [NSValue valueWithCGRect: CGRectMake(position.x, position.y, [super._stageBoard tileForCoordinateTouch: position], 0)]];
}

- (void)tutoIsEnd{
    [_tutoDialogue hidePrevious: YES];
    [_tutoDialogue hideNext: YES];
	[super gameEnded];
}

#pragma mark delegateMethode
#pragma mark delegateTutoStageBoard
- (void)cancelHasBeenDone{
	if(waitingACancelAction)
		[self askNext];
}

- (BOOL)allowCancel{
	return waitingACancelAction;
}

#define enumerateTouchSet(){\
	[touchSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {\
	CGPoint pntA = [obj CGRectValue].origin;\
	CGPoint pntB = [r CGRectValue].origin;\
		if(CGPointEqualToPoint(pntA, pntB)){\
			[aCopy removeObject: r];\
			CGRect data = [obj CGRectValue];\
			\
			if([obj CGRectValue].size.width != PICFILLED){\
				[self forceFill: data.origin forState: ([r CGRectValue].size.width == PICFILLED)? PICUNFILLED : data.size.width];\
			}\
		}\
	}];\
}

- (void)touchesDone:(CCArray*)touch{
    
	if(userTouchAllowed || waitingACancelAction)
        return;

	NSMutableSet* a			= [NSMutableSet setWithArray: [((PCStateDialogue*)[_stateDialogue objectAtIndex: currentStep])._actions getNSArray]];
	NSMutableSet* touchSet	= [NSMutableSet setWithArray: [touch getNSArray]]; 
    NSMutableSet* aCopy     = [a mutableCopy];
    
	[a enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
			NSValue* r = obj;
        
			if([_allowedActions containsObject: r]){
				if(allShouldBeActivatedInOn){
					if([_allowedActions isEqualToSet: a]){
						[_allowedActions removeAllObjects];
						[[_stateDialogue objectAtIndex: currentStep] set_actions: [CCArray arrayWithNSArray: [a allObjects]]];
						*stop = YES;
					}else{
						enumerateTouchSet();
					}
				}else
					[_allowedActions removeObject: r];
			}
			else{
				enumerateTouchSet();
            }
	}];

	[[_stateDialogue objectAtIndex: currentStep] set_actions: [CCArray arrayWithNSArray: [aCopy allObjects]]];
    [aCopy release];
    
	if(![_allowedActions count]){
		[self actionsBeenDone];
    }
}

- (BOOL)allowingTouch{
	return hasAction || userTouchAllowed || waitingACancelAction;
}

#pragma mark delegateTutoanimator
- (void)animationDone{
	free(_columnPnt);
	_columnPnt = nil;
	self.isBlocking = NO; 
}

#pragma mark delegateDialogue

- (BOOL)shouldHideNext{
    return currentStep == [_stateDialogue count];
}

- (BOOL)hasNext{
	return (currentStep != [_stateDialogue count] - 1);
}

- (BOOL)hasBack{
	return currentStep;
}

- (void)displayStateDialogue:(PCStateDialogue*)state{
	[_tutoDialogue dialogue: state._stateDialogue];
	[self performEvent: state];
	lastDialogue = state;
}

- (void)askNext{
	if(S_stageBoard._tmpMoveEngine.isExecuting) return;
	
	if(currentStep + 1 < [_stateDialogue count]){
		currentStep++;
		PCStateDialogue* d	= [_stateDialogue objectAtIndex: currentStep];
		d.stateButton		= self.currentStateTouch;
		[self displayStateDialogue: d];
	}
}

- (void)askUndo{
	if(S_stageBoard._tmpMoveEngine.isExecuting) return;

	if(currentStep - 1 >= 0){
		PCStateDialogue* d		=  [_stateDialogue objectAtIndex: currentStep];
		[self changeStateTouch: d.stateButton];
		
		if(d._actions){
			[self undoAction: d._actions];
			[d distroyActions];
		}
		currentStep--;
		d =  [_stateDialogue objectAtIndex: currentStep];
		[self displayStateDialogue: d];
		
		if(d.isUndoIsForced)
			[self askUndo];
	}
}

#pragma mark logic

- (void)createStateDialogue:(tutoLesson)currentLesson{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSDictionary* tutoPlist = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"PCtutorials" ofType:@"plist"]];//<---
	NSArray* dialogue		= [tutoPlist objectForKey: [NSString stringWithFormat:@"tutorial_%u", currentLesson]];
	
	[self set_stateDialogue: [NSMutableArray arrayWithCapacity: [dialogue count]]];
    
	switch (currentLesson) {
		case tuto_1_basis:          functionSpecialEvent = @selector(displaySpecialEvent_tutoOne:);		break;
		case tuto_2_showMove:       functionSpecialEvent = @selector(displaySpecialEvent_tutoTwo:);		break;
		case tuto_3_10x10:          functionSpecialEvent = @selector(displaySpecialEvent_tutoThree:);	break;
        case tuto_4_15x15ShowMove:  functionSpecialEvent = @selector(displaySpecialEvent_tutoFour:);     break;
		default: NSAssert(NO, @"STAGE NOT DONE YET. PLEASE DO IT THROW ERROR");break;
	}
	
	for (int i = 0; i < [dialogue count]; i++) {
		id object				= [dialogue objectAtIndex: i];
		PCStateDialogue* state	= nil;
		
		if([object isKindOfClass: [NSString class]]){
			state					= [[[PCStateDialogue alloc] init] autorelease];
			state._stateDialogue	= object;
			[_stateDialogue addObject: state];
		}
		else{
			state				= [_stateDialogue lastObject]; // we should never begin with a non string, so that's ok
			state.stateEvent	= [object unsignedIntValue];
		}
	}
	
	[pool release];
}

- (void)clearHint{
    [S_stageBoard clearHint];
    self._allowedTap = nil;
}


#pragma mark - override

- (void)buttonPressed:(buttonType)state{
        [super buttonPressed: state];
}

- (void)exitPressed:(CCMenuItem*)menuItem{
    //[super gameEnded];
    [super exitGame];
}

- (BOOL)fillTile:(CGPoint)position{
	if(waitingACancelAction)
		return YES;
    
    if(_allowedTap.count && ![_allowedTap containsObject: [NSValue valueWithCGPoint: position]])
       return YES;
    
	BOOL isAnError = [super fillTile: position];
	[self addATempMove: position];
	
	return isAnError;
}

- (void)failedAndCheckIfGameShouldEnd{
    // ne fait rien
}

- (void)gameEnded{
// normalement si on est sur le dernier dialogue, on peut considérer qu'on est à la fin 
// de la partie. On le déduit si le currentStep est sur le dernier dialogue.
	if(currentStep == _stateDialogue.count - 1)
		[super gameEnded];
}

- (void)StageWasSelected:(uint)stage forConstelation:(NSString*)constelationName{
	super.totalErrors		= 0;
    super.currentStageId    = stage;
	NSDictionary* info		= [[PCFilesManager sharedPCFileManager] getInfoForMapName: constelationName];

    [super setUpBackgroundWithColorInfo: [info valueForKey: mapInfoBagroundColor] andSubBagroundColor: [info valueForKey: mapInfoSubBagroundColor]];
	[super set_mapName: constelationName];
	[super setUpTimer];
	[super setupControlPad];
	[self set_nonoLayer: [[PCFilesManager sharedPCFileManager]	getSelectedStage: stage forConstelation: constelationName]];
	[self set_nonoName:  [((NSDictionary*)self._nonoLayer.properties) objectForKey: @"nonoName"]];

	CCTMXLayer* currentStage		= [[PCFilesManager sharedPCFileManager]	getSelectedStage: stage forConstelation: constelationName]; 
	S_stageBoard					= [[PCTutoStageBoard alloc]	initWithStage: currentStage
																stageLevel: stage
																delegate: self
																forConstelationName: constelationName];
	// override pntr
	super._stageBoard				= S_stageBoard;
	S_stageBoard._cursor.visible	= NO;

	[super addChild: S_stageBoard];
	[S_stageBoard parentHelpDisplay];
	[super addStageInfoDisplay: constelationName currentStage: stage];
	[super._engine setPicrossDelegate: S_stageBoard];
	[super._engine newStage: [S_stageBoard _currentStage]];
	[super setUpExitButton];
    [super performSelector: @selector(setUpDefault)];
	[self changeStateTouch: FILL];
}

#pragma mark setup

- (void)setUpDialogue:(tutoLesson)currentLesson{
    [self setUpNono];
	PCDialogue* dialogue    = [[PCDialogue alloc] initWithDelegate: self andMrNono: _nonoDisplay];
	dialogue.position       = ccp(150, 100);
	[self set_tutoDialogue: dialogue];
	[self addChild: _tutoDialogue z: 10];
	[self createStateDialogue: currentLesson];
	[self displayStateDialogue: [_stateDialogue objectAtIndex: 0]];
	[dialogue release];
}

- (void)setUpNono{
    _nonoDisplay            = [[PCNonoDisplay alloc] initWithDelegate: nil];
    _nonoDisplay.position   = ccp(130, 255);
    [_nonoDisplay changeNonoStyle: nonoVictory];
    [self addChild: _nonoDisplay z: 100];
}

- (void)setUpAnimator{
	PCTutoAnimator* animator = [[PCTutoAnimator alloc] initWithDelegate: self];
	[self set_tutoAnimator: animator];
	[animator release];
}

#pragma mark alloc/dealoc

- (id)initWithEngine:(id <PEngine>)engine andDelegate:(id <PCPicrossGameDelegate>)delegate_ forTutoLesson:(tutoLesson)tutoLesson{
	if(self = [super initWithEngine:engine andDelegate:delegate_]){
		[self setUpDialogue: tutoLesson];
		[self setUpAnimator];
	}
	return self;
}

- (void)dealloc{
	free(_columnPnt);
    [_nonoDisplay       release];
	[_allowedActions	release];
	[_stateDialogue		release];
	[_tutoAnimator		release];
	[_tutoDialogue		release];
	[super				dealloc];
}
@end
