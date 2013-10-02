//
//  PCStageBoardHiddenMethod.h
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PCHintBoard.h"
#import "PCMicroMosaic.h"
#import "PCTempMovesEngine.h"
#import "PCCursorView.h"
#import "PCMovesView.h"
#import "PCShowFingerState.h"
#import "PCImpact.h"
#import "PCStageEffectOverlay.h"

typedef enum{
	zoomIn,
	zoomOut
}zoomMode;

typedef enum{
	leftHintLayer	= 10,
	upHintLayer
}stageBoardChildTag;

@interface PCStageBoard()<CCStandardTouchDelegate, PCHintBoardDelegate, TempMovesEngineDelegate>
- (void)redisplayLines:(CGPoint)pnt;
- (void)setupCursor:(CGPoint)pnt tileSize:(uint)tileSize;
- (void)setMask:(int)matriceSize position:(CGPoint)pnt withSkin:(NSString*)constelationName;	
- (void)setupMicroMosaic:(CGSize)mapSize;
- (void)setupMoveEngine;
- (void)setUpBoardDisplay;
- (void)setUpTouchZoomGesture;
- (void)setUpFingerState;
- (void)checkIfBiggerThanScreen:(uint)matriceSize recenter:(CGPoint)mapPnt;
- (void)moveBoard:(CGPoint)pnt repositionBoard:(BOOL)isRepositioning;
- (void)centerize:(float)scale rectifiedPosition:(CGPoint*)rectifiedPosition;
- (void)repositionToPoint:(CGPoint)pnt;
- (void)zoomify:(zoomMode)zoom;
- (void)cancel;
@property(nonatomic, retain) CCTMXLayer*				_maskLayer;
@property(nonatomic, retain) PCHintBoard*				_hintBar;
@property(nonatomic, retain) PCMicroMosaic*				_microMosaik;
@property(nonatomic, retain) PCTempMovesEngine*			_tmpMoveEngine;
@property(nonatomic, retain) CCNode*					_stageDisplay;		// embed all the graphic display
@property(nonatomic, retain) PCCursorView*				_cursor;
@property(nonatomic, retain) PCShowFingerState*			_fingerState;
@property(nonatomic, retain) PCMovesView*				_moveView;
@property(nonatomic, retain) PCImpact*					impactor;			// affiche un impact lors de la selection.
@property(nonatomic, retain) PCStageEffectOverlay*		_effectOverlay;
@property(nonatomic, retain) NSString*					mapString;
@property(nonatomic, assign) UIPinchGestureRecognizer*	zoomInOutGesture;
@property(nonatomic, assign) CGRect						hitMap;				// handle touch collision
@property(nonatomic, assign) CGPoint					currentPosition;	// handle where the cursor is
@property(nonatomic, assign) CGPoint					currentTPoint;		// handle the move touch
@property(nonatomic, assign) BOOL						isBiggerThanScreen;	// check if the board is big enougth
@property(nonatomic, assign) BOOL						isZoomOut;			// check if the board has been zoomed
@property(nonatomic, assign) BOOL						allowTouchInput;	// permet de laisser passer les touches ou non
@property(nonatomic, assign) BOOL						touchHasForcedEnd;
@end

