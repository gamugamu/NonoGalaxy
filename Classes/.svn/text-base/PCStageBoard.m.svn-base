//
//  PCStageBoard.m
//  picrossGame
//
//  Created by loïc Abadie on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCStageBoard.h"
#import "PCStageBoardHiddenMethod.h"
#import "PCStageBoardDecorator.h"
#import "PCGrid.h"
#import "PCPicrossDataBase.h"
#import "PCFilesManager.h"
#import "PCNameFormater.h"
#import "PCPicrossGalaxyMenu.h"
#import "GameConfig.h"
#ifdef USETEMPSKIN
#import "PCSkinTempProvider.h"
#endif

/*	PCStageBoard get concerning about the picross board , the microPicross Board and how handeling the cursor into his frame.
	Public methods let you change the picrossable tiles and let you get informed about the coordinate cursor,
	and the current tileGid (PCStageBoard's handeling the nasty tileGid / picrossState enum convertion).
	Private methods handle about the cursor logic move, and displaying the correct hints into the boards,
	and all the layer tree display logic (picrossTile + maskTile + upBoard + leftBoard).
 */

@implementation PCStageBoard
@synthesize hitMap,
			delegate,
			currentPosition,
			currentTPoint,
			stageLevel,
			isBiggerThanScreen,
			isZoomOut,
			zoomInOutGesture,
			touchHasForcedEnd,
			impactor			= _impactor,
			allowTouchInput		= _allowTouchInput,
			mapString,
			_moveView,
			_fingerState,
			_cursor,
			_maskLayer,
			_microMosaik,
			_hintBar,
			_currentStage,
			_stageDisplay,
			_tmpMoveEngine,
			_effectOverlay;

#define animationZoomOutSpeed	.2f
#define animationZoomInSpeed	.5f
#define animationMoveSpeed		.4f

#pragma mark public
static uint matriceSize = 0;

- (uint)mapSize{
	NSAssert(matriceSize, @"PCStageBoard error, matriceSize must not be null");
	return matriceSize;
}

CGPoint multiplyMatrix(CGPoint pnt, float matrice){
    return (CGPoint){pnt.x * matrice, pnt.y * matrice};
}

CGPoint invertCoordinateHelper(CGPoint pnt){
	int invertedY = abs(pnt.y - (matriceSize - 1));
	return (CGPoint){pnt.x, invertedY};
}
						
- (void)redisplayLines:(CGPoint)pnt{
	[_hintBar reBlackenNumber: pnt];
}

#define totalFillStateEnum 4
// store uncrossed, crossed and filled state (	PICUNCROSSED = 0, PICCROSSED = 1, PICFILLED = 2)
static uint gid[totalFillStateEnum] = {PICUNCROSSED, STATESCROSSEDGID, STATESFILLGID, PICUNCROSSED};
- (uint)tileForCoordinateTouch:(CGPoint)cartesianXplusYMinus{
	int tileGid = [_maskLayer tileGIDAt: cartesianXplusYMinus] - 1;
	
	for (int i = 0; i <= totalFillStateEnum; i++) 
		if(tileGid == gid[i] - 1)
			return i;

	// if it's an unknow state then we make it uncrossed (default value)
	return gid[0];
}


// change the touch current tile display
- (void)setStateFill:(picrossState)state IntoCoordinate:(CGPoint)cartesianXplusYMinus wasAnError:(BOOL)wasAnError{
	uint ctGid = 0;
	
	if(state == PICUNCROSSED || state == PICUNFILLED)
		ctGid =	[PCStageBoardDecorator redoCross: cartesianXplusYMinus];
	else
		ctGid = gid[state];
	
	if(wasAnError)
		[self displayError];
	
	[_impactor makeImpactAtPosition: _tmpMoveEngine.genuineCurrentPosition forState: (wasAnError)? PICERROR : state];
	// mask layer need to redisplay the good one gid.
	[_maskLayer		setTileGID: ctGid at: cartesianXplusYMinus];
	// microMosaik only care of the filled value, so we only need to send it the state var
	[_microMosaik	updateGrid: cartesianXplusYMinus withCrossState: state];
}

- (void)displayError{
	//[_effectOverlay effectYouMadeError: 1];
}

#pragma mark PEngineProtocol delegate

- (void)updatePicrossLeft:(NSDictionary*)picrossableInfoList{
	[_hintBar updatePicrossLeft: picrossableInfoList];

	// now we now hintBoard has the data, we can display the skin properly - Left and up hints
	[PCStageBoardDecorator skinHint: (CCTMXLayer*)[(CCTMXTiledMap*)[_stageDisplay getChildByTag: leftHintLayer] getChildByTag: 0] 
				   withLenghtHelper: [_hintBar getHintFootPrintForType: PICROW] 
						matriceSize: matriceSize
							   type: PICROW];
	
	[PCStageBoardDecorator skinHint: (CCTMXLayer*)[(CCTMXTiledMap*)[_stageDisplay getChildByTag: upHintLayer] getChildByTag: 0] 
				   withLenghtHelper: [_hintBar getHintFootPrintForType: PICCOLUMN] 
						matriceSize: matriceSize
							   type: PICCOLUMN];
}

- (void)updateMatch:(uint)match forMode:(picross2dArray)rowOrColumn currentLine:(uint) line{
	[_hintBar updateMatch:match forBoard:rowOrColumn currentLine: line];
}

- (void)analyseWillStart:(CGPoint)pnt{
	[self redisplayLines: pnt];
}

- (void)currentPercentProgress:(float)progress{
	[delegate currentPercentProgress: progress];
}

- (void)allPicrossAreMatching{
	[self zoomify: zoomOut];
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];

	[delegate gameEnded];
    [self saveStageAccomlished];
}

- (void)saveStageAccomlished{
	levelInfoDB newEntrie = {YES, delegate.timeElapsed, stageLevel};
	[[PCPicrossDataBase sharedPCPicrossDataBase] addNewEntry: &newEntrie forName:[delegate currentMapName]];
    
    NSDictionary* data = [[PCPicrossDataBase sharedPCPicrossDataBase] entriesForConstelation: [delegate currentMapName]];
    [self markConstelationAsCompletedIfNeeded: data];
}

#pragma mark hintBoard delegate

- (void)emptyLineDetected:(picross2dArray)rowOrColumn line:(uint)line{	
	if(rowOrColumn == PICROW)
		for(int i = 0; i < matriceSize; i++){
			currentPosition =  CGPointMake(line, i);
			[self	setStateFill: PICCROSSED IntoCoordinate: currentPosition wasAnError: NO];
			[delegate tileHasBeenCrossForced: currentPosition];
		}
		
	else
		for(int i = 0; i < matriceSize; i++){
			currentPosition = CGPointMake(i, line);
			[self	setStateFill: PICCROSSED IntoCoordinate: currentPosition wasAnError: NO];
			[delegate tileHasBeenCrossForced: currentPosition];
		}
}

#pragma mark input Logic

- (void)registerWithTouchDispatcher{
	 [[CCTouchDispatcher sharedDispatcher] addStandardDelegate: self priority:0];
}

// define the zoom in/out touch
- (void)setUpTouchZoomGesture{	
	zoomInOutGesture						= [[UIPinchGestureRecognizer alloc] initWithTarget: self 
																	  action: @selector(handlePinchGesture:)];
	zoomInOutGesture.cancelsTouchesInView	= NO;
	[[[CCDirector sharedDirector] openGLView].superview addGestureRecognizer: zoomInOutGesture];
	[zoomInOutGesture release];
}

// clean the observers
- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher]				removeDelegate: self];
	[[[CCDirector sharedDirector] openGLView].superview removeGestureRecognizer: zoomInOutGesture];
	[super onExit];
}

#define doubleTouch()\
	CGPoint pnts[2];\
	NSArray* aTouches = [eTouches allObjects];\
	UITouch* tch = nil;\
	for (int i = 0; i < 2; i++) {\
		tch		= [aTouches objectAtIndex: i];\
		pnts[i]	= [tch locationInView: tch.view];\
	};

// move board depending on the touchMoved value. Work only if the board is too big for the screen.
// used when the isBiggerThanScreen is true
static CGPoint hitmapInvert;	// needed when the hitmap move
static BoundBoard boundBoard;	// set the max limit of the board when it move

#define makeCurrentPosition(scale){\
	uint touchX			= (ctp.x -  hitMap.origin.x) / scale;\
	uint touchY			= (ctp.y -  hitMap.origin.y) / scale;\
	currentPosition		= CGPointMake(touchX, touchY);\
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!_allowTouchInput)
		return;
	
	NSSet* eTouches						= [event allTouches];
	uint nTouch							= [eTouches count];
	touchHasForcedEnd					= NO;
	
	if(isZoomOut && nTouch != 1)
		return; // kick out if there's more than one touch in zoomOut mode
	
	if(nTouch != 1)
		[_tmpMoveEngine cancel];
	
	switch (nTouch) {
		case 1:{
			UITouch* singleTouch	= [touches anyObject];
			CGPoint ctp				= [singleTouch locationInView: singleTouch.view];		// current touch point
			currentTPoint			= ctp;

			if(CGRectContainsPoint(hitMap, currentTPoint)){
				if(isZoomOut){
					makeCurrentPosition(TILESIZEDEMI);
					[_cursor cancelTouchPoint];
					[self	zoomify: zoomIn];
				}else{
					makeCurrentPosition(TILESIZE);
					CGPoint lockPnt		= [_tmpMoveEngine positionLocked: currentPosition isOrigin: YES];
					[_cursor		newTouchPointIntoMatrice: invertCoordinateHelper(currentPosition)];
					[_hintBar		newTouchPointIntoMatrice: (lockPnt.x < 0)? currentTPoint : lockPnt];

					if(isBiggerThanScreen)
						[self moveBoard: CGPointZero repositionBoard: NO];
					}
			}
		}break;
			
		case 2:{
			if(isBiggerThanScreen){
				doubleTouch();
				currentTPoint = (CGPoint){(pnts[0].x + pnts[1].x) / 2,  (pnts[0].y + pnts[1].y) / 2};
				[_hintBar		cancelTouchPoint];
				[_cursor		cancelTouchPoint];
				[_fingerState	changeFingerState: fingerMoving];
			}
			[self cancel];

		}break;
			
		case 3:{
            /*
			buttonType switchButton = [delegate currentStateTouch];
			[delegate		changeStateTouch: (++switchButton >= BTNTYPELENGHT)? 0 : switchButton];
			[_fingerState	changeFingerState: fingerSwapping];
             */
		}break;
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(isZoomOut || !_allowTouchInput)
	   return;

	NSSet* eTouches = [event allTouches];
	
	switch ([eTouches count]) {
		case 1:{
			UITouch* singleTouch	= [touches anyObject];
			CGPoint ctp				= [singleTouch locationInView: singleTouch.view];		// current touch point
		
			if(CGRectContainsPoint(hitMap, currentTPoint)){				
				uint touchX			= (ctp.x -  hitMap.origin.x) / TILESIZE;
				uint touchY			= (ctp.y -  hitMap.origin.y) / TILESIZE;

				if((touchX != (uint)currentPosition.x	|| touchY != (uint)currentPosition.y) &&
				   (touchX < matriceSize && touchY < matriceSize)){
					currentPosition		=  CGPointMake(touchX, touchY);
					CGPoint lockPnt		= [_tmpMoveEngine positionLocked: currentPosition isOrigin: NO];
					
					[_cursor		newTouchPointIntoMatrice: invertCoordinateHelper(currentPosition)];
					[_hintBar		newTouchPointIntoMatrice: (lockPnt.x < 0)? currentPosition : lockPnt];
					//[_microMosaik	newTouchPointIntoMatrice: currentPosition];

					if(isBiggerThanScreen)
						[self moveBoard: CGPointZero repositionBoard: NO];
				}
			}
		}break;
			
		case 2:{
			[_cursor	cancelTouchPoint];
			if(isBiggerThanScreen){
				doubleTouch();
				CGPoint currentMPoint       = (CGPoint){(pnts[0].x + pnts[1].x) / 2,  (pnts[0].y + pnts[1].y) / 2};
				CGPoint tmpPnt              = ccpSub(currentMPoint, currentTPoint);
				static CGPoint smoothScroll = {0,0};
        
				// i don't want to see gap, so ignore big gap pnt value
				if(fabsf(smoothScroll.x - tmpPnt.x) + fabsf(smoothScroll.y - tmpPnt.y) < 20){
					[self moveBoard: tmpPnt repositionBoard: YES];
                    smoothScroll = tmpPnt;
                }else
                    smoothScroll = tmpPnt;
				
				currentTPoint			= currentMPoint;
			}
		}break;
	}
}
	 
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(!_allowTouchInput)
		return;
	
	if ([touches count] == [[event allTouches] count] && !touchHasForcedEnd) {
		if(!_tmpMoveEngine.isExecuting && _tmpMoveEngine.isOn){		
			// when tmpMove is executing, all the touch input are locked;
			[delegate lockTouchInput];

			[_tmpMoveEngine executeMove: ^(CGPoint value, BOOL isLast){
				BOOL isTherAnError = [delegate	touchOccuredIntoGrid: value];

				if(isTherAnError){
					[delegate unlockTouchInput];
					[self repositionToPoint: value];
				}
				if(isLast)
					[delegate unlockTouchInput];
				
				return isTherAnError;}];
		}
		
		[_hintBar		touchPointIntoMatriceEnded];
		[_cursor		touchPointIntoMatriceEnded];
		[_fingerState	cancelState];
		[delegate		touchSetEnded];
		
		touchHasForcedEnd = YES;
	}
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	// that should never happen
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)recognizer {
	static float zoomType = 0.f;
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:{
			zoomType = recognizer.scale;
		}break;
			
		case UIGestureRecognizerStateEnded:{
			if(fabsf(recognizer.velocity) > speedPinchTolerance){
				if(fabsf(zoomType - recognizer.scale) > scalePinchTolerance){
					(recognizer.velocity > 0)? NSLog(@"zoom in"): [self zoomify: zoomOut];
				}				
			}
		}break;
	
		default: return;
	}
}

#pragma mark display Logic
#define YSCROLLBORDER TILESIZE

#define repositionBoard(pnt, reposition){\
	CGPoint invNpnt = ccp(hitmapInvert.x + pnt.x,  hitmapInvert.y - pnt.y);\
	CGSize	szNpnt	= CGSizeMake(invNpnt.x, invNpnt.y);\
	if(reposition){\
		self.position	= pnt;\
		hitMap.origin	= invNpnt;\
	}\
	[_hintBar		updateExceedDisplay: szNpnt currentPosition: currentPosition];\
}

#define repositionBoardWithAnimation(pnt, reposition){\
	_allowTouchInput	= NO;\
	CGPoint invNpnt		= ccp(hitmapInvert.x + pnt.x,  hitmapInvert.y - pnt.y);\
	CGSize	szNpnt		= CGSizeMake(invNpnt.x, invNpnt.y);\
	if(reposition){\
		[self runAction: [CCSequence actions: [CCMoveTo actionWithDuration: animationMoveSpeed position: pnt],\
		[CCCallBlockN actionWithBlock: 	[[^(CCNode *n){ _allowTouchInput = YES;} copy] autorelease]], nil]];\
		hitMap.origin	= invNpnt;\
	}\
	[_hintBar		updateExceedDisplay: szNpnt currentPosition: currentPosition];\
}


- (void)moveBoard:(CGPoint)pnt repositionBoard:(BOOL)isRepositioning{
	CGPoint spnt = self.position;
	
	if(pnt.x >= 0)
		pnt.x = (spnt.x + pnt.x < boundBoard.left)? pnt.x : -(spnt.x - boundBoard.left);
	else
		pnt.x = (spnt.x + hitMap.size.width + pnt.x > boundBoard.right)? pnt.x : -(spnt.x + hitMap.size.width - boundBoard.right);
	
	if(pnt.y >= 0)
		pnt.y = (spnt.y - pnt.y > -boundBoard.up)? pnt.y : (spnt.y + boundBoard.up);
	else
		pnt.y =  (spnt.y - hitMap.size.height - pnt.y < -boundBoard.down)? pnt.y : -(hitMap.size.width - boundBoard.down - spnt.y);

	CGPoint npnt	= (CGPoint){(int)(spnt.x + pnt.x), (int)(spnt.y - pnt.y)};
	
	repositionBoard(npnt, isRepositioning);
}

// reposition depending on the coordinate grid. Work only if the board is too big for the screen.
- (void)repositionToPoint:(CGPoint)currentpnt{
	if(!isBiggerThanScreen)
		return;
	
	int repositionx		= IPHONEWIDTHDEMI - currentpnt.x * TILESIZE - hitmapInvert.x;
	int repositiony		= -IPHONEHEIGHTDEMI	+ currentpnt.y * TILESIZE + hitmapInvert.y;
	CGPoint rPnt		= CGPointZero;

	// do a bound check because we don't want the corners on center//
	// perform a left and right check
	rPnt.x = (repositionx < boundBoard.left)?
				(repositionx + hitMap.size.width > boundBoard.right)?	repositionx : boundBoard.right - hitMap.size.width :
																		boundBoard.left;

	// note: we don't perform a up check because the center is beyound
	rPnt.y = (repositiony < hitMap.size.height - boundBoard.down)? repositiony :  hitMap.size.height - boundBoard.down;
	repositionBoardWithAnimation(rPnt, YES);
}

- (void)centerize:(float)scale rectifiedPosition:(CGPoint*)rectifiedPosition{
	scale						= 1 / scale;
	float tileSize				= TILESIZE / scale;
	float mz					= ((matriceSize + 1) / 2) * tileSize;
	CGPoint	mapPnt				= CGPointMake((int)(IPHONEWIDTHDEMI - mz), (int)(IPHONEHEIGHTDEMI - mz - (mz/2) + tileSize/2));
	hitMap						= CGRectMake(mapPnt.x, IPHONEHEIGHT - mapPnt.y -  matriceSize * tileSize, 
											 matriceSize *  tileSize, matriceSize *  tileSize);
	
	if(!rectifiedPosition){
		self.position				= CGPointZero;
		_stageDisplay.position		= mapPnt;
		if(isZoomOut){ 
			[_hintBar realign: currentPosition];
			[_hintBar cancelTouchPoint];
		}
	}else
		*rectifiedPosition = mapPnt;
}

- (void)zoomify:(zoomMode)zoom{
	BOOL	isTmpZoomOut		= (zoom == zoomOut);
			_allowTouchInput	= NO;
	
	if(isZoomOut == isTmpZoomOut || !isBiggerThanScreen)
	return;
	
	isZoomOut				= isTmpZoomOut;
	float scale				= (isZoomOut)? .5 : 1;
	CGPoint scaleRectified	= CGPointZero;
	float animationSpeed	= zoom == zoomIn? animationZoomInSpeed : animationZoomOutSpeed;
	
	[self centerize: scale rectifiedPosition: &scaleRectified];
	[self runAction: [CCMoveTo actionWithDuration: animationSpeed position: CGPointZero]],
	
	[_stageDisplay runAction:	[CCSequence actions:
								[CCSpawn actions:
								[CCScaleTo actionWithDuration: animationSpeed scale: scale],
								[CCMoveTo actionWithDuration: animationSpeed position: scaleRectified], nil],
								[CCCallBlockN actionWithBlock: BCA(^(CCNode *n){
		if(isZoomOut){ 
			[_hintBar realign: currentPosition];
			[_hintBar cancelTouchPoint];
		}
		else 
			[self repositionToPoint: currentPosition];
		
		[_fingerState	cancelState];
		_allowTouchInput = YES;
	})],nil]];
	
}

- (void)checkIfBiggerThanScreen:(uint)matriceSize recenter:(CGPoint)mapPnt{
	isBiggerThanScreen			= (matriceSize > 10);
	
	if(isBiggerThanScreen){
		// 1 center the board and keep the data for when the board will move 
		hitmapInvert	= (CGPoint){mapPnt.x,  IPHONEHEIGHT - hitMap.size.height - mapPnt.y};
		uint  mdemi		= (uint)((matriceSize -1)/2 +1)* TILESIZE;
		boundBoard		= (BoundBoard){	mdemi - hitmapInvert.x + LEFTBORDEROVERLAP, 
										- hitmapInvert.x + RIGHTBORDEROVERLAP,
										mdemi - hitmapInvert.y + UPBORDEROVERLAP,
										-hitmapInvert.y + DOWNBORDEROVERLAP};
		// 2 made a zoom out
		[self zoomify: zoomOut];
	}
}

- (void)cancel{

}

#pragma mark tempMovesEngine

- (void)updateDisplayInLockPosition:(CGPoint)position lastPoint:(CGPoint)lstPnt{
	[_moveView updateDisplay: position lastPoint: lstPnt];
}

- (void)updateDisplay:(CGPoint)position lastPoint:(CGPoint)lstPnt {
	[_moveView updateDisplay: position lastPoint: lstPnt];
}

- (void)updateDone{
	[_moveView updateDone];
}

- (void)tempMoveCanceled{
	[_moveView updateDone];
}

#pragma mark setup

- (void)setUpStage:(CCTMXLayer*)currentStage forConstelationName:(NSString*)mapName{
	matriceSize					= [[currentStage.properties valueForKey: PCMATRIXSIZE] intValue];
	uint tileSize				= TILESIZE;
        
	NSString* skinPath			= [[PCFilesManager sharedPCFileManager] getSkinForMapName: mapName]; // this will be usefull for the mask and hintBoard
    
#ifdef USETEMPSKIN
    // on remplace le skin par le nouveau
    [CCTextureCache purgeSharedTextureCache];
    [PCSkinTempProvider replaceSkinWithTempSkin: skinPath];
    [PCSkinTempProvider replaceIndiceWithTempIndice: [[PCFilesManager sharedPCFileManager] indicePathName: mapName]];
#endif
    
    NSString* skinNumbers       = [[PCFilesManager sharedPCFileManager] getIndiceForMapName: mapName];

    // first create a layer for the stage
	[self setUpBoardDisplay];
	// make it in the center
	[self centerize: 1 rectifiedPosition: nil];

	// then add the specific displays
//	[CCTexture2D setDefaultAlphaPixelFormat: kTexture2DPixelFormat_RGB5A1];		// optimisation
	
	[self setMask: matriceSize position: CGPointZero withSkin: skinPath];
	[self setupHintBoard: CGPointZero
			 matriceSize: matriceSize 
			andStageSize: CGSizeMake(matriceSize * tileSize, matriceSize * tileSize)
                withSkin: skinPath
           andNumberSkin: skinNumbers];
	
	
	[self setupCursor: CGPointZero tileSize: tileSize];
	
	// note: micro mosaic is added on the parent layer
	[self setupMicroMosaic: CGSizeMake(matriceSize, matriceSize)];
	[self set_currentStage: currentStage];
	[self setUpFingerState];
	[self checkIfBiggerThanScreen: matriceSize recenter: _stageDisplay.position];
}

- (void)setUpFingerState{
	//PCShowFingerState* state = [[PCShowFingerState alloc] initFingerState];
	//[self set_fingerState: state];
	//[state release];
}

- (void)setupCursor:(CGPoint)pnt tileSize:(uint)tileSize{
/*	PCCursorView* cursor = [[PCCursorView alloc] initWithFile: CURSORNAME];
	[self set_cursor: cursor];
	[_cursor				setMatrix: CGRectMake(pnt.x , pnt.y, tileSize, tileSize)];
	[_stageDisplay		addChild: _cursor z: 2];
	[cursor				release];
}*/
}

- (void)setMask:(int)matriceSize position:(CGPoint)pnt withSkin:(NSString*)skinName{

	CCTMXTiledMap* mask		= [[CCTMXTiledMap alloc]	initWithTMXFile:	MASKFILE
														imageSource:		DEFAULTSKIN
														replaceWith:		skinName
														resolvedPath:		nil
														andMapSize:			CGSizeMake(matriceSize+1, matriceSize+1)]; // x+1, y+1 because of the borders
	
	mask.position			= (CGPoint){pnt.x, pnt.y - TILESIZE};
	[((CCTMXLayer*)[mask getChildByTag:0]).textureAtlas.texture setAliasTexParameters];	// optimisation
	
	[self					set_maskLayer: (CCTMXLayer* )[mask getChildByTag: 0]];
	[PCStageBoardDecorator	skinMask: _maskLayer forMatriceSize: matriceSize];
	[_stageDisplay			addChild: mask];
	[mask	release];

	// then superpose a grid
	PCGrid* grid		= [[PCGrid alloc] initWithMatrice: matriceSize];
	[_stageDisplay		addChild: grid];
	[grid	release];
}

- (void)setUpBoardDisplay{
	[self set_stageDisplay: [CCNode node]];
	[self addChild: _stageDisplay];
}

- (void)setupHintBoard:(CGPoint)pnt matriceSize:(int)mSize andStageSize:(CGSize)ssize withSkin:(NSString*)skinName andNumberSkin:(NSString*)skinNumbers{
	_hintBar					= [[PCHintBoard alloc] initWithDelegate: self matriceSize: mSize];
    NSDictionary* resolveImages = @{DEFAULTSKIN : skinName, DEFAULTNUMBERS : skinNumbers? skinNumbers : DEFAULTNUMBERS};
	    
    CCTMXTiledMap *upBoard		= [_hintBar createBoardForType: PICROW
                                                imageResolve: resolveImages
                                                resolvePath: nil];

	CCTMXTiledMap *leftBoard	= [_hintBar createBoardForType: PICCOLUMN	
												imageResolve: resolveImages 
												resolvePath: nil];
	
	ccTexParams texParams = { GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE };

	[((CCTMXLayer*)[upBoard getChildByTag: 0]).textureAtlas.texture generateMipmap];
	[((CCTMXLayer*)[upBoard getChildByTag: 0]).textureAtlas.texture setTexParameters: &texParams];	// optimisation
	
	[((CCTMXLayer*)[upBoard getChildByTag: 1]).textureAtlas.texture generateMipmap];
	[((CCTMXLayer*)[upBoard getChildByTag: 1]).textureAtlas.texture setTexParameters: &texParams];	// optimisation

	
	[_stageDisplay addChild: upBoard	z:0 tag: upHintLayer];
	[_stageDisplay addChild: leftBoard	z:0 tag: leftHintLayer];

	upBoard.position			= ccp(pnt.x, pnt.y + ssize.height);
	leftBoard.position			= ccp(-leftBoard.contentSize.width +  pnt.x, pnt.y);
}

- (void)setupMoveEngine{
	PCMovesView* movesView	= [[PCMovesView alloc] init];
	[self set_moveView: movesView];
	_tmpMoveEngine					= [[PCTempMovesEngine alloc] init];
	_tmpMoveEngine.delegate			= self;
	
	[_stageDisplay	addChild: movesView];
	[movesView		release];
}

- (void)setupMicroMosaic:(CGSize)mapSize{
	CCTMXTiledMap* mUpBoard		= [_hintBar createMicroBoardForType: PICROW];
	CCTMXTiledMap* mLeftBoard	= [_hintBar createMicroBoardForType: PICCOLUMN];
	PCMicroMosaic* microMosaik	= [[PCMicroMosaic alloc] initWithGrid: mapSize microLeftBoard: mLeftBoard microUpBoard: mUpBoard];
	[self set_microMosaik: microMosaik];
	[microMosaik release];
}

- (void)setUpImpactor{
	self.impactor = [[PCImpact new] autorelease];
	[_impactor calibrate: _stageDisplay.position];
	[_stageDisplay addChild: _impactor];
}

- (void)setUpEffectOverlay{
	_effectOverlay = [[PCStageEffectOverlay alloc] init];
}

// ask parent to display some element (like micro mosaic and timer)
- (void)parentHelpDisplay{
	_microMosaik.position	= CGPointMake(870, 650);
	[self.parent	addChild: _microMosaik z: 40];
	//[self.parent	addChild: _fingerState];
	[self.parent	addChild: _effectOverlay z: 300 tag: 300];
}

#pragma mark alloc/dealloc

- (id)initWithStage:(CCTMXLayer*)stage stageLevel:(uint)level delegate:(id<PCStageBoardDelegate>)delegate_ forConstelationName:(NSString*)constelationName{
	if((self = [super init])){
		_allowTouchInput	= YES;
		delegate			= delegate_;
		stageLevel			= level;
		self.mapString		= constelationName;
		
		[self setUpStage: stage forConstelationName: constelationName];
		[self setupMoveEngine];
		[self setUpTouchZoomGesture];
		[self setUpImpactor];
		[self setUpEffectOverlay];
		[self registerWithTouchDispatcher];

        ////////
		// ipermet de faire mes test, pour réussir des puzzles sans les faire. A décommenter ensuite.
#if STAGE_UNLOCKED_AFTER_VISIT == 1
		NSDictionary* data				= [[PCPicrossDataBase sharedPCPicrossDataBase] entriesForConstelation: [delegate currentMapName]];
		__block levelInfoDB newEntrie	= {YES, delegate.timeElapsed, stageLevel};
        
		[data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			PCLevelInfo* info = obj;
			if([info.level intValue] == stageLevel){
				newEntrie.isDone		= YES;
				//newEntrie.isDone		= ![info.isDone boolValue];
				newEntrie.timeElapsed	= 1400;
			}
		}];
        
		[[PCPicrossDataBase sharedPCPicrossDataBase] addNewEntry: &newEntrie forName:[delegate currentMapName]];
#endif
	}

	return self;
}

- (void)markConstelationAsCompletedIfNeeded:(NSDictionary*)allStage{
    __block BOOL didAllStageComplete = YES;
    uint totalStage = [[PCFilesManager sharedPCFileManager] getTotalStageForMap: mapString];
    __block uint allStageCompleted = 0;
    
    [allStage enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        PCLevelInfo* info = obj;
        allStageCompleted++;
        
        if(!info.isDone){
            didAllStageComplete = NO;
            *stop               = YES;
        }
    }];
    
    if(allStageCompleted == totalStage){
        if(didAllStageComplete){
            NSUInteger idx              = [PCNameFormater retrieveIdxFromConstellationName: mapString];
            PCConstelationInfo* info    = [[PCPicrossDataBase sharedPCPicrossDataBase] constelationForIdx: idx];
            
            // si le stage n'a pas encore été marqué comme terminé, on le flag
            // et on demande au controlleur de retourner à la map (et afficher
            // l'animation ).
            if(![info.allStagesComplete boolValue]){
                info.allStagesComplete = [NSNumber numberWithBool: YES];
                [PCPicrossGalaxyMenu shoulAnimateContelationCompleted];
            }
        }
    }
}

- (void)dealloc{
	[_impactor		release];
	[_fingerState	release];
	[_cursor		release];
	[_stageDisplay	release];
	[_maskLayer		release];
	[_microMosaik	release];
	[_moveView		release];
	[_currentStage	release];
	[_hintBar		release];
	[_tmpMoveEngine release];
	[super			dealloc];
}
@end
