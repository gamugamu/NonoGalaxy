//
//  PCGridDecorator.m
//  picrossGame
//
//  Created by loïc Abadie on 28/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCStageBoardDecorator.h"
#import "PCHintBoard.h"
#import "GameConfig.h"

@implementation PCStageBoardDecorator

+ (uint)redoCross:(CGPoint)pnt{
	uint jump = (((uint)pnt.x % 10 < 5)^((uint)pnt.y % 10 < 5))? 0 : SIZEGRIDCUTSQUARE;			

	return	((uint)pnt.x % SIZEGRIDCUT) + 
			((uint)pnt.y % SIZEGRIDCUT * SIZEGRIDCUT) + jump + 1;
}

+ (void)skinMask:(CCTMXLayer*)layer forMatriceSize:(uint)msize{
	// skin the board
	for (int i = 0; i < msize; i++)
		for (int j = 0; j < msize; j++){
			uint jump = ((i % 10 < 5)^(j % 10 < 5))? 0 : SIZEGRIDCUTSQUARE;			
			[layer setTileGID: i % SIZEGRIDCUT + (j % SIZEGRIDCUT * SIZEGRIDCUT) + jump + 1
						   at: (CGPoint){i, j}];
		}
	

	// skin the borders
	[layer setTileGID: STATESBORDER at: (CGPoint){0, msize}];				// left down corner
	for (int i = 1; i < msize; i++)
		[layer setTileGID: (i % 2)? STATESBORDER + 1 : STATESBORDER + 2 at: (CGPoint){i, msize}];		// downest tiles

	[layer setTileGID: STATESBORDER + 3 at: (CGPoint){msize, msize}];		// right down corner
	
	for (int i = 1; i < msize; i++)
		[layer setTileGID: (i % 2)? STATESBORDER + 9 : STATESBORDER + 14 at: (CGPoint){msize, i}];		// rigthest tiles

	[layer setTileGID: STATESBORDER + 4 at: (CGPoint){msize, 0}];			// left up corner
}

#define skinHintHelper(gid, w, z, rowOrColumn){\
	CGPoint lastTile	= CGPointMake(-1, -1);\
\
int i;\
	for (i = 0; i < mSize; i++){\
		uint cellInLine = helper[i];\
		for (int j = 0; j <  cellInLine; j++){\
		static int firstLineDetector = -1;\
		BOOL isFirstInLine	= NO;\
		uint lineToCompare	= (rowOrColumn == PICROW)? z : w;\
		uint cGid			= (i % 2)? gid : gid + 1;\
\
		if(firstLineDetector != lineToCompare){\
			firstLineDetector = lineToCompare;\
			isFirstInLine = YES;\
			if(lastTile.x != -1 || lastTile.y !=  -1){\
				if(rowOrColumn == PICROW){\
					lastTile.x--;\
					[layer setTileGID: (i % 2)? 66 : 67 at: lastTile];\
				}else{\
					lastTile.y--;\
					[layer setTileGID: (i % 2)? 68 : 69 at: lastTile];\
				}\
			}\
		}\
	\
		lastTile = (CGPoint){w, z};\
		[layer setTileGID:cGid at: lastTile];\
\
		}\
	}\
	if(rowOrColumn == PICROW){\
		lastTile.x--;\
		[layer setTileGID: (i % 2)? 66 : 67 at: lastTile];\
	}else{\
		lastTile.y--;\
		[layer setTileGID: (i % 2)? 68 : 69 at: lastTile];\
	}\
}

+ (void)skinHint:(CCTMXLayer*)layer withLenghtHelper:(uint*)helper matriceSize:(uint)mSize type:(picross2dArray)rowOrColumn{
	uint halfMSize = divideUp(mSize, 2) - 1;

	// undisplay th first gid
	[layer setTileGID: 63 at: CGPointZero];

	switch (rowOrColumn) {
		case PICROW:{		skinHintHelper(STATESHINT, halfMSize - j, i, PICROW);}		break;
			
		case PICCOLUMN:{	skinHintHelper(STATESHINT + 2, i, halfMSize - j, PICCOLUMN);}	break;
	}
}
@end
