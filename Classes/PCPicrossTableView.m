//
//  PCPicrossesDBGalaxyHelper.m
//  picrossGame
//
//  Created by loïc Abadie on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossTableView.h"
#import "PCFilesManager.h"
#import "GGPrivateDoc.h"
#import "GameConfig.h"
#import "SWTableView.h"
#import "MyCell.h"

@interface PCPicrossTableView()<SWTableViewDataSource, SWTableViewDelegate>
@property(nonatomic, retain)SWTableView*								_tableView;
@property(nonatomic, retain)NSString*									_mapDisplayfolderName;
@property(nonatomic, assign)id <PCPicrossesDBGalaxyHelperDelegate>		delegate;
@property(nonatomic, assign)NSUInteger									currentIdx;
@property(nonatomic, assign)NSUInteger									numberOfCells;
@property(nonatomic, assign)PCFilesManager*								sharedFileManager;
@property(nonatomic, assign)SWTableViewCell*							currentCell;
@end

@implementation PCPicrossTableView
@synthesize 	currentCell,
				delegate,
				currentIdx,
				numberOfCells,
				sharedFileManager,
				_tableView,
				_mapDisplayfolderName;

/*
	Return a menu map display list. Because we need to read fast the data (if the map is accessible or not) we need 
	to read the data inside the dataBase instead of opening and readind all the .tmx map files.
	When new maps are added, PCPicrossesDBGalaxyHelper insert the new one into the data base.
	This class is used by PCPicrossesGalaxyMenu.
*/

#define PCIPADWidth			1024	// width of the table cell
#define PCTableViewHeight	340		// height of the table cell
#define PCCellWidth			220		// height of the table cell
#define PCCellRowPerRange	4		// how many cells are shown in a row
#define PCCellSelectedInRow	1		// this is the selected one int the row ex: for a range of 4 with one: |0,1,0,0|

#pragma mark public
- (void)selectCell:(NSUInteger)idx needAnimate:(BOOL)isAnimating{
	if(idx < numberOfCells + 1)		//remember the first one is blank
		[_tableView selectCell: idx + 1 inRow: PCCellSelectedInRow needAnimate: isAnimating];
}

- (void)updateTable{
	numberOfCells					= [sharedFileManager countOfMaps] + 1; // don't forget "check new maps" too. 
	[_tableView reloadData];
}

- (void)setIsAllowingToRow:(BOOL)isAllowing{
	_tableView.isAllowingToRow = isAllowing;
}

- (BOOL)isAllowingToRow{
	return _tableView.isAllowingToRow;
}

#pragma mark private
- (void)setUpTableView{
	[self set_tableView: [SWTableView viewWithDataSource:self size: CGSizeMake(PCIPADWidth, PCTableViewHeight)]];
	_tableView.delegate				= self;
	_tableView.isAllowingToRow		= NO;
	_tableView.verticalFillOrder	= SWTableViewFillTopDown;
	_tableView.fixedCellSize		= PCIPADWidth / PCCellRowPerRange;
	numberOfCells					= [sharedFileManager countOfMaps] + 1; // don't forget "check new maps" too.
	
	[self addChild: _tableView];
	[self set_mapDisplayfolderName: [GGPrivateDoc privateDocsDirectory: FOLDERmapDisplays]];
	
	[_tableView reloadData];
	currentIdx						=  [_tableView currentSelectedCell];
}

#define PCConstelationSpriteTag 5
#pragma mark TableViewDelegate
-(void)table:(SWTableView *)table cellTouched:(uint)idx{
	if(!(idx <= PCCellSelectedInRow - 1 || idx > numberOfCells || currentIdx == idx - PCCellSelectedInRow)){
		[_tableView selectCell: idx inRow: PCCellSelectedInRow needAnimate: YES];
		SWTableViewCell* cell	= [_tableView cellAtIndex: idx];
		CCSprite* sprite		= (CCSprite*)[cell getChildByTag: PCConstelationSpriteTag];
		
		// run a buble animation
		sprite.scale			= 1.2;
		id move					= [CCScaleTo actionWithDuration: .5f scale: 1];
		id action				= [CCEaseBounceOut actionWithAction:move];
		[sprite runAction: action];
        [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDPOP];
	}
}

-(CGSize)cellSizeForTable:(SWTableView *)table {
    return CGSizeMake(PCIPADWidth / PCCellRowPerRange, PCTableViewHeight);
}

- (void)tableIsScrollingToCell:(NSUInteger)idx{
	if(currentIdx != idx){
		[delegate galaxiesRowing];
	}
}

- (void)tableScrollIsDone{
	currentIdx				= [_tableView currentSelectedCell];
	[delegate galaxyOnList: currentIdx];
}

- (void)askCurrentGalaxyOnList{
	[self tableScrollIsDone];
}

-(SWTableViewCell *)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
	
    SWTableViewCell *cell	= [table dequeueCell];
	NSString* fileName		= nil;
	switch (idx) {
		case 0:		fileName = mapDisplayBlank;
			break;
		case 1:		fileName = mapDisplayNewMap;
			break;
		default:	fileName = (idx <= PCCellSelectedInRow - 1 || idx > numberOfCells)? mapDisplayBlank : [_mapDisplayfolderName stringByAppendingPathComponent: [sharedFileManager getMapPNGNameFromIdx: idx - PCCellSelectedInRow]];
			break;
	}
	
    if (!cell) {
        cell					= [[[MyCell alloc] init] autorelease];
		CCColorLayer *sprite	= [CCSprite spriteWithFile: fileName];
		sprite.anchorPoint		= CGPointMake(0, 0);
		sprite.tag				= PCConstelationSpriteTag;
		[cell addChild:sprite];
    }
	else{
		CCSprite* sprite	= (CCSprite*)[cell getChildByTag: PCConstelationSpriteTag];
		sprite.opacity		= self.opacity;
		sprite.position		= ccp(0, sprite.position.y);//<---
		[sprite setTexture: [[CCTextureCache sharedTextureCache] addImage: fileName]];//<-- don't forget to purge
	}
	
    return cell;
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return numberOfCells + PCCellRowPerRange - PCCellSelectedInRow;
}

#pragma mark end private

#pragma mark alloc/dealloc
- (id)initWithDelegate:(id <PCPicrossesDBGalaxyHelperDelegate>)delegate_{
	if((self = [super init])){
		delegate			= delegate_;
		sharedFileManager	= [PCFilesManager sharedPCFileManager];
		[self setUpTableView];
	}
	return self;	
}

- (void)dealloc{
	[CCTextureCache purgeSharedTextureCache];
	[_tableView						release];
	[_mapDisplayfolderName			release];
	[super dealloc];
}
@end
