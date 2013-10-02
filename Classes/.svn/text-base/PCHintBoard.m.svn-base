//
//  PicrossRemainingView.m
//  UsingTiled
//
//  Created by loïc Abadie on 06/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PCHintBoard.h"
#import "GameConfig.h"

// show an color area at the cursor position
@interface PCHintViewSelected : CCNode
@property(nonatomic, assign)CGRect hightLightedAreas;
@end

@interface PCHintBoard()
- (void)synchroniseBoard:(CGPoint)tilepnt type:(picross2dArray)rowOrCollum withOpacity:(uint)opacity;
- (void)hilightHintAt:(CGPoint)pnt;
- (void)unHilightAll;
- (void)unHilightHintAt:(CGPoint)pnt;
@property(nonatomic, retain)CCTMXLayer*			_upboard;
@property(nonatomic, retain)CCTMXLayer*			_leftboard;
@property(nonatomic, retain)CCTMXLayer*			_microUpboard;					// used By MicroMosaik
@property(nonatomic, retain)CCTMXLayer*			_microLeftboard;				// used By MicroMosaik
@property(nonatomic, assign)PCHintViewSelected* leftHighlight;
@property(nonatomic, assign)PCHintViewSelected* rightHighlight;
@property(nonatomic, assign)id<PCHintBoardDelegate> delegate;
@property(nonatomic, assign)CGPoint				currentHilightedAreaPnt;		// the one used where the hilighted Area is
@property(nonatomic, assign)CGPoint				currentMoveLowlightedAreaPnt;	// the one used where the move cursor is. Note that it's not the same than currentHilightedAreaPnt
@property(nonatomic, assign)uint				mapSizeMinus;					// mapSize minus one - performance reason
@property(nonatomic, assign)uint				matriceSize;					
@property(nonatomic, assign)uint				halfMSize;
@property(nonatomic, assign)int					lth;
@property(nonatomic, assign)int					lPY;
@property(nonatomic, assign)int					ltw;		
@property(nonatomic, assign)int					lPX;		
@property(nonatomic, assign)uint*				hintFootPrint;
@property(nonatomic, assign)BOOL				isHilighted;
@end

@implementation PCHintBoard
@synthesize delegate,
			mapSizeMinus,
			matriceSize,
			halfMSize,
			lPY,
			ltw,
			lPX,
			lth,
			hintFootPrint,
			leftHighlight,
			rightHighlight,
			currentHilightedAreaPnt,
			currentMoveLowlightedAreaPnt,
			isHilighted,
			_upboard,
			_microUpboard,
			_leftboard,
			_microLeftboard;

#pragma mark public
#define PICROSSMAXSIZE		20 // the maxSize a picross can be
#define NUMGIG				40 // 40 because the first gids are the binary tiles needed to skin the map

uint divideUp(uint x, uint y) { 
	uint a = (x -1)/y +1;
	return a + 1;
}

// reblack both current column and row
- (void)reBlackenNumber:(CGPoint)lines{
	uint lineX			= (uint)lines.x;
	uint lineY			= (uint)lines.y;
	uint offset			= halfMSize - 1;

	for(int i = 0; i < hintFootPrint[matriceSize + lineY]; i++)
		[self synchroniseBoard: (CGPoint){offset - i, lineY} type: PICROW withOpacity: 255];

	for(int j = 0; j < hintFootPrint[lineX]; j++)
		[self synchroniseBoard: (CGPoint){lineX, offset - j}  type: PICCOLUMN withOpacity: 255];
}

- (uint*)getHintFootPrintForType:(picross2dArray)rowOrCollum {
	return (rowOrCollum == PICROW)? hintFootPrint + matriceSize : hintFootPrint;
}

// synchronise both micro and normal hintsBoards
- (void)synchroniseBoard:(CGPoint)tilepnt type:(picross2dArray)rowOrCollum withOpacity:(uint)opacity{	
	switch (rowOrCollum) {
		case PICCOLUMN:	[[_upboard			tileAt: tilepnt] setOpacity: opacity];
						[[_microUpboard		tileAt: tilepnt] setOpacity: opacity];
		break;
		
		case PICROW:	[[_leftboard		tileAt: tilepnt] setOpacity: opacity];
						[[_microLeftboard	tileAt: tilepnt] setOpacity: opacity];
		break;
	}
}

#pragma mark touchPnt protocol
// highlight the selected position
- (void)newTouchPointIntoMatrice:(CGPoint)pnt{
	if(CGPointEqualToPoint(currentHilightedAreaPnt, pnt)) return;
	
	uint leftOverlap	= hintFootPrint[matriceSize + (uint)pnt.y];
	uint rightOverlap	= hintFootPrint[(uint)pnt.x];
	
	leftHighlight.hightLightedAreas		= CGRectMake((halfMSize - leftOverlap) * TILESIZE,
													 (mapSizeMinus - pnt.y) * TILESIZE,
													 TILESIZE * leftOverlap,
													 TILESIZE);
	
	rightHighlight.hightLightedAreas	= CGRectMake(pnt.x * 44, 
													 0, 
													 TILESIZE,
													 TILESIZE * rightOverlap);	
	
	// Don't forget to light the hintBoard too
	[self unHilightHintAt: currentHilightedAreaPnt];
	[self hilightHintAt: pnt];
	
	currentHilightedAreaPnt = pnt;
	isHilighted				= YES;
}

- (void)cancelTouchPoint{	
	[self unHilightAll];
}

- (void)touchPointIntoMatriceEnded{
	[self unHilightAll];
};

// make the values to display into the hintsBoards 
- (void)updatePicrossLeft:(NSDictionary*)picrossableInfoList{
	NSArray* upInfo		= [picrossableInfoList	objectForKey: PICROSSCOLUMN];
	NSArray* leftInfo	= [picrossableInfoList	objectForKey: PICROSSROW];
	int j;
	
	for(int i = 0; i < [upInfo count]; i++){
		NSInteger count =  [[upInfo objectAtIndex:i] count] - 1;
		
		uint footCount	= 0;
		for(j = 0; j <= count; j++){
			CGPoint value = [[[upInfo	objectAtIndex:i] objectAtIndex:count-j] CGPointValue];
			
			if(value.x == -1)
				[delegate emptyLineDetected:PICROW line: i];
			
			int gid = (int)value.y + NUMGIG;
			if(gid > NUMGIG) footCount++;
			
			CGPoint tilePnt = (CGPoint){i,(halfMSize - 1) - j};
			[_upboard		setTileGID: gid				at: tilePnt];
			[_microUpboard	setTileGID: (int)value.y	at: tilePnt];
		}
		hintFootPrint[i] = footCount;
	}
	
	int l;
	for(int i = 0; i < [leftInfo count]; i++){
		NSInteger count =  [[leftInfo objectAtIndex:i] count] - 1;
		uint footCount	= 0;
		for(l = 0; l <= count; l++){
			CGPoint value = [[[leftInfo	objectAtIndex:i] objectAtIndex:count-l] CGPointValue];
			
			if(value.x == -1)
				[delegate emptyLineDetected:PICCOLUMN line: i];
			
			int gid = (int)value.y + NUMGIG;
			if(gid > NUMGIG) footCount++;
			
			CGPoint tilePnt = (CGPoint){(halfMSize - 1) - l, i};
			[_leftboard			setTileGID: gid				at: tilePnt];
			[_microLeftboard	setTileGID: (int)value.y	at: tilePnt];
		}
		hintFootPrint[matriceSize + i] = footCount;
	}
}

// when grid is crossed, the hintsBoards are greyed out depending of what's matching whith the picross draw
- (void)updateMatch:(uint)match forBoard:(picross2dArray)rowOrColumn currentLine:(uint)line{
	uint accessArray = (rowOrColumn == PICCOLUMN)?  0 : mapSizeMinus + 1; 

	if(!hintFootPrint[accessArray + line]) return;

	uint foot				= halfMSize - hintFootPrint[accessArray + line] + match;

	// gray only value who match the data;
	// NSLog(@"%@ hintFootPrint[rowOrColumn][line] : %u -- foot: %u", (rowOrColumn == PICROW)? @"left": @"up", hintFootPrint[rowOrColumn + line], foot);

	CGPoint tilePos			=  (rowOrColumn)? (CGPoint){line, foot} :  (CGPoint){foot, line};
	[self synchroniseBoard: tilePos  type: rowOrColumn withOpacity: 100];
}

/* ntp	-> numbers of tiles to reposition
	tn	-> tile number (in the grid)
*/

#define repositionLeft(line){\
int	ntp	= hintFootPrint[matriceSize + line];\
	for (int i = 0; i < ntp; i++) {\
		uint tn	= halfMSize - ntp + i;\
		CCSprite* nTile = [_leftboard tileAt: CGPointMake(tn, line)];\
		nTile.position	= (CGPoint){tn * TILESIZE, nTile.position.y};\
	}\
}

#define repositionUp(line){\
	int	ntp	= hintFootPrint[line];\
	for (int i = 0; i < ntp; i++) {\
		uint tn			= halfMSize - ntp + i;\
		CCSprite* nTile = [_upboard tileAt: CGPointMake(line, tn)];\
		nTile.position	= (CGPoint){nTile.position.x, (ntp - i - 1) * TILESIZE};\
	}\
}

/* cnt -> current numbers of tiles 
	tw -> tiles width
	tn -> tile number (in the grid)
*/
#define moveLeft(line){\
	int	cnt	= hintFootPrint[matriceSize + line];\
	int	tw	= cnt * TILESIZE;\
	if(tw >= overlay.width){\
		for (int i = 0; i < cnt; i++) {\
			uint tn			= halfMSize - cnt + i;\
			CCSprite* nTile = [_leftboard tileAt: CGPointMake(tn, line)];\
			nTile.position	= (CGPoint){tn * TILESIZE + tw - overlay.width, nTile.position.y};\
		}\
	}\
}

#define moveUp(line){\
	int		cnt	= hintFootPrint[line];\
	int		th	= cnt * TILESIZE;\
	if(th >= overlay.height){\
		for (int i = 0; i < cnt; i++) {\
			uint tn			= halfMSize - cnt + i;\
			CCSprite* nTile = [_upboard tileAt: CGPointMake(line, tn)];\
			nTile.position	= (CGPoint){nTile.position.x, (i+1) * -TILESIZE + overlay.height};\
		}\
	}\
}

// NSLog(@"%f - %f --> %f", nTile.position.y, overlay.height, (i+1) * -TILESIZE + overlay.height);

// when the hintboard is out of view, we redraw the column and row depending or where is the cursor (like in picross NDS)
- (void)updateExceedDisplay:(CGSize)overlay currentPosition:(CGPoint)position{

	/*if(!isHilighted && !CGPointEqualToPoint(currentHilightedAreaPnt, position)){
		[self unHilightHintAt: currentHilightedAreaPnt];
		[self hilightHintAt: position];
		currentHilightedAreaPnt = position;
		NSLog(@"hilight exceed to %f %f", currentHilightedAreaPnt.x, currentHilightedAreaPnt.y);
	}else*/ if (!CGPointEqualToPoint(currentMoveLowlightedAreaPnt, position) && !isHilighted){
		 currentMoveLowlightedAreaPnt = position;
		// NSLog(@"lowLight exceed to %f %f", currentMoveLowlightedAreaPnt.x, currentMoveLowlightedAreaPnt.y);
	}
	
	// *********** LEFT SIDE ************
	uint		cPY		= (uint)position.y;							// current	Y position
	
	// reset position if uPY != last update, don't
	if(ltw <= overlay.width || (lPY != cPY && lPY != -1)){
		int lYB = lPY - 1;											// line Y before
		int lYA = lPY + 1;											// line Y after
		
		// NSLog(@"--> repositionX %i << %i >> %i", (lYB < 0)? -1 : lYB, lPY, (lYA > mapSizeMinus)? -1 : lYA);
		if(lYB >= 0)				repositionLeft(lYB);
		if(lYA <= mapSizeMinus)		repositionLeft(lYA);
									repositionLeft(lPY);
	}

	
	// check if the hint line exceding
	int cYB = cPY - 1;
	int cYA = cPY + 1;
	
	// finally move the hint according to the board position
	if(cYB >= 0)				moveLeft(cYB);
	if(cYA <= mapSizeMinus)		moveLeft(cYA);
								moveLeft(cPY);
	
	// save position
	lPY = cPY;
	ltw = hintFootPrint[matriceSize + cPY] * TILESIZE;
	
	// ************* UP SIDE ************
	uint		cPX		= (uint)position.x;							// current	X position
	
	if(lth <= overlay.height || (lPX != cPX && lPX != -1)){
		 int lXB = lPX - 1;											// line X before
		 int lXA = lPX + 1;											// line X after
		
		// NSLog(@"--> repositionY %i << %i >> %i", (lXB < 0)? -10 : lXB, lPX, (lXA > mapSizeMinus)? -10 : lXA);
		 if(lXB >= 0)				repositionUp(lXB);
		 if(lXA <= mapSizeMinus)	repositionUp(lXA);		
									repositionUp(lPX);
	}
	
	int cXB = cPX - 1;
	int cXA = cPX + 1;
	
	if(cXB >= 0)				moveUp(cXB);
	if(cXA <= mapSizeMinus)		moveUp(cXA);
								moveUp(cPX);
	
	lPX			= cPX;
	lth			= hintFootPrint[cPX] * TILESIZE;
}

- (void)realign:(CGPoint)pnt{	
	// *********** LEFT SIDE ************
	uint cPY	= (uint)pnt.y;
	int cYB		= cPY - 1;
	int cYA		= cPY + 1;
	
	if(cYB >= 0)				repositionLeft(cYB);
	if(cYA <= mapSizeMinus)		repositionLeft(cYA);
								repositionLeft(cPY);

	// ************* UP SIDE ************
	
	uint cPX = (uint)pnt.x;
	
	int cXB = cPX - 1;
	int cXA = cPX + 1;
		
	if(cXB >= 0)				repositionUp(cXB);
	if(cXA <= mapSizeMinus)		repositionUp(cXA);		
								repositionUp(cPX);
}

- (void)hilightHintAt:(CGPoint)pnt{	
	int	cnt	= hintFootPrint[matriceSize + (uint)pnt.y];
	
	// Left side
	for (int i = 0; i < cnt; i++) {
		uint tn			= halfMSize - cnt + i;
		CGPoint tPnt	= ccp(tn, (uint)pnt.y);
		uint trsGid		= [_leftboard tileGIDAt: tPnt];
				
		// check if the interval is correct
		if((21 + trsGid) < NUMGIG + 40)
			[_leftboard	setTileGID: trsGid + 21	 at: tPnt];
	}
	
	int	cnt2	= hintFootPrint[(uint)pnt.x];
	
	// up side
	for (int i = 0; i < cnt2; i++) {
		uint tn			= halfMSize - cnt2 + i;
		CGPoint tPnt	= ccp((uint)pnt.x, tn);
		uint trsGid		= [_upboard tileGIDAt: tPnt];

		if((21 + trsGid) < NUMGIG + 40)
			[_upboard	setTileGID: trsGid + 21	 at: tPnt];
	}
}

- (void)unHilightAll{
	if(isHilighted){
		leftHighlight.hightLightedAreas		= CGRectZero;
		rightHighlight.hightLightedAreas	= CGRectZero;
		[self unHilightHintAt: currentHilightedAreaPnt];
		isHilighted							= NO;
	}
}

- (void)unHilightHintAt:(CGPoint)pnt{
	int	cnt	= hintFootPrint[matriceSize + (uint)pnt.y];
	
	// Left side
	for (int i = 0; i < cnt; i++) {
		uint tn			= halfMSize - cnt + i;
		CGPoint tPnt	= ccp(tn, (uint)pnt.y);
		uint trsGid		= [_leftboard tileGIDAt: tPnt];
			
		// check if the interval is correct
		if((trsGid - 21) > NUMGIG)
			[_leftboard	setTileGID: trsGid - 21	 at: tPnt];
		}
	
	int	cnt2	= hintFootPrint[(uint)pnt.x];
	// up side
	for (int i = 0; i < cnt2; i++) {
		uint tn			= halfMSize - cnt2 + i;
		CGPoint tPnt	= ccp((uint)pnt.x, tn);
		uint trsGid		= [_upboard tileGIDAt: tPnt];
		
		if((trsGid - 21) > NUMGIG)
			[_upboard	setTileGID: trsGid - 21	 at: tPnt];
	}
}

#pragma mark alloc/dealloc
//	return the current hintBoard display
- (CCTMXTiledMap*)createBoardForType:(picross2dArray)rowOrColumn imageResolve:(NSDictionary*)imagesResolve resolvePath:(NSString*)path{
	PCHintViewSelected* hlght	= [PCHintViewSelected node];
	CCTMXTiledMap* hintBoard	= nil;
	
	if(rowOrColumn == PICCOLUMN){
        hintBoard = [[CCTMXTiledMap alloc] initWithTMXFile: LEFTHINT
                                            imageToReplace: imagesResolve
                                              resolvedPath: path
                                                andMapSize: CGSizeMake(halfMSize, mapSizeMinus + 1)];
	
         leftHighlight	= hlght;
	}else{
		hintBoard = [[CCTMXTiledMap alloc] initWithTMXFile: UPHINT
                                            imageToReplace:	imagesResolve
											  resolvedPath:	path
												andMapSize: CGSizeMake(mapSizeMinus + 1, halfMSize)];
		rightHighlight	= hlght;
	}
														
	(rowOrColumn == PICCOLUMN)? [self set_leftboard:	(CCTMXLayer* )[hintBoard getChildByTag:1]] :
								[self set_upboard:		(CCTMXLayer* )[hintBoard getChildByTag:1]];
		
	[hintBoard	addChild: hlght];

	return [hintBoard autorelease];	
}

// return a mini version one
- (CCTMXTiledMap*)createMicroBoardForType:(picross2dArray)rowOrColumn{
	CCTMXTiledMap* hintBoard = (rowOrColumn == PICCOLUMN)?	[[CCTMXTiledMap alloc] initWithTMXFile: @"microHint.tmx"	//<---
																					   andMapSize: CGSizeMake(halfMSize, mapSizeMinus + 1)] :
															[[CCTMXTiledMap alloc] initWithTMXFile: @"microHint.tmx"	//<---
																						andMapSize: CGSizeMake(mapSizeMinus + 1, halfMSize)];
	
	(rowOrColumn == PICCOLUMN)? [self set_microLeftboard:	(CCTMXLayer* )[hintBoard getChildByTag: 0]]:
								[self set_microUpboard:		(CCTMXLayer* )[hintBoard getChildByTag: 0]]; 
							

	return [hintBoard autorelease];	
}

- (id)initWithDelegate:(id<PCHintBoardDelegate>)delegate_ matriceSize:(uint)_mapSize{
	if((self = [super init])){
		delegate		= delegate_;
		mapSizeMinus	= _mapSize - 1;
		matriceSize		= _mapSize;
		hintFootPrint   = calloc(sizeof(uint), matriceSize * 2);
		halfMSize		= divideUp(matriceSize, 2);
		lPY				= -1;										// last		Y position
		ltw				= INT_MAX;									// last tiles width
		lPX				= -1;										// last		X position
		lth				= INT_MAX;									// last tiles height
	}
	return self;
}

- (void)dealloc{
	free(hintFootPrint);
	[_leftboard			release];
	[_upboard			release];
	[_microUpboard		release];
	[_microLeftboard	release];
	[super				dealloc];
}
@end

@implementation PCHintViewSelected
@synthesize hightLightedAreas;
- (void)draw{
	glColor4ub(255, 255, 0, 255);
	uint W = hightLightedAreas.origin.x + hightLightedAreas.size.width;
	uint H = hightLightedAreas.origin.y + hightLightedAreas.size.height;
	CGPoint vertices[] = { 
		ccp(hightLightedAreas.origin.x, hightLightedAreas.origin.y), 
		ccp(hightLightedAreas.origin.x, H), 
		ccp(W, H), 
		ccp(W,  hightLightedAreas.origin.y)
	};
	ccFillPoly(vertices, 4, YES);
}
@end