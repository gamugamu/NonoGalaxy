//
//  PCPicrossGameHiddenMethod.h
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PCStageBoard.h"
#import "PCTimer.h"
#import "PCPercent.h"
#import "PCStageEndedDisplay.h"

@interface PCPicrossGame()<PCStageBoardDelegate>
- (void)setupControlPad;
- (void)setUpTimer;
- (void)setUpExitButton;
- (void)setUpBackgroundWithColorInfo:(NSString*)colorInfo andSubBagroundColor:(NSString*)subBagroundColor;
- (BOOL)fillTile:(CGPoint)position;
- (void)addStageInfoDisplay:(NSString*)mapName currentStage:(uint)stage;
@property(nonatomic, assign) id<PCPicrossGameDelegate>	delegate;
@property(nonatomic, assign) buttonType					buttonStatePressed;
@property(nonatomic, assign) uint						totalErrors;
@property(nonatomic, assign) int						crossOrUncrossState;
@property(nonatomic, retain) NSString*					_nonoName;
@property(nonatomic, retain) CCTMXLayer*				_nonoLayer;
@property(nonatomic, retain) id<PEngine>				_engine;
@property(nonatomic, retain) PCStageBoard*				_stageBoard;
@property(nonatomic, retain) PicrossPad*				_picrossPad;
@property(nonatomic, retain) PCTimer*					_timer;
@property(nonatomic, retain) PCPercent*					_pieChart;
@property(nonatomic, retain) NSString*					_mapName;
@property(nonatomic, retain) PCStageEndedDisplay*       _end;
@property(nonatomic, assign) uint                       currentStageId;
@end