//
//  MoveTile.m
//  picrossGame
//
//  Created by loïc Abadie on 18/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PCMoveTile.h"

@interface PCMoveTile()
	@property (nonatomic, assign, readonly) float totalWidth;
	@property (nonatomic, assign, readonly) float totalHeight;
	@property (nonatomic, assign, readonly) float width;
	@property (nonatomic, assign, readonly) float height;
	@property (nonatomic, assign, readonly) CGPoint mapSize;
	@property (nonatomic, assign, readonly) CGPoint	currentCursorPosition;
@end

@interface PCMoveTile(PrivateClass)
- (void)computePicrossableTiles:(CCTMXLayer*)sizeMap;
- (void)mappingPicrossMap:(NSArray*)parray startAt:(uint)starter stopAt:(uint)count reversing:(BOOL)isreverse stepjump:(uint)jump;
- (void)startAnalysisTo:(int)startScan forJump:(int)jump intoArray:(NSArray*)picrossList;
@end

@implementation PCMoveTile

@synthesize totalWidth, 
			totalHeight, 
			width, 
			height,
			mapSize, 
			currentCursorPosition, 
			padState;

- (void)newMap:(CCTMXLayer*)mapp{
	CCTMXTiledMap* map		= (CCTMXTiledMap*)[mapp parent];
	currentCursorPosition	= CGPointZero;
	totalWidth				= map.mapSize.width;
	totalHeight				= map.mapSize.height;
	mapSize					= CGPointMake(totalWidth-1, totalHeight-1);
	width					= map.tileSize.width;
	height					= map.tileSize.height;
}

- (void)moveTileInGrid:(CCNode*)tile{
	float x = 0.f;
	float y = 0.f;
	switch (padState) {
		case LEFT:
			if(currentCursorPosition.x > 0){
				x = -width;
				currentCursorPosition.x--;
			}
			break;
		case RIGHT:
			if(currentCursorPosition.x < totalWidth-1){
				x = width;
				currentCursorPosition.x++;
			}
			break;
		case UP:
			if(currentCursorPosition.y < totalHeight-1){
				y = height;
				currentCursorPosition.y++;
			}
			break;
		case DOWN:
			if(currentCursorPosition.y > 0){
				y = -height;
				currentCursorPosition.y--;
			}
			break;
	}
	
	if(x || y)
		tile.position = CGPointMake(tile.position.x + x, tile.position.y + y);
}

- (CGPoint)getTilePosition{
	CGPoint invert = CGPointMake(currentCursorPosition.x, mapSize.y - currentCursorPosition.y);
	return invert;
}

@end
