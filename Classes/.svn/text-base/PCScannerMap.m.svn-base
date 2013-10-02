//
//  PicrossEngine.m
//  UsingTiled
//
//  Created by loïc Abadie on 05/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PCScannerMap.h"
#import "GameConfig.h"

@interface PCScannerMap()
	@property (nonatomic, assign) CCTMXLayer*		currentPicross;				// data to be analised
	@property (nonatomic, assign) uint*				_progressionArray;			// keep track of the scanned data
	@property (nonatomic, assign) uint*				_allTheLines;				// count the total picross per line
	@property (nonatomic, assign) BOOL*				_currentLineIsDone;			// count how much the client filled in a row/column
	@property (nonatomic, retain) NSMutableArray*	_picrossColumn;				// data in cgPoint version (for the delegate)
	@property (nonatomic, retain) NSMutableArray*	_picrossRow;				// data in cgPoint version (for the delegate)
	@property (nonatomic, assign) uint				matriceGrid;				// the current grid size
	@property (nonatomic, assign) uint				totalPicrossable;			// the total of pic to be filled
	@property (nonatomic, assign) uint				progessPicrossed;			// get the right count used to check when the game is done
	@property (nonatomic, assign) uint				progressFilled;				// count the pic filled, used to inform delegate. Not the actual progrsee, only used for the delegate. Logic use progessFilled instead
	@property (nonatomic, assign) CGSize			currentMapSize;				// same but in cgPoint
@end

/*	Scanner map handle the raw tileData you feed him. Once the analysis is terminated, the delegate are
	informed about how the same tile(gid) is present in the row and column asked.
	You still can overrid	- (BOOL)isPicrossable:(CGPoint)position; 
								if you want something more precise.
 */
@interface PCScannerMap(PrivateClass)
- (void)computePicrossableTiles:(CCTMXLayer*)sizeMap;
- (void)startAnalysisTo:(int)startScan forJump:(int)jump intoArray:(NSArray*)picrossList;
- (void)scanLine:(uint)line mode:(picross2dArray)rowOrColumn makeReverse:(BOOL)isReversing;
- (BOOL)fastCheck:(uint)line mode:(picross2dArray)rowOrColumn;
- (void)allocCArray;
@end

@implementation PCScannerMap

@synthesize		currentMapSize,
				scannerDelegate,
				currentPicross,
				matriceGrid,
				totalPicrossable,
				progessPicrossed,
				progressFilled,
				_allTheLines,
				_progressionArray,
				_picrossColumn,
				_picrossRow,
				_currentLineIsDone;

#define MAXSPICROSSARRAY (15*15)
- (void)newMap:(CCTMXLayer*)map{
	currentPicross = map;
	[self computePicrossableTiles:map];
}

// count how many continuous squares are in a line *note: we need to make a macro because of code duplication
#define PICROSSABLE 1
#define scanPicrossMap(rowOrCollumn, tilesLayer, map, rOrc){\
	CCTMXLayer *layer	= map;\
	int picrossable		= 0;\
\
	for(int i = 0; i < currentMapSize.width; i++) {\
		NSMutableArray* stack = [[NSMutableArray alloc] init];\
		int startPicrossPoint = -1;\
\
		for(int j = 0; j < currentMapSize.height; j++ ) {\
			uint tmpgid = tilesLayer;\
			if(tmpgid == PICROSSABLE){\
				if(startPicrossPoint == -1)\
					startPicrossPoint = j;\
					picrossable++;\
				}\
			else if(picrossable){\
					[stack addObject: [NSValue valueWithCGPoint:CGPointMake(startPicrossPoint, picrossable)]];\
					_allTheLines[(rOrc * matricSize) + i] += picrossable;\
					picrossable = 0;\
					startPicrossPoint = -1;\
			}\
			if(j == (currentMapSize.height - 1)){\
				if([stack count] && !picrossable) continue;\
					[stack addObject: [NSValue valueWithCGPoint:CGPointMake(startPicrossPoint, picrossable)]];\
					_allTheLines[(rOrc * matricSize) + i] += picrossable;\
					picrossable = 0;\
					startPicrossPoint = -1;\
				}\
			}\
\
	progessPicrossed += _allTheLines[(rOrc * matricSize) + i] ;\
	[rowOrCollumn addObject:stack];\
	[stack release];\
	}\
	totalPicrossable = progessPicrossed / 2; \
} // remember we count botch vertical and horizontal value, so the picToFill are doubled

// save the picrossed info into a _picRow and a _picColumn
- (void)computePicrossableTiles:(CCTMXLayer*)map{
	int matricSize		= [[map.properties valueForKey: PCMATRIXSIZE] intValue];
	
	if(matricSize)
		currentMapSize	= CGSizeMake(matricSize, matricSize);
	else
		currentMapSize	= [(CCTMXTiledMap*)[map parent]mapSize];
	
	matriceGrid			= (uint)currentMapSize.width;
	
	[self allocCArray];
	
	NSMutableArray* picrossColumn	= [[NSMutableArray alloc] init];
	NSMutableArray*	picrossRow		= [[NSMutableArray alloc] init];
	[self set_picrossColumn:	picrossColumn];
	[self set_picrossRow:		picrossRow];
	[picrossRow		release];
	[picrossColumn	release];
	
	scanPicrossMap(_picrossColumn,	[layer tileGIDAt:ccp(i,j)], map, PICROW);
	scanPicrossMap(_picrossRow,		[layer tileGIDAt:ccp(j,i)], map, PICCOLUMN);
	
	[scannerDelegate updatePicrossLeft: [NSDictionary dictionaryWithObjectsAndKeys:	_picrossColumn, PICROSSCOLUMN, 
																					_picrossRow,	PICROSSROW, nil]];
}

// inform if the current squares is picrossable
- (BOOL)isPicrossable:(CGPoint)position{
	return ([currentPicross tileGIDAt:position] == PICROSSABLE);
}

// save the picrosState position and analyse the current position in grid (row & column)
- (void)hasPicrossedTo:(CGPoint)position forState:(picrossState)state{	
	int p					= ((position.y) * currentMapSize.width + (position.x));
	
	// if the position is already filled, no need to go further
	// PICUNFILLED is only used in tutorial mode (for back and redo action).
	// It can be possible to use it later in a free mode, but some change
	// should be done like disabling error warning.
	if(_progressionArray[p] == PICFILLED && state != PICUNFILLED) return;
		
	_progressionArray[p] = (state == PICUNCROSSED || state == PICUNFILLED)? PICUNCROSSED : state;

    // Dans le cas d'une réussite, on incrémente progressFilled.
	if(_progressionArray[p] == PICFILLED){
		progressFilled++;
		[scannerDelegate currentPercentProgress: (float)progressFilled / (float)totalPicrossable * 100];
	}
    
    // Dans le cas d'une annulation de touche event, on décrémente progressFilled.
    if(_progressionArray[p] == PICUNCROSSED && state == PICUNFILLED){
        progressFilled--;
        [scannerDelegate currentPercentProgress: (float)progressFilled / (float)totalPicrossable * 100];
    }
    
	[scannerDelegate analyseWillStart: position];

	if(![self fastCheck: position.y mode: PICROW]){
		[self scanLine: position.y mode: PICROW		makeReverse: NO];
		[self scanLine: position.y mode: PICROW		makeReverse: YES];
	}
	
	if(![self fastCheck: position.x mode: PICCOLUMN]){
		[self scanLine: position.x mode: PICCOLUMN	makeReverse: NO];
		[self scanLine: position.x mode: PICCOLUMN	makeReverse: YES];
	}	
}

// perform a fast check and watch if there's a need scanning deep further
- (BOOL)fastCheck:(uint)line mode:(picross2dArray)rowOrColumn{
	uint		startTo				= (rowOrColumn == PICROW)? line * matriceGrid : line;	
	int			jumpInArray			= (rowOrColumn == PICROW)? 1 : matriceGrid;
	uint		accessCArray		= (rowOrColumn == PICROW)? line + matriceGrid : line;
	uint		totalOfPicFilled	= 0;
	uint		totalOfPicCrossed	= 0;
	uint		segments			= (rowOrColumn)?	[[_picrossColumn objectAtIndex: line] count] :
														[[_picrossRow objectAtIndex: line] count];

	for(int i = 0; i < matriceGrid; i++)
		switch (_progressionArray[i * jumpInArray + startTo]) {
			case PICFILLED:		totalOfPicFilled++;		break;
			case PICCROSSED:	totalOfPicCrossed++;	break;
		}
		
	if(totalOfPicFilled == _allTheLines[accessCArray]){							// check if a line is fully well crossed
		for(int i = 0; i < segments; i++)
				[scannerDelegate updateMatch: i forMode: rowOrColumn currentLine: line];
		
			if(!_currentLineIsDone[accessCArray]){
				progessPicrossed -= totalOfPicFilled;
				_currentLineIsDone[accessCArray] = YES;
						
				if(!progessPicrossed)
					[scannerDelegate allPicrossAreMatching];
			}
				return YES;
	}
	else if(totalOfPicFilled + totalOfPicCrossed == matriceGrid)				// check if a line is full but not crossed correctly
		return YES;
	
	// for free mode
	else if (_currentLineIsDone[accessCArray]){
		_currentLineIsDone[accessCArray] = NO;
		progessPicrossed += _allTheLines[accessCArray];
	}
				
	return NO;
}

// scan line and check all the pircross matchin, inform then the delegate
- (void)scanLine:(uint)line mode:(picross2dArray)rowOrColumn makeReverse:(BOOL)isReversing{
	uint		startTo					=	(rowOrColumn == PICROW)? line * matriceGrid : line;
	int			jumpInArray				=	(rowOrColumn == PICROW)? 1 : matriceGrid;
	
	if(isReversing){
		jumpInArray	*= -1;
		startTo		= (rowOrColumn == PICROW)? startTo + matriceGrid - 1: startTo + matriceGrid * (matriceGrid-1);
	}
	
	int			moveInArray				= startTo;
	NSArray*	valuesToCompare			= (!rowOrColumn)?	[_picrossRow objectAtIndex:		line] : 
	[_picrossColumn objectAtIndex:	line];
	uint		increment				= 0;
	uint		countFilled				= 0;
	uint		linkedNeighbor			= 0;
	uint		totalValues				= [valuesToCompare count];
	uint		checkInArray			= (!isReversing)? 0 : totalValues - 1;
	uint		valueShouldBeEqualTo	= [[valuesToCompare objectAtIndex: checkInArray] CGPointValue].y;
	
	while (increment != matriceGrid) {
		if(_progressionArray[moveInArray] == PICFILLED)
			countFilled++;
		
		else if(!_progressionArray[moveInArray])
			break;
		
		else if(countFilled){
			if(linkedNeighbor <= totalValues - 1){
				checkInArray			= (!isReversing)? linkedNeighbor : totalValues - 1 - linkedNeighbor;
				valueShouldBeEqualTo	= [[valuesToCompare objectAtIndex: checkInArray] CGPointValue].y;
				linkedNeighbor = linkedNeighbor + 1;
			}
			
			if(countFilled == valueShouldBeEqualTo)
				[scannerDelegate updateMatch: checkInArray  forMode: rowOrColumn currentLine: line];
			
			countFilled = 0;
		}
		
		increment++;
		moveInArray = increment * jumpInArray + startTo;
	}
}

#pragma mark alloc/dealloc
- (void)allocCArray{
	if(_allTheLines){
		free(_allTheLines);
		_allTheLines = NULL;
	}
	
	if(_currentLineIsDone){
		free(_currentLineIsDone);
		_currentLineIsDone = NULL;
	}
	
	if(matriceGrid){
		free(_progressionArray);
		_progressionArray = NULL;
	}
	
	_progressionArray	= calloc(sizeof(uint), matriceGrid * matriceGrid);
	_allTheLines		= calloc(sizeof(int), 2 * matriceGrid);								// (row + column) * MaxSize
	_currentLineIsDone	= calloc(sizeof(BOOL), 2 * matriceGrid);
	
	NSAssert((_currentLineIsDone && _allTheLines && _progressionArray), @"[PCScannerMap]: failed to allocate memory");
}

- (void)dealloc{
	free(_currentLineIsDone);
	free(_progressionArray);
	free(_allTheLines);
	[_picrossColumn release];
	[_picrossRow release];
	[super dealloc];
}
@end
