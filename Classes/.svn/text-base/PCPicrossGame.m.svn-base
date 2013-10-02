//
//  HelloWorldLayer.m
//  UsingTiled
//
//  Created by loïc Abadie on 03/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "PCPicrossGame.h"
#import "PCPicrossGameHiddenMethod.h"
#import "PCHintBoard.h"
#import "PCFilesManager.h"
#import "PCGlowingStarsBackground.h"
#import "PCStageEndedDisplay.h"
#import "PCStageJustAchieved.h"
#import "PCStageBackground.h"
#import "PCRequiermentHelper.h"
#import "GCTransition.h"
#import "CCLabelBMFontMultiline.h"
#import "GameConfig.h"
#import "ColoredCircleSprite.h"
#import "GCMusicController.h"
#import "PCSkinTempProvider.h"

/*	PCPicrossGame handle the set of stages (like one picross galaxy), make the glue between the engine and the 
	PCStageBoard. Display controller and handle the game logic (when you make an error or when you finish the game).
	PCPicrossGame tell PCStageBoard which current stage need to be displayed, and control the start and end of the game.
 */

const uint tryBeforeFailed = 10;

@interface PCPicrossGame(){
    uint tries;
}

@end

@implementation PCPicrossGame

@synthesize delegate,
			buttonStatePressed,
			totalErrors,
			crossOrUncrossState,
			_engine,
			_mapName,
			_nonoName,
			_nonoLayer,
			_picrossPad,
			_stageBoard,
			_timer,
			_pieChart,
            _end,
            currentStageId;

- (void)StageWasSelected:(uint)stage forConstelation:(NSString*)constelationName{
	totalErrors					= 0;
    currentStageId              = stage;
	NSDictionary* info			= [[PCFilesManager sharedPCFileManager] getInfoForMapName: constelationName];
    
	[self setUpBackgroundWithColorInfo: [info valueForKey: mapInfoBagroundColor] andSubBagroundColor: [info valueForKey: mapInfoSubBagroundColor]];
	[self set_mapName: constelationName];
	[self setUpTimer];
	[self setupControlPad];
	[self set_nonoLayer: [[PCFilesManager sharedPCFileManager]	getSelectedStage: stage forConstelation: constelationName]];	
	[self set_nonoName:  [(NSDictionary*)_nonoLayer.properties objectForKey: @"nonoName"]];

	_stageBoard					= [[PCStageBoard alloc]	initWithStage: _nonoLayer
															stageLevel: stage
															delegate: self
															forConstelationName: constelationName];

	[self addChild:	_stageBoard];
	[_stageBoard parentHelpDisplay];
	[self addStageInfoDisplay: [info objectForKey: @"constelationName"] currentStage: stage]; //<------
	[_engine setPicrossDelegate: _stageBoard];
	[_engine newStage: [_stageBoard _currentStage]];
	[self setUpExitButton];
	[self setupInfoButton];
    [self setUpDefault];
}

#pragma mark touchLogic

- (void)exitPressed:(CCMenuItem*)menuItem{
    [self exitGame];
}

- (void)infoPressed{
}

- (void)checkAchievementAndSaveIfNeeded{
	if(_stageBoard.mapSize >= 15){
		PCRequiermentHelper* requirmentHelper = [[PCRequiermentHelper alloc] init];
		[requirmentHelper requirmentIsAchieved: REQUIRMENTBIGGERTHAN10];
		[requirmentHelper release];
	}
}

#pragma mark PCStageBoardDelegate

- (void)tileHasBeenCrossForced:(CGPoint)pnt{
	[_engine hasPicrossedTo: pnt forState: PICCROSSED];
}

- (BOOL)touchOccuredIntoGrid:(CGPoint)pnt{
	return [self fillTile: pnt];
}

- (void)touchSetEnded{
	crossOrUncrossState = -1;
}

- (buttonType)currentStateTouch{
	return buttonStatePressed;
}

- (void)changeStateTouch:(buttonType)btnState{
	buttonStatePressed = btnState;
	[_picrossPad changeButtonState: btnState];
}

- (float)timeElapsed{
	return _timer.currentTime;
}

- (NSString*)currentMapName{
	return _mapName;
}

- (void)currentPercentProgress:(float)progress{
	[_pieChart displayPercent: (uint)progress];
}

#pragma mark joyStickDelegate ButtonLogic

- (void)buttonPressed:(buttonType)state {
    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDPOP];
    [[_picrossPad._pad buttonForTag: 0] runAction: [CCSequence actionOne: [CCScaleTo actionWithDuration: .1f scale: 1.1f] two: [CCScaleTo actionWithDuration: .1f scale: 1]]];
	buttonStatePressed = state;
}

- (void)buttonReleashed:(buttonType)state{
}

- (void)lockTouchInput{
	[_picrossPad lockInput];
}

- (void)unlockTouchInput{
	[_picrossPad unlockInput];
}

- (BOOL)fillTile:(CGPoint)position{
	uint currentGid					= [_stageBoard tileForCoordinateTouch: position];
	uint stateGid					= -1;
	BOOL isErrorOccuredWhenFilling	= NO;
	if(currentGid != PICFILLED){
		switch (buttonStatePressed) {
			case FILL:
				if([_engine isPicrossable:position]){							// if we can fill the tile, then
																					// it's ok
					stateGid = PICFILLED;
                    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDSMALLPOP];
                }
				else{
                    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDERROR];

						[_timer addTime: pow(2,totalErrors) * TIMEPENALTY];			// and the fill state is
						if (totalErrors < 3)
                            totalErrors++;							// changed to a PICROSS state
                    
						stateGid					= PICCROSSED;
						isErrorOccuredWhenFilling	= YES;
                    [self failedAndCheckIfGameShouldEnd];
                }
				break;
				
			case CROSS:
                [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDLOWBLOW];
				stateGid = (currentGid == PICCROSSED)? PICUNCROSSED : PICCROSSED;
				if(crossOrUncrossState == -1)
					crossOrUncrossState = stateGid;
				
				stateGid = crossOrUncrossState;
				break;
			
			default:; //NSLog(@"this pic state is not currently used");
		}
		
		[_stageBoard	setStateFill: stateGid		IntoCoordinate: position wasAnError: isErrorOccuredWhenFilling];
		[_engine		hasPicrossedTo: position	forState: stateGid];
	}
	
	return isErrorOccuredWhenFilling;
}

#pragma mark add

- (void)addStageInfoDisplay:(NSString*)mapName currentStage:(uint)stage{
/*	NSString*				stageName	= [NSString stringWithFormat: @"%@\n- Level %u -", mapName, stage];
	CCLabelBMFontMultiline* mapDName	= [CCLabelBMFontMultiline labelWithString: stageName fntFile:@"FntFutura_24.fnt" width: 400 alignment: CenterAlignment];//<---
	mapDName.position					= ccp(900, 712);
	[self addChild: mapDName];*/
}

#pragma mark PCCScene

- (void) onEnterTransitionDidFinish{
	[self makeTreePerfromSelector:@selector(onEnterTransitionDidFinish) withObject:nil];
}

- (void) onExitDidFinish{
	[self makeTreePerfromSelector:@selector(onExitDidFinish) withObject:nil];
}

#pragma mark logic

- (void)failedAndCheckIfGameShouldEnd{
    if(++tries >= tryBeforeFailed)
        [self gameFailed];
}

- (void)gameFailed{
	[_timer stop];
    [self displayEnd];
    [PCStageJustAchieved setStageAccomplished: PCStageJustAchieved_notAchieved];
    
    [[GCMusicController sharedManager] changeAmbience: ambianceNone withFade: YES];
    
    [self performSelector: @selector(playMusicAfterDelay:)
               withObject: [NSNumber numberWithInteger: ambiancePicrossFailed]
               afterDelay: 2];
    
	[self addChild: _end z: 100];
    [_end displayFailedWithNono: _nonoLayer
                        target: self
                      callBack: @selector(exitGame)];
}

- (void)gameEnded{
	[_timer	stop];
    [self displayEnd];
    [self checkAchievementAndSaveIfNeeded];
    
	PCFilesManager*			fileManager			= [PCFilesManager sharedPCFileManager];

	NSString*				stageResolvedName	=  [fileManager getResolvedStageInMap: currentStageId
                                                                      forCurrentLevel: [fileManager idxOfMapTmxName: _stageBoard.mapString]];

    [[GCMusicController sharedManager] changeAmbience: ambianceNone withFade: YES];

    [self performSelector: @selector(playMusicAfterDelay:)
               withObject: [NSNumber numberWithInteger: ambiancePicrossWin]
               afterDelay: 2];

	[PCStageJustAchieved setStageAccomplished: _stageBoard.stageLevel];
	[self addChild: _end z: 100];

	[_end displayEndStageWithNono: _nonoLayer
						withName: _nonoName
			   stageResolvedName: stageResolvedName
					   stageSize: [_stageBoard mapSize]
						  target: self
						callBack: @selector(exitGame)];
}

- (void)playMusicAfterDelay:(NSNumber*)number{
    [[GCMusicController sharedManager] changeAmbience: [number integerValue] withFade: NO];
}

- (void)exitGame{
    [delegate stageWillExit];
    
	[self addChild:
	 [GCTransition transitionWithCallBack:^{
		[self removeAllChildrenWithCleanup: YES];
		[delegate stageExit: _mapName];
	} isReverse: NO] z: 101];
}

- (void)displayEnd{
    CCNode* butonBack = [self getChildByTag: tagBackButton];
    butonBack.visible = NO;
}

#pragma mark setup

- (void)setUpDefault{
    _end = [PCStageEndedDisplay new];
}

- (void)setUpBackgroundWithColorInfo:(NSString*)colorInfo andSubBagroundColor:(NSString*)subBagroundColor{
#if  REMPLACESKINLOCAL == 1
    [PCSkinTempProvider replaceColorWithTempColor: &colorInfo subColor: &subBagroundColor];
#endif
	PCStageBackground* stageBackground = [[[PCStageBackground alloc] initWithHexBackgroundColor: colorInfo andSubHexBagroundColor: subBagroundColor] autorelease];
	[self addChild: stageBackground];
}

- (void)setUpAdditionarryDisplay{
	CCSprite* blackMedal	= [CCSprite spriteWithFile: @"blackMedal.png"];
	blackMedal.position		= ccp(880, 660);
	[self addChild: blackMedal z: 19];
	 /*
	PCPercent* percent = [[PCPercent alloc] initP];
	[self set_pieChart: percent];
	percent.position = ccp(900, 450);
	[self addChild: percent z: 20];
	[percent release];
      */
}

- (void)setupInfoButton{
    /*
	CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite: [CCSprite spriteWithFile: buttonInfo]
														 selectedSprite: nil
																 target: self 
															   selector: @selector(infoPressed)];
	
	CCMenu * myMenu = [CCMenu menuWithItems: menuItem, nil];
	myMenu.position = CGPointMake(150, 150);
	[self addChild: myMenu];
     */
}

- (void)setupControlPad{
	PicrossPad* picrossPad      = [[PicrossPad alloc] initWithDelegate:self];
	picrossPad.position         = ccp(3, -40);
	[self addChild: picrossPad z: 2];
	[self set_picrossPad: picrossPad];
	[picrossPad release];
	[self changeStateTouch: FILL];
}

- (void)setUpTimer{
	_timer			= [[PCTimer labelWithString: @"" fntFile: @"FntSnow_40.fnt"] retain];//<--
    _timer.scale    = .6f;
	_timer.position = CGPointMake(878, 610);
	[self addChild: _timer z: 20];
	[_timer start];
}

static const uint tagBackButton = 15;
- (void)setUpExitButton{
	CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite: [CCSprite spriteWithFile: buttonBack]
														 selectedSprite: nil
																 target: self 
															   selector: @selector(exitPressed:)];
	
	CCMenu * myMenu = [CCMenu menuWithItems: menuItem, nil];
	myMenu.position = CGPointMake(190, 750);
	[self addChild: myMenu z: 0 tag: tagBackButton];
}

#pragma mark alloc/dealloc
- (id)scene{
	CCScene *scene = [CCScene node];
	[scene addChild: self];
	[scene setSceneDelegate: self];
	return scene;
}

- (id)initWithEngine:(id <PEngine>)engine_ andDelegate:(id <PCPicrossGameDelegate>)delegate_{
	if(self =[super init]) {
		delegate				= delegate_;
		crossOrUncrossState		= -1;
		[self setUpAdditionarryDisplay];
		[self set_engine: engine_];
	}
	return self;
}

- (void)dealloc{
	[_nonoName		release];
	[_nonoLayer		release];
	[_engine		release];
	[_mapName		release];
	[_picrossPad	release];
	[_timer			release];
	[_stageBoard	release];
	[_pieChart		release];
    [_end           release];
	[super			dealloc];								// cocos2d will automatically release all the children (Label)
}
@end
