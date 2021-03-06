//
//  PCConstelationMap.m
//  picrossGame
//
//  Created by loïc Abadie on 02/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCConstelationMap.h"
#import "PCConstelationMapEngine.h"
#import "PCConstelar.h"
#import "PCFilesManager.h"
#import "PCPicrossDataBase.h"
#import "PCMrNono.h"
#import "PCMapSSPopBox.h"
#import "PCNameFormater.h"
#import "PCGlowingStarsBackground.h"
#import "PCMicroResumeMapBackground.h"
#import "PCGalaxyReminder.h"
#import "PCAmbiance.h"
#import "PCConstelationMapHelper.h"
#import "GGBasicStruct.h"
#import "GameConfig.h"
#import "PCStageJustAchieved.h"
#import "PCStageBackground.h"
#import "CCFlash.h"
#import "TimeInfo.h"
#import "GGTracks.h"
#import "PCSkinTempProvider.h"
#import <objc/runtime.h>

@interface PCDrawedItinerary : CCNode{
	vertices*		_itinerary;
	CGPoint*		_dottedvertices;
	uint			itineraryLenght;
	uint			lineWidth;
	uint			mapDotSegment;
	color4Gl		color;
}

- (id)initWithItinerary:(vertices*)itinerary_ lenght:(uint)itineraryLenght_ width:(uint)width color:(color4Gl)color mapDotSegment:(uint)dotSegment;
@end

@interface PCConstelationMap ()<PCMrNonoDelegate, GGButonPressedDelegate>
- (void)createConstelation:(NSString*)constelationName;
- (void)addMap:(CCTMXLayer*)stagelayer_ constelationName:(NSString*)constName returnedAccessSet:(NSArray**)raccess returnedInaccessSet:(NSArray**)rinaccess;
- (void)addNewConstelar;
- (void)transformConstelar:(uint)levelId;
- (void)computeTheStageArea;
- (void)displayItinerary:(NSArray**)access forColor:(color4Gl)color withThickness:(uint)thickness;
- (void)findAndDisplayStageEligibleToBePlayed:(NSArray*)accessible;
- (void)setUpMrNono;
- (void)recenterTo:(CGPoint)pnt needSoftTransition:(BOOL)isSoft;
- (void)reDrawStage;
@property(nonatomic, retain)PCConstelationMapEngine*		_mapEngine;
@property(nonatomic, retain)NSString*						_mapName;
@property(nonatomic, retain)CCMenu*							_stageSet;
@property(nonatomic, retain)CCLayer*						_mapDraws;
@property(nonatomic, retain)CCNode*							_bkgMapDrawsLayer;
@property(nonatomic, retain)CCSpriteBatchNode*				_screensStagesBatch;
@property(nonatomic, retain)CCArray*						_unusedConstels;
@property(nonatomic, retain)CCTMXTiledMap*					_stagesSetData;
@property(nonatomic, retain)PCMrNono*						_mrNono;
@property(nonatomic, retain)PCMapSSPopBox*					_dialogBox;
@property(nonatomic, retain)NSMutableSet*					_levelIdByPnt;
@property(nonatomic, assign)stageData*						_stagesData;
@property(nonatomic, assign)PCPicrossDataBase*				dataBaseSGTN;
@property(nonatomic, assign)id <PCConstelationMapDelegate>	delegate;
@property(nonatomic, assign)PCFilesManager*					sharedFileManager;
@property(nonatomic, retain)TimeInfo*                       timeInfo;
@property(nonatomic, assign)uint							lastConstelationPressed;
@property(nonatomic, assign)uint							totalStages;
@property(nonatomic, assign)uint							currentStageSelected;
@property(nonatomic, assign)CGSize							mapSize;
@property(nonatomic, assign)CGPoint							currentTouch;
@property(nonatomic, assign)CGRect							stageArea;
@property(nonatomic, assign)CGRect							snapArea;
@property(nonatomic, assign)CGRect							visibleArea;
@property(nonatomic, assign)BOOL							allowTouchInput;
@property(nonatomic, assign)BOOL							canSwap;
@end

@implementation PCConstelationMap
@synthesize delegate,
			mapSize,
			currentTouch,
			snapArea,
			stageArea,
			totalStages,
			visibleArea,
			currentStageSelected,
			lastConstelationPressed,
			dataBaseSGTN,
			sharedFileManager,
			allowTouchInput,
			canSwap,
            timeInfo = _timeInfo,
			_mrNono,
			_dialogBox,
			_unusedConstels,
			_stagesSetData,
			_mapDraws,
			_bkgMapDrawsLayer,
			_mapEngine,
			_mapName,
			_stageSet,
			_screensStagesBatch,
			_stagesData,
			_levelIdByPnt;


#pragma mark public
- (id)scene{
	CCScene *scene = [CCScene node];
	[scene addChild: self];
	[scene setSceneDelegate:self];
	return scene;
}

#pragma mark private
#pragma mark animation
#define TAG_REMINDER	1
#define Z_MAPSUBDRAWS	9
#define Z_BATCH			10
#define Z_MAPSTAGESET	11
#define Z_BUTTON		12
#define Z_REMINDER		13

- (void)animate{
	CCNode* galaxyReminder  = [self getChildByTag: TAG_REMINDER];
	_mapDraws.visible		= YES;
	_mrNono.visible			= YES;
	galaxyReminder.visible	= YES;
	galaxyReminder.position = ccp(45, 45);
}

#pragma mark logic
- (void)createConstelation:(NSString*)constelationName{
	NSAutoreleasePool* pool				= [[NSAutoreleasePool alloc] init];
	allowTouchInput						= NO;
	CCTMXLayer*		linkerLayer			= nil;
	CCTMXLayer*		stagelayer			= nil;
	NSMutableDictionary* info			= nil;
	// will be used to generate the map and show who's level is accessible and who's not
	NSArray* accessible					= nil;
	NSArray* inaccessible				= nil;
	
	[sharedFileManager getMap: constelationName
				  returnedMap: &stagelayer
		  returnedLeveLLinker: &linkerLayer 
				 returnedSize: &mapSize
			returnedProperies: &info];

	[sharedFileManager getStageDataForMap: constelationName 
							 retainedData: &_stagesData 
								   lenght: &totalStages];
    
#if REMPLACESKINLOCAL == 1
    NSString* color = nil;
    [PCSkinTempProvider replaceColorWithTempColor: nil subColor: &color];
    [self setUpBackGround: color];
#else
	[self setUpBackGround: [info valueForKey: mapInfoSubBagroundColor]];
#endif
    [self set_mapName: constelationName];
	[self addChild: _mapDraws];
	[self set_mapEngine: [PCConstelationMapEngine engineWithConstelationName: constelationName mapSize: mapSize linker: linkerLayer]];
	[self addMap: stagelayer constelationName: constelationName returnedAccessSet: &accessible returnedInaccessSet: &inaccessible];
	[self computeTheStageArea];
	[self findAndDisplayStageEligibleToBePlayed: accessible];
	[self displayItinerary: &accessible		forColor: MAPLINEACCESSCOLOR withThickness: 4];
	[self displayItinerary: &inaccessible	forColor: MAPLINENOACCESSCOLOR withThickness: 2];
	[self animate];
	
	uint lastStageAccomplished = [PCStageJustAchieved lastLevelCompletedInMap: nil];
    
	if(lastStageAccomplished != PCStageJustAchieved_notAchieved){
			[PCConstelationMapHelper animateStageSucceedIfNeedWithStageSet: _stagesData forConstelationName: constelationName lenght: totalStages onCompletion:^{
				allowTouchInput = YES;
			}];
	}else
		allowTouchInput = YES;
    
	[pool release];
}


- (void)displayLastTime{
    //* QnD*/
    if([_mrNono canRepositionOnTheSameMap: _mapName]){
        CGPoint pnt             = _mrNono.currentPosition;
        
    for(int i = 0; i < totalStages; i++){
            if(CGPointEqualToPoint(pnt, _stagesData[i].gridPnt)){
                [_timeInfo displayTime: _stagesData[i].timeElapsed];
                break;
        }
    }
    }
}

#define CONSTELATIONSCAPACITY 12
- (void)addMap:(CCTMXLayer*)stagelayer_ constelationName:(NSString*)constName returnedAccessSet:(NSArray**)raccess returnedInaccessSet:(NSArray**)rinaccess{
	[self set_unusedConstels: [CCArray array]];
	[self set_stageSet: [CCMenu menuWithItems: nil]];
	[self set_stagesSetData: [sharedFileManager stagesSetforMapName: constName]];
	[self set_levelIdByPnt: [NSMutableSet setWithCapacity: totalStages]];
	[PCConstelar resetStatic];
	
	uint capacity					= 0;
	uint stagesDone					= 0;
	_stageSet.position				= CGPointZero;
	NSDictionary* data				= [dataBaseSGTN entriesForConstelation: constName];
	NSMutableSet* removePath		= [NSMutableSet setWithCapacity: totalStages];
	
	for (int j = mapSize.height - 1; j > -1; j--) 
		for (int i = 0; i < mapSize.width; i++){
			uint constGid = [stagelayer_ tileGIDAt:(CGPoint){i, j}];
			switch (constGid) {
				case 0: break;		// the nil case
				case 1:{
					CGPoint startPnt		= (CGPoint){i * MAPWIDTHSEGMENT, MAPHEIGHTSEGMENT * mapSize.height + j * -MAPHEIGHTSEGMENT};
					CGPoint sPnt			= (CGPoint){i, j};
					
					CCSprite* str			= [CCSprite spriteWithSpriteFrameName: stgAnchor];//<---
					str.position			= startPnt;
					             
                    if([_mrNono canRepositionOnTheSameMap: _mapName]){
                        CGPoint pnt             = _mrNono.currentPosition;
                        _mrNono.displayPosition	= (CGPoint){pnt.x * MAPWIDTHSEGMENT - 100, MAPHEIGHTSEGMENT * mapSize.height + pnt.y * -MAPHEIGHTSEGMENT};
                        
                                         }else{
                        _mrNono.displayPosition	= (CGPoint){startPnt.x - 100, startPnt.y};
                        _mrNono.currentPosition = sPnt;
                    }
        
					[_mapDraws addChild: _mrNono z: 100];
					[_screensStagesBatch addChild: str];//<---
					
					[_levelIdByPnt addObject: [NSValue valueWithCGPoint: sPnt]];					
				}break;		// the starter case
				
				default:{	uint actualStage			= constGid - 1;				// because the first stage equal to 2 (1 is for starter)
							uint dataP					= actualStage - 1;			// stage 1 is in 0 array, 2 in 1, etc...
							CGPoint stagePos			= (CGPoint){i * MAPWIDTHSEGMENT + stgAnchorSize, MAPHEIGHTSEGMENT * mapSize.height + j * -MAPHEIGHTSEGMENT +  stgAnchorSize};
							CGRect boundBox				= CGRectMake(stagePos.x, stagePos.y, 10, 10); //<---
							BOOL isVisible				= CGRectContainsRect(visibleArea, boundBox);
							PCLevelInfo* stageInfoDb	= [data objectForKey: [NSNumber numberWithUnsignedInteger: actualStage]];
							CGPoint pnt					= (CGPoint){i, j};
							BOOL stageIsDOne			= [[stageInfoDb isDone] boolValue];
							// here we complete the data already filled by PCFileManager
							_stagesData[dataP].level				= actualStage;  
							_stagesData[dataP].pxBox				= boundBox;
							_stagesData[dataP].isIn					= isVisible;
							_stagesData[dataP].pointer				= nil;
							_stagesData[dataP].isDone				= stageIsDOne;
							_stagesData[dataP].timeElapsed			= [[stageInfoDb timeElapsed] integerValue];
							_stagesData[dataP].gridPnt				= pnt;
							_stagesData[dataP].urlDisplayStageDone	= [[sharedFileManager getResolvedStageInMap: actualStage forCurrentLevel: [sharedFileManager idxOfMapTmxName: constName]] retain];

							// don't forget to list the stage by their position
							if(!stageIsDOne)
								[removePath addObject: [NSValue valueWithCGPoint: pnt]];
							else{
								[_levelIdByPnt addObject: [NSValue valueWithCGPoint: pnt]];
								stagesDone++;
							}
					
							if(capacity < CONSTELATIONSCAPACITY){
								[self addNewConstelar];
								capacity++;
							}
						}break;
			}
		}
	
	[_mapEngine pathfindAccessibleNodes: _levelIdByPnt inaccessible: removePath returnedAccessSet: raccess returnedInaccessSet: rinaccess];
	// will be used when generating the pathfinder of the level accessible
	[_mapEngine filterPathfinder: removePath];//<-----$$$$ plausible optimisation. Maybe pathfindAccessibleNodes can be used instead

#if defined (PCDEBUG_CONSTELATIONMAP)
	for (int i = 0 ; i < totalStages + 1; i++){
		NSAssert(_stagesData[i].level == (i + 1), @"[PCConstelationMap Error]: Your stageSet.tmx derived from %@ has more or less stage than needed", _mapName);
	}
#endif
	
	// check who's visible and add them to the map
	for (int i = 0; i < totalStages + 1; i++)
		if(_stagesData[i].isIn)
			[self transformConstelar: i];
		
	[_mapDraws addChild: _stageSet z: Z_MAPSTAGESET];
	PCGalaxyReminder* reminder = (PCGalaxyReminder*)[self getChildByTag: TAG_REMINDER];
	[reminder updatecompleted: stagesDone forTotal: totalStages + 1];
}

- (void)popConstelar:(PCConstelar*)constelation{
	[_unusedConstels addObject: constelation];
	[constelation unDrawStage: _stageSet];
}

- (void)addNewConstelar{
	PCConstelar* constelation	= [PCConstelar constelar: _screensStagesBatch withBackground: _bkgMapDrawsLayer];
	CCMenuItemSprite* item		= [CCMenuItemSprite itemFromNormalSprite: constelation
														  selectedSprite: constelation
																  target: self 
																selector: @selector(constPressed:)];
	constelation._item          = item;
	[_stageSet			addChild: item];
	[_unusedConstels	addObject: constelation];
}

- (void)transformConstelar:(uint)levelId{
	if([_unusedConstels count]){
		PCConstelar* constelation		= [_unusedConstels	objectAtIndex: 0];
		CCTMXLayer* stageDisplay		= [sharedFileManager getSelectedStage: _stagesData[levelId].level forConstelationMap: _stagesSetData];
		_stagesData[levelId].pointer	= constelation;
        
		[constelation		drawStage: stageDisplay stageData: _stagesData[levelId] menu: _stageSet];
        [_unusedConstels	removeObject: constelation];
	}
	else{
		[self addNewConstelar];
		[self transformConstelar: levelId];
	}
}

#define computingItinary(){\
\
	/* y value inversed (openGl / iphone)*/\
	for (int i = 0; i < itineraryLenght; i++){\
		CGPoint st				= itinerary[i].startPnt;\
		CGPoint ed				= itinerary[i].endPnt;\
		itinerary[i].startPnt	= (CGPoint){st.x * MAPWIDTHSEGMENT, (mapSize.height - st.y) * MAPHEIGHTSEGMENT};\
		itinerary[i].endPnt		= (CGPoint){ed.x * MAPWIDTHSEGMENT, (mapSize.height - ed.y) * MAPHEIGHTSEGMENT};\
	\
		if(itinerary[i].startPnt.x < rect.origin.x)\
			rect.origin.x			= itinerary[i].startPnt.x;\
	\
		if(itinerary[i].endPnt.x > rect.size.width)\
			rect.size.width			= itinerary[i].endPnt.x;\
	\
		if(itinerary[i].endPnt.y < rect.origin.y)\
			rect.origin.y			= itinerary[i].endPnt.y;\
	\
		if(itinerary[i].startPnt.y > rect.size.height)\
			rect.size.height		= itinerary[i].startPnt.y;\
\
	}\
}\

- (void)computeTheStageArea{
	vertices* itinerary		= nil;
	uint itineraryLenght	= 0;
	CGRect rect				= CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
	[_mapEngine computeAllTheItinerary:  &itinerary verticesLenght: &itineraryLenght mapDotSegment: MAPDOTTSEGMENT];
	computingItinary();

	rect.size.width			= rect.size.width - rect.origin.x;
	rect.size.height		= rect.size.height - rect.origin.y;

	stageArea				= rect;
	CGRect rectTempResize	= stageArea;

	// on fait d'abord une première union afin de bien placer le stage par rapport au snap area
	stageArea			= CGRectUnion(stageArea, snapArea);
	snapArea			= CGRectIntersection(snapArea, stageArea);
	
	// si le stage est suffisament petit alors le stage = snap. Donc pas de scrolling sur le stage.
	if(rectTempResize.size.width <= MAPSIZETOOSMALL_WIDTH_DONTGRAP && rectTempResize.size.height <= MAPSIZETOOSMALL_HEITH_DONTGRAP){
		// permet de trouver le point le plus à gauche, le plus bas. Avec ces infos on pourra recenter correctement _mapDraws si besoin est
		// compareSmallestCorner() me permet de trouver le point le plus en bas à gauche. Une fois ces informations, je peux recentrer le stage
		CGPoint lowestCorner = CGPointMake(MAXFLOAT, MAXFLOAT);
		int i;
#define compareSmallestCorner(point, pointToCompare)\
		point.x = (lowestCorner.x < pointToCompare.x)? point.x : pointToCompare.x;\
		point.y = (lowestCorner.y < pointToCompare.y)? point.y : pointToCompare.y;

		for (i = 0; i < itineraryLenght; i++) {
			compareSmallestCorner(lowestCorner, itinerary[i].startPnt);
			compareSmallestCorner(lowestCorner, itinerary[i].endPnt);
		}
#undef compareSmallestCorner
		
		stageArea				= rectTempResize;
		_mapDraws.position		= CGPointMake(IPHONEWIDTHDEMI - stageArea.size.width / 2 - lowestCorner.x, IPHONEHEIGHTDEMI - stageArea.size.height / 2 - lowestCorner.y);
		snapArea				= stageArea;
		snapArea.origin			= CGRectOffset(stageArea,_mapDraws.position.x,_mapDraws.position.y).origin;
		
	}else		
		[self recenterTo: _mrNono.currentPosition needSoftTransition: NO];
}

- (void)displayItinerary:(NSArray**)access forColor:(color4Gl)color withThickness:(uint)thickness{
	if(![*access count])
		return;
	
	vertices* itinerary		= nil;
	uint itineraryLenght	= 0;
	CGRect rect				= CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    
	[_mapEngine computeItinerary: &itinerary verticesLenght: &itineraryLenght mapDotSegment: MAPDOTTSEGMENT forPath: *access];
	computingItinary();

	// if there's no acual display, don't display
	if(!itineraryLenght)
        return;
	
	PCDrawedItinerary* drawedItinerary = [[PCDrawedItinerary alloc] initWithItinerary: itinerary 
																			   lenght: itineraryLenght
																				width: thickness
																				color: color
																		mapDotSegment: MAPDOTTSEGMENT];
	drawedItinerary.opacity = 10;

	[_mapDraws addChild: drawedItinerary];
	[drawedItinerary release];
}

// permet de trouver quels stages n'ont pas encore réussi, mais peuvent être jouable.
// Ici ça sert à réajuster l'apparence des nouveaux stages. 
- (void)findAndDisplayStageEligibleToBePlayed:(NSArray*)accessible{
	for (int i = 0; i <= totalStages; i++) {
		_stagesData[i].isEligible = NO;
		
		if(!_stagesData[i].isDone)
			for (PCNodes* node in accessible)
				if(CGPointEqualToPoint(_stagesData[i].gridPnt, node.pnt)){
					[_stagesData[i].pointer makeEligible: &_stagesData[i]];
					break;
				}
	}
}

// jaune, zone visible
// rouge, zone snap
// vert, zone stage
// bleu ciel, intersection de nap et stage area
#if (PCDEBUG_CONSTELATIONMAP)
- (void)draw{
	glColor4ub(255, 0, 0, 255);
	glLineWidth(1);
	
	float vh = snapArea.size.height + snapArea.origin.y;
	float vw = snapArea.size.width + snapArea.origin.x;

	CGPoint vertices[] = {	ccp(snapArea.origin.x, snapArea.origin.y), 
							ccp(snapArea.origin.x , vh), 
							ccp(vw, vh), 
							ccp(vw, snapArea.origin.y)};

	ccDrawPoly( vertices, 4, YES);
	
	glColor4ub(0, 255, 0, 255);
	CGRect v2rect	= CGRectOffset(stageArea, _mapDraws.position.x, _mapDraws.position.y);
	float v2h		= v2rect.size.height + v2rect.origin.y;
	float v2w		= v2rect.size.width + v2rect.origin.x;

	CGPoint vertices2[] = { ccp(v2rect.origin.x, v2rect.origin.y), 
							ccp(v2rect.origin.x, v2h), 
							ccp(v2w, v2h), 
							ccp(v2w, v2rect.origin.y)};
	
	ccDrawPoly( vertices2, 4, YES);
	
	glColor4ub(0, 255, 255, 255);
	CGRect rect = CGRectIntersection(CGRectOffset (stageArea,_mapDraws.position.x,_mapDraws.position.y), snapArea);
	float v3h		= rect.size.height + rect.origin.y;
	float v3w		= rect.size.width + rect.origin.x;

	CGPoint vertices3[] = {	ccp(rect.origin.x, rect.origin.y), 
							ccp(rect.origin.x , v3h), 
							ccp(v3w, v3h), 
							ccp(v3w, rect.origin.y)};
	ccDrawPoly( vertices3, 4, YES);
	
	glColor4ub(255, 255, 0, 255);
	float v4h		= visibleArea.size.height + visibleArea.origin.y;
	float v4w		= visibleArea.size.width + visibleArea.origin.x;

	CGPoint vertices4[] = {	ccp(visibleArea.origin.x, visibleArea.origin.y), 
		ccp(visibleArea.origin.x , v4h), 
		ccp(v4w, v4h), 
		ccp(v4w, visibleArea.origin.y)};
	
	ccDrawPoly( vertices4, 4, YES);
}
#endif

- (BOOL)moveMrNono:(uint)dataP lenght:(BOOL*)didSelectedCurrent{
	if(_mrNono.isMoving)
		return NO;
	
	CGPoint* movePath		= nil;
	uint lenght				= 0;
	BOOL isMrNonoCanMove	= NO;
	
	[_mapEngine pathfinder:_mrNono.currentPosition  endPoint: _stagesData[dataP].gridPnt returnedPath: &movePath length: &lenght];
	*didSelectedCurrent = CGPointEqualToPoint(_mrNono.currentPosition, _stagesData[dataP].gridPnt);
    
	// check if there is not a direct stageNotDone move to stageNotDoneMove
	isMrNonoCanMove |= [_levelIdByPnt containsObject: [NSValue valueWithCGPoint: _mrNono.currentPosition]] && lenght;
	
	for (int i = 0; i < lenght; i++) {
			if([_levelIdByPnt containsObject: [NSValue valueWithCGPoint: movePath[i]]]){
				isMrNonoCanMove |= YES;
				break;
			}
		}
	
	if(isMrNonoCanMove)
		[_mrNono moveToPoints: movePath lenght: lenght matrice:(CGSize){MAPWIDTHSEGMENT, MAPHEIGHTSEGMENT} inverseY: mapSize.height];
	
	return isMrNonoCanMove;
}

#pragma mark logicButton
- (void)constPressed:(CCMenuItem*)constelation{	
	if(_mrNono.isMoving || !allowTouchInput)
		return;
		
	if(lastConstelationPressed)
		[_stagesData[lastConstelationPressed - 1].pointer setHilighted: NO];
	
	currentStageSelected	= constelation.tag;
	lastConstelationPressed = _stagesData[currentStageSelected - 1].level;
	PCConstelar* constelar	= _stagesData[currentStageSelected - 1].pointer;

	[constelar setHilighted: YES forLevel: _stagesData[currentStageSelected - 1].level];
	[constelar constelarTouched];
	
    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDLOWBLOW];

	// si nono n'a pas bougé, alors on remet le dialogue
    BOOL didSelectedCurrent = 0;
	if(![self moveMrNono: currentStageSelected - 1 lenght: &didSelectedCurrent]){
         /* on a pas déplacer Nono, et on a selectionner la cellule à côté de nono */
        if(didSelectedCurrent){
            _dialogBox.position = ccpAdd(ccp(-70, 110), ccpAdd(_mrNono.displayPosition, _mapDraws.position));
            [_dialogBox popInBox];
        }
    }

	[self recenterTo: _stagesData[currentStageSelected - 1].gridPnt needSoftTransition: YES];
}

- (void)buttonHasBeenPressed:(id)sender{
	[delegate stageWasSelected: currentStageSelected forConstelation: _mapName];
}

- (void)backPressed{
    [delegate goBackFromConstelationPressed];
}

#pragma mark setup
- (void)loadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: levelMapPlist];
	[self set_screensStagesBatch: [CCSpriteBatchNode batchNodeWithFile: levelMapFile]];
	[_mapDraws addChild: _screensStagesBatch z: Z_BATCH];
}

-(void)unloadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: levelMapPlist];
}

#pragma mark register / touch input
static CGPoint lastPosition;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	NSSet* eTouches = [event allTouches];
	switch ([eTouches count]) {
		case 1:	{
			UITouch* singleTouch	= [eTouches anyObject];
			currentTouch			= [singleTouch locationInView: singleTouch.view];
			lastPosition			= _mapDraws.position;
			[_dialogBox popOutBox];
			return YES;
		}
		default:	return NO;
	}
}

- (void)recenterTo:(CGPoint)pnt needSoftTransition:(BOOL)isSoft{
	if(canSwap){
		CGPoint mvp			= (CGPoint){ -pnt.x * MAPWIDTHSEGMENT + IPHONEWIDTHDEMI,( pnt.y - mapSize.height) * MAPHEIGHTSEGMENT + IPHONEHEIGHTDEMI};
		CGRect moveRect		= CGRectOffset(stageArea, mvp.x, mvp.y);
		CGRect interscet	= CGRectIntersection(moveRect, snapArea);
		CGSize gap			= (CGSize){snapArea.size.width - interscet.size.width, snapArea.size.height - interscet.size.height};
		CGPoint isOverlap	= (CGPoint){snapArea.origin.x -  interscet.origin.x, snapArea.origin.y -  interscet.origin.y};
		gap					= (CGSize){(isOverlap.x)? -gap.width : gap.width, (isOverlap.y)? -gap.height : gap.height};
		
		if(isSoft){
            __block BOOL shouldDisplay = NO;
            
            if(_dialogBox.visible){
                _dialogBox.visible  = NO;
                shouldDisplay       = YES;
            }
			[_mapDraws	runAction: [CCSequence actions: [CCMoveTo actionWithDuration: .3f position: (CGPoint){mvp.x + gap.width, mvp.y + gap.height}],
									[CCCallBlockN actionWithBlock: BCA(^(CCNode *n){
                
            if(shouldDisplay){
                _dialogBox.position = ccpAdd(ccp(-70, 110), ccpAdd(_mrNono.displayPosition, _mapDraws.position));
                _dialogBox.visible = YES;
            }
            [self unschedule: @selector(reDrawStage)]; [self reDrawStage];})], nil]];
			[self schedule: @selector(reDrawStage) interval: 0.1f];
		}
		else{
			_mapDraws.position = (CGPoint){mvp.x + gap.width, mvp.y + gap.height};
			[self reDrawStage];
		}
	}
}

- (void)reDrawStage{
	for(int i = 0; i < totalStages + 1; i++){
		BOOL isOnScreenRect = CGRectContainsRect(visibleArea, (CGRectOffset(_stagesData[i].pxBox, _mapDraws.position.x, _mapDraws.position.y)));
		
		if(isOnScreenRect != _stagesData[i].isIn){
			_stagesData[i].isIn = !_stagesData[i].isIn;
			(!_stagesData[i].isIn)? [self popConstelar: _stagesData[i].pointer] : [self transformConstelar: i];
		}
	}
}

- (void)onEnter{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: pctouchConstMap swallowsTouches: NO];
	[super onEnter];
}

- (void)onExit{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
	[self	unloadTexture];
	[super	onExit];
}

#pragma mark delegateMethode
- (void)mrNonoEndedMove:(BOOL)didMove{
	_dialogBox.position = ccpAdd(ccp(-70, 110), ccpAdd(_mrNono.displayPosition, _mapDraws.position));
    if(didMove){
        [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDNONOMOVE];
        [_dialogBox popInBox];
	}
   
    [_stagesData[currentStageSelected - 1].pointer setHilighted: NO forLevel: _stagesData[currentStageSelected - 1].level];
    
    [_timeInfo displayTime: _stagesData[currentStageSelected - 1].timeElapsed];
}

#pragma mark additional setUp
- (void)addGalaxyReminder:(NSString*)galaxyName{
	NSString* displayFile		= [[PCFilesManager sharedPCFileManager] getDisplayImageforMapName: galaxyName];
	PCGalaxyReminder* reminder	= [[PCGalaxyReminder alloc] initWithDisplay: displayFile 
															  andGalaxyName: galaxyName];
	reminder.visible			= NO;
	[self addChild: reminder z: Z_REMINDER tag: TAG_REMINDER];
	[reminder release];
}

#pragma mark setUp
- (void)setUpMrNono{
	_mrNono			= [[PCMrNono alloc] initWithDelegate: self appearance: nonoFloating bubbleAppearance: messageWithConstelation];
	_mrNono.visible	= NO;
}

- (void)setUpDialogBox{
	_dialogBox			= [[PCMapSSPopBox alloc] initWithDelegate: self];	
	[self addChild: _dialogBox z: 50];
}

- (void)setUpBackGround:(NSString*)bagroundColor{
#if (PCDEBUG_CONSTELATIONMAP)
	return;
#endif

	ccColor4B	color		= bagroundColor? [PCStageBackground convertColorStringToColorGlib: bagroundColor] : ccc4(0, 26, 48, 255);
	CCLayer*	supColorBkg	= [CCColorLayer	layerWithColor: color];

	PCGlowingStarsBackground* bkg	= [[PCGlowingStarsBackground alloc] init];
	[self addChild: supColorBkg];
	[self addChild: bkg];
	[bkg release];
}

- (void)setUpBackButton{
	CCSprite* back = [CCSprite spriteWithFile: @"bckBtn.png"];
	CCMenuItemSprite* btn = [CCMenuItemSprite itemFromNormalSprite: back
													selectedSprite: back
															target: self
														  selector: @selector(backPressed)];
	btn.position = CGPointMake(-330, 330);
	CCMenu* menBtn = [CCMenu menuWithItems: btn, nil];
	[self addChild: menBtn z: Z_BUTTON];
}

- (void)setUpMapDraws{
	[self set_bkgMapDrawsLayer: [CCNode node]];
	[self set_mapDraws: [CCNode node]];
	[_mapDraws addChild: _bkgMapDrawsLayer z: Z_MAPSUBDRAWS];
	_mapDraws.visible = NO;
}

- (void)setUpTimeInfo{
    _timeInfo = [TimeInfo new];
    _timeInfo.position = (CGPoint){920, 70};
    [self addChild: _timeInfo];
    [self displayLastTime];
}

#pragma mark alloc/dealloc
- (id)initWithDelegate:(id <PCConstelationMapDelegate>)delegate_ andConstelationName:(NSString*)mapName{
	if(self = [super init]){
		snapArea			= CGRectMake(290, 240, 450, 220);
		visibleArea			= CGRectMake(-25, -25, 1174, 900);
		delegate			= delegate_;
		dataBaseSGTN		= [PCPicrossDataBase sharedPCPicrossDataBase];
		sharedFileManager	= [PCFilesManager sharedPCFileManager];
		canSwap				= YES;
		[self setUpMapDraws];
		[self loadTexture];
		[self setUpMrNono];
		[self setUpBackButton];
		[self setUpDialogBox];
		[self addGalaxyReminder: mapName];
		[self createConstelation: mapName];
        [self setUpTimeInfo];
        [GGTracks trackCurrent: GAMapTracks];
	}
	return self;
}

- (void)dealloc{
    for(int i = 0; i < totalStages; i++)
        [_stagesData[i].urlDisplayStageDone release];
	free(_stagesData);
    
    [_timeInfo              release];
	[_dialogBox				release];
	[_mrNono				release];
	[_stagesSetData			release];
	[_unusedConstels		release];
	[_mapName				release];
	[_screensStagesBatch	release];
	[_mapEngine				release];
	[_stageSet				release];
	[_bkgMapDrawsLayer		release];
	[_mapDraws				release];
	[_levelIdByPnt			release];
	[super					dealloc];
}
@end

// ************************************ PCMicroConstelationMap ************************************************** //
#import "PCRequiermentHelper.h"

@interface PCMicroConstelationMap(){
	BOOL	didNeedSuccessRequirement;
	PCRequiermentHelper* _requirment;
}

- (void)getConstelationMap:(NSUInteger)idx;
- (void)addMap:(CCTMXLayer*)mapLayer levelsAccomplished:(lvlDone_lvlTotal*)accomplished;
- (void)addItineraryitinerary:(vertices*)itinerary verticesLenght:(uint)itineraryLenght;
- (void)popDisplayBoard;
@property(nonatomic, retain)PCConstelationMapEngine*	_mapEngine;
@property(nonatomic, retain)CCSpriteBatchNode*			_batch;
@property(nonatomic, retain)PCMicroResumeMapBackground*	_microStageDisplay;
@property(nonatomic, retain)CCMenuItem*					_buttonList;
@property(nonatomic, retain)CCLayer*                    completionMedal;
@property(nonatomic, retain)NSString*					_currentConstelationName;
@property(nonatomic, retain)NSString*					_inAppid;
@property(nonatomic, retain)NSString*					_mapMessage;
@property(nonatomic, retain)NSSet*						_mapsPaid;
@property(nonatomic, assign)PCPicrossDataBase*			dataBaseSGTN;
@property(nonatomic, assign)BOOL						isDisplaying;
@property(nonatomic, assign)CGSize						mapSize;
@property(nonatomic, assign)CGRect						stageArea;
@property(nonatomic, assign)id<GGButonPressedDelegate>	delegate;
@end

@implementation PCMicroConstelationMap
@synthesize _inAppid,
			_batch,
			_mapsPaid,
			_mapEngine,
			_buttonList,
			_microStageDisplay,
			_currentConstelationName,
			_mapMessage,
            completionMedal = _completionMedal,
			hasUnlockedMap,
			dataBaseSGTN,
			stageArea,
			mapSize,
			isDisplaying,
			delegate;

#pragma mark public
#define Btn_GO_TAG		300
#define Btn_UNLOCK_TAG	301
#define Btn_LOCKED_TAG	302

NSString * language;
+ (void)initialize{
    language = [[[NSLocale preferredLanguages] objectAtIndex:0] retain];
}

- (void)displayBoard:(NSUInteger)idx{
	NSAssert(!isDisplaying, @"PCMicroConstelationMap is already displaying a map, please undisplay first");
	isDisplaying	= YES;
	[self popDisplayBoard];
	[self getConstelationMap: idx];
}

- (void)undisplayBoard{
	[self stopAllActions];
	isDisplaying = NO;
	self.visible = NO;
}

- (void)reloadData{
	self._mapsPaid	= [dataBaseSGTN mapPaid];
}

#pragma mark - getter / setter

- (BOOL)hasUnlockedMap{
	return hasUnlockedMap;
}

- (BOOL)didNeedRequirement{
    return didNeedSuccessRequirement;
}

#pragma mark button

- (void)goPressed{
    if([delegate didMapShouldStay])
        return;
    
	[self stopAllActions];
	self.visible	= NO;
        
	if(isDisplaying){
		[delegate buttonHasBeenPressed: self];
		isDisplaying = NO;
	}
}

#pragma mark animation

- (void)popDisplayBoard{
	self.visible	= YES;
	self.opacity	= 0;
	self.position	= ccp(50, 0);
	[self runAction: [CCSpawn actions:	[CCFadeIn actionWithDuration: .3f], 
										[CCEaseBackInOut actionWithAction: [CCMoveTo actionWithDuration:.5f position: CGPointZero]],
										 nil]];
}

#pragma mark private

- (void)getConstelationMap:(NSUInteger)idx{
	CCTMXLayer*				linkerLayer					= nil;
	CCTMXLayer*				mapLayer					= nil;
	vertices*				itinerary					= nil;
	NSMutableDictionary*	info						= nil;
	uint					itineraryLenght				= 0;
	idx													= (!idx)? 1 : idx;
	NSString*				constelationName			= nil;
	
	didNeedSuccessRequirement	= NO;
	
	[[PCFilesManager sharedPCFileManager]			getMapFromIdx: idx
													 returnedName: &constelationName
											 returnedConstelation: &mapLayer
											  returnedLeveLLinker: &linkerLayer
													 returnedSize: &mapSize
												returnedProperies: &info];
		
	[self set_currentConstelationName: constelationName];
    [self displayStageCompleted: idx];
    
	// check if the map has already been paid, if no, ask you can buy it.
#if MAP_NO_LOCKED == 0
	self._inAppid			= [info objectForKey: @"inAppName"]; //<--------
	BOOL hasBeenAlreadyPaid = NO;
	
	// si il y a un _inAppid, alors ça veut dire que la map est payante.
	// Le contrôle suivant teste si la map a déjà été payé ou non.  
	if([_inAppid length]){
		hasBeenAlreadyPaid = [_mapsPaid containsObject: _inAppid];
		// display differently if the game has been paid or not
		if (hasBeenAlreadyPaid){
			hasUnlockedMap = YES;
			[self set_mapMessage: NSLocalizedString(@"Nono_mapUnlocked", nil)];
		}
		else{
			hasUnlockedMap = NO;
			[self set_mapMessage: NSLocalizedString(@"Nono_askToBuy", nil) ];
		}
	}
	// une fois la priorité faite sur la détèction d'une map payante où pas, on
	// teste si il y à d'autre raison qui pourrait bloquer l'accès de la map.
	else{
		hasUnlockedMap					= YES;
		BOOL needDisplayLock			= NO;
		int i							=	0;
		NSString* messageForRequirment	= nil;
		NSString* valueForKeyRequirment = [info valueForKey: [NSString stringWithFormat:@"%@%u", REQUIRMENTKEY, i]];
		
		while (valueForKeyRequirment){
			// si on a pas réussi un requirment, alors on pas de la boucle; dans le cas contraire,
			// on itere jusqu'à ce qu'on tombes sur un requirments non fait ou pas. Dans le cas contraire, 
			// c'est que tout les requirments sont fait et donc la carte est disponible.
			if(![_requirment didSucceedRequirment: valueForKeyRequirment]){
				needDisplayLock			= YES;
				messageForRequirment	= [_requirment messageForRequirment: valueForKeyRequirment];
				break;
			}
			
			valueForKeyRequirment = [info valueForKey: [NSString stringWithFormat:@"%@%u", REQUIRMENTKEY, i++]];
		}
							 
		if(needDisplayLock){
			didNeedSuccessRequirement = YES;
			[self set_mapMessage: messageForRequirment];
		}
		else{
#endif
            if([language isEqualToString: @"fr"]){
                [self set_mapMessage: [info valueForKey: mapTmxCommentfr]];
            }
            else
                [self set_mapMessage: [info valueForKey: mapTmxCommenten]];
#if MAP_NO_LOCKED == 0
		}
	}
#endif
	
	[_mapEngine computeMutableItinerary: linkerLayer
								mapSize: mapSize
							  itinerary: &itinerary 
						 verticesLenght: &itineraryLenght
						  mapDotSegment: MICROMAPALFDOTTSEGMENT];
	
	// on affiche le bon bouton. Différent si la map est possédée ou non.
	[self displayButtonAccordinglyToPermission: hasUnlockedMap needSuccessRequirement: didNeedSuccessRequirement];
	[self addItineraryitinerary: itinerary verticesLenght: itineraryLenght];
	
	// on récupère les dernières données de la map, qui sont déduite (stages accomplis, etc).
	lvlDone_lvlTotal levelAccomplished;
	
	stageDifficulty difficulty = [[info valueForKey: @"difficulty"] intValue]; //<---
	[self addMap: mapLayer levelsAccomplished: &levelAccomplished];
	NSString* displayName = [info valueForKey: @"constelationName"]; //<--
	[_microStageDisplay newMapInfo: difficulty stageCompleted: &levelAccomplished forstageName: displayName];
}

- (void)displayStageCompleted:(NSUInteger)idx{
    PCConstelationInfo* info = [[PCPicrossDataBase sharedPCPicrossDataBase] constelationForIdx: idx];
    _completionMedal.visible = [info.allStagesComplete boolValue];
}

- (CCSprite*)getStars:(NSUInteger)idx{
	CCSprite* star = nil;
	CCArray* stars = [_batch children];

	// on regarde si il y a suffisament d'étoile dans la pile, si pas assez, on en crée
	if([stars count] <= idx){
		star = [CCSprite spriteWithSpriteFrameName: bigStart];
		[_batch addChild: star];
	}
	// sinon on réutilise la pile
	else{
		star			= [stars objectAtIndex: idx];
		star.visible	= YES;
	}
	
	return star;
}


- (void)addItineraryitinerary:(vertices*)itinerary verticesLenght:(uint)itineraryLenght{
	// y value inversed (openGl / iphone)
	CGRect rect	= CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
	
	for (int i = 0; i < itineraryLenght; i++){
		CGPoint st				= itinerary[i].startPnt;
		CGPoint ed				= itinerary[i].endPnt;
		itinerary[i].startPnt	= (CGPoint){st.x * MICROMAPWIDTHSEGMENT, (mapSize.height - st.y) * MICROMAPHEIGHTSEGMENT};
		itinerary[i].endPnt		= (CGPoint){ed.x * MICROMAPWIDTHSEGMENT, (mapSize.height - ed.y) * MICROMAPHEIGHTSEGMENT};
		
		if(itinerary[i].startPnt.x < rect.origin.x)
			rect.origin.x			= itinerary[i].startPnt.x;
		
		if(itinerary[i].endPnt.x > rect.size.width)
			rect.size.width			= itinerary[i].endPnt.x;
		
		if(itinerary[i].endPnt.y < rect.origin.y)
			rect.origin.y			= itinerary[i].endPnt.y;

		if(itinerary[i].startPnt.y > rect.size.height)
			rect.size.height		= itinerary[i].startPnt.y;
	}
	
	rect.size.width			= rect.size.width - rect.origin.x;
	rect.size.height		= rect.size.height - rect.origin.y;
	stageArea				= rect;
	
	PCDrawedItinerary* drawedItinerary = [[PCDrawedItinerary alloc] initWithItinerary: itinerary 
																			   lenght: itineraryLenght 
																				width: MICROMAPWIDTHLINE 
																				color: MICROMAPLINECOLOR
																		mapDotSegment: MICROMAPALFDOTTSEGMENT];
	
	[_microStageDisplay displayItinerary: drawedItinerary contentSize: stageArea];
	[drawedItinerary release];
}

- (void)addMap:(CCTMXLayer*)mapLayer levelsAccomplished:(lvlDone_lvlTotal*)accomplished{
	NSUInteger idx				= 0;
	NSDictionary* data			= [dataBaseSGTN entriesForConstelation: _currentConstelationName];
	NSUInteger totalStageDone	= 0;
	
	for (int j = mapSize.height - 1; j > -1; j--) 
		for (int i = 0; i < mapSize.width; i++){
			uint constGid = [mapLayer tileGIDAt:(CGPoint){i, j}];
			
			if(constGid){
				CCSprite* sprt			= [self getStars: idx];
				sprt.position			= (CGPoint){i * MICROMAPWIDTHSEGMENT, MICROMAPHEIGHTSEGMENT * mapSize.height + j * -MICROMAPHEIGHTSEGMENT};
				BOOL isStageDone		= [[(PCLevelInfo*)[data objectForKey: [NSNumber numberWithInt: constGid - 1]] isDone] boolValue];
				
				if(isStageDone)
					totalStageDone++;
				
				CCSpriteFrame* frame	= (constGid == 1)?	[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: microstartPnt]: 
															[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: (isStageDone)? bigStart : litleStar];
				[sprt setDisplayFrame: frame];
				idx++;
			}
		};
	
	accomplished->done	= totalStageDone;
	accomplished->total = idx - 1;

	// hide unused Stars
	CCArray* arrayList = [_batch children];
	for (int i = idx; i < [arrayList count]; i++) {
		((CCSprite* )[arrayList objectAtIndex: i]).visible = NO;
	}
}

- (void)loadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: microMapPlist];
	[self set_batch: [CCSpriteBatchNode batchNodeWithFile: microMapFile]];
}

-(void)unloadTexture{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: microMapPlist];
}

#pragma mark override

- (void)onExit{
	[self unloadTexture];
	[super onExit];
}

#pragma mark display

- (void)displayButtonAccordinglyToPermission:(BOOL)isBuyable needSuccessRequirement:(BOOL)successREquirement{
#if MAP_NO_LOCKED == 1
    [_buttonList getChildByTag: Btn_GO_TAG].visible	= YES;
    return;
#endif
    [_buttonList getChildByTag: Btn_GO_TAG].visible		= hasUnlockedMap && !successREquirement;
	[_buttonList getChildByTag: Btn_UNLOCK_TAG].visible	= !hasUnlockedMap;
	// normalement successREquirement ==! hasUnlockedMap; En effet les deux
	// condition ne peuvent pas être vraies en même temps. Sinon on se retrouve
	// avec deux bouttons superposées.
	[_buttonList getChildByTag: Btn_LOCKED_TAG].visible	= successREquirement;
}

#pragma mark setUp

- (void)setUpButton{
	CCSprite* btn			= [CCSprite spriteWithFile: goToMapBtnFile];
#if MAP_NO_LOCKED == 0
	CCSprite* unlock		= [CCSprite spriteWithFile: unlockMapButton];
	CCSprite* locked		= [CCSprite spriteWithFile: lockedMapButton];
#endif
	CCMenuItemSprite* item	= [CCMenuItemSprite itemFromNormalSprite: btn
													 selectedSprite: btn
															 target: self 
														   selector: @selector(goPressed)];
#if MAP_NO_LOCKED == 0
	CCMenuItemSprite* item2	= [CCMenuItemSprite itemFromNormalSprite: unlock
													 selectedSprite: unlock
															 target: self 
														   selector: @selector(goPressed)];
	
	CCMenuItemSprite* item3	= [CCMenuItemSprite itemFromNormalSprite: locked
													  selectedSprite: locked
															  target: self 
															selector: @selector(goPressed)];

#endif
	item.position			= ccp(470, 340);
	item.tag				= Btn_GO_TAG;
#if MAP_NO_LOCKED == 0	
	item2.position			= ccp(470, 340);
	item2.tag				= Btn_UNLOCK_TAG;
	
	item3.position			= ccp(470, 340);
	item3.tag				= Btn_LOCKED_TAG;
	
#endif
	self._buttonList = [CCMenu menuWithItems:
                        item,
#if MAP_NO_LOCKED == 0	
                        item2,
                        item3,
#endif
                        nil];
	[self addChild: _buttonList];
}

- (void)setupBackground{
	_microStageDisplay						= [[PCMicroResumeMapBackground alloc] initMicroResume: _batch];
	_microStageDisplay.position				= ccp(550, 500);
	[self addChild: _microStageDisplay];
    
    self.completionMedal = [CCSprite spriteWithFile: @"medal.png"];
    
    _completionMedal.position = (CGPoint){230, 200};
    [_microStageDisplay addChild: self.completionMedal];
}

- (void)animateCompletionConstellation:(void(^)())completion{
    _completionMedal.opacity    = 0;
    _completionMedal.scale      = .5f;
    
    CCSequence* action = [CCSequence actions:
                          [CCDelayTime actionWithDuration: .5f],
                            [CCSpawn actions: [CCFadeIn actionWithDuration: 1],
                            [CCScaleTo actionWithDuration: 1 scale: 1], nil],
                            [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){
        [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDBELL];

        [CCFlash makeFlashInView: self.parent duration: 1 onCompletion:^{
            if(completion)
                completion();
        }];
       ;})], nil];
    
    [_completionMedal runAction: action];
}

- (void)setUpRequirment{
	_requirment = [[PCRequiermentHelper alloc] init];
}


#pragma mark alloc / dealloc

- (id)initWithButtonDelegate:(id <GGButonPressedDelegate>)delegate_{
	if(self = [super init]){
		self.visible		= isDisplaying;
		_mapEngine			= [[PCConstelationMapEngine alloc] init];
		dataBaseSGTN		= [PCPicrossDataBase sharedPCPicrossDataBase];
		delegate			= delegate_;
		self._mapsPaid		= [dataBaseSGTN mapPaid];

		[self loadTexture];
		[self setupBackground];
		[self setUpButton];
		[self setUpRequirment];
	}
	return self;
}

- (void)dealloc{
	[_requirment				release];
	[_inAppid					release];
	[_mapsPaid					release];
	[_mapMessage				release];
	[_microStageDisplay			release];
	[_currentConstelationName	release];
	[_batch						release];
	[_mapEngine					release];
	[_buttonList				release];
	[super						dealloc];
}
@end
#undef Btn_GO_TAG
#undef Btn_LOCK_TAG

// ********************************************************************************************** //
@implementation PCDrawedItinerary
void ccdrawDashedLine(CGPoint origin, CGPoint destination, float dashLength, CGPoint* arrayDots){
	float dx				= destination.x - origin.x;
	float dy				= destination.y - origin.y;
	float dist				= sqrtf(dx * dx + dy * dy);
	float x					= dx / dist * dashLength;
	float y					= dy / dist * dashLength;
	CGPoint p1				= origin;
	NSUInteger segments		= (int)(dist / dashLength);
	NSUInteger lines		= (int)((float)segments / 2.0);
	
	//NSLog(@"--> lines %u", lines);
	
	for(int i = 0; i < lines; i++){
		//printf(" -%u\n", i);
		arrayDots[i*2]			= p1;
		p1						= (CGPoint){p1.x + x, p1.y + y};
		arrayDots[i*2+1]		= p1;
		p1						= (CGPoint){p1.x + x, p1.y + y};
	}
	
	glVertexPointer(2, GL_FLOAT, 0, arrayDots);	
	glDrawArrays(GL_LINES, 0, segments);
}

- (void)draw{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glColor4ub(color.red, color.green, color.blue, color.alpha);
	glLineWidth(lineWidth);

	for (int i = 0; i < itineraryLenght; i++){
		 ccdrawDashedLine((CGPoint){_itinerary[i].startPnt.x + _itinerary[i].Xdotedmargin, _itinerary[i].startPnt.y + _itinerary[i].Ydotedmargin},
						  (CGPoint){_itinerary[i].endPnt.x + _itinerary[i].Xdotedmargin, _itinerary[i].endPnt.y + _itinerary[i].Ydotedmargin}, mapDotSegment, _dottedvertices);
	 }
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

- (void)drawSwizzle{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glColor4ub(color.red, color.green, color.blue, color.alpha);
	glLineWidth(lineWidth);
	
	for (int i = 0; i < itineraryLenght; i++)
		ccDrawLine(_itinerary[i].startPnt, _itinerary[i].endPnt);
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

#pragma mark alloc / Dealloc

- (id)initWithItinerary:(vertices*)itinerary_ lenght:(uint)itineraryLenght_ width:(uint)width color:(color4Gl)color_ mapDotSegment:(uint)dotSegment{
	static BOOL wasSizzled = NO;
	if(self = [super init]){
		// we need to copy the actual data (itinerary_), not assign it,
		// because it's a pointer and constelationMapEngine use always his own same pointer.
		_itinerary	= malloc(sizeof(vertices) * itineraryLenght_);
		
		// so we copy			
		for (int i = 0; i < itineraryLenght_; i++)
			_itinerary[i]	= itinerary_[i];
		
		itineraryLenght		= itineraryLenght_;
        lineWidth			= width;
		color				= color_;
		mapDotSegment		= dotSegment;
		float longestDist	= 0;
		
		if(dotSegment){
			// optimisation. We alloc the dottedArray before drawing
			for (int i = 0; i < itineraryLenght_; i++) {
				CGPoint ori		= (CGPoint){_itinerary[i].startPnt.x + _itinerary[i].Xdotedmargin, _itinerary[i].startPnt.y + _itinerary[i].Ydotedmargin};
				CGPoint dest	= (CGPoint){_itinerary[i].endPnt.x + _itinerary[i].Xdotedmargin, _itinerary[i].endPnt.y + _itinerary[i].Ydotedmargin};
				float dx		= dest.x - ori.x;
				float dy		= dest.y - ori.y;
				float dist		= sqrtf(dx * dx + dy * dy);
				
				if(longestDist < dist)
					longestDist = dist;
			}
		
			uint segments			= (uint)(longestDist / mapDotSegment);		
			_dottedvertices			= malloc(sizeof(CGPoint) * (segments));
		}
		
		// on fait just un swizzle de method pour basculer la methode qui fait un seul trait, et celle qui fait
		// des pointillés.
		Class class	= [self class];
		Method draw	= class_getInstanceMethod(class, @selector(draw));
				
		if(!dotSegment && !wasSizzled){
			Method drawSwizzle	= class_getInstanceMethod(class, @selector(drawSwizzle));
			method_exchangeImplementations(drawSwizzle, draw);
			wasSizzled = YES;
		}else if(dotSegment && wasSizzled){
			Method drawSwizzle	= class_getInstanceMethod(class, @selector(drawSwizzle));
			method_exchangeImplementations(drawSwizzle, draw);
			wasSizzled = NO;
		}
	}

	return self;
}

- (void)dealloc{
	free(_itinerary);
	free(_dottedvertices);
	[super dealloc];
}
@end