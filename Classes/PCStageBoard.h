//
//  PCStageBoard.h
//  picrossGame
//
//  Created by loïc Abadie on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEngineSubscriber.h"
#import "PadButtons.h"
#import "cocos2d.h"


typedef struct {
	float left;
	float right;
	float up;
	float down;
}BoundBoard;

@protocol PCStageBoardDelegate <NSObject>
- (void)tileHasBeenCrossForced:(CGPoint)pnt;
- (BOOL)touchOccuredIntoGrid:(CGPoint)pnt;
- (void)touchSetEnded;
- (buttonType)currentStateTouch;
- (void)changeStateTouch:(buttonType)btnState;
- (void)lockTouchInput;
- (void)unlockTouchInput;
- (void)currentPercentProgress:(float)progress;
- (NSString*)currentMapName;
- (float)timeElapsed;
- (void)gameEnded;
@end

CGPoint multiplyMatrix(CGPoint pnt, float matrice);
CGPoint invertCoordinateHelper(CGPoint pnt);

@interface PCStageBoard : CCNode <PEngineSubscriber>
- (id)initWithStage:(CCTMXLayer*)stage stageLevel:(uint)level delegate:(id<PCStageBoardDelegate>)delegate_ forConstelationName:(NSString*)constelationName;
- (uint)tileForCoordinateTouch:(CGPoint)cartesianXplusYMinus;
- (void)setStateFill:(picrossState)state IntoCoordinate:(CGPoint)cartesianXplusYMinus wasAnError:(BOOL)wasAnError;
- (void)parentHelpDisplay;
- (uint)mapSize;
CGPoint invertCoordinateHelper(CGPoint pnt);
@property(nonatomic, retain) CCTMXLayer*	_currentStage;
@property(nonatomic, assign) id<PCStageBoardDelegate> delegate;
@property(nonatomic, readonly) uint stageLevel;			// the current level
@property(nonatomic, retain, readonly)NSString* mapString;
@end
