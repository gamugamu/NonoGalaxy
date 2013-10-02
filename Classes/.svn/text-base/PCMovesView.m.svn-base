//
//  MovesView.m
//  picrossGame
//
//  Created by loïc Abadie on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCMovesView.h"
#import "PCStageBoard.h"
#import "GameConfig.h"

@interface PCMovesView()
- (void)moveIntoMatrix:(CGPoint)matrixPt;
@property(nonatomic, assign)CGRect frame;
@property(nonatomic, assign)CGPoint overBoard;
@end

@implementation PCMovesView
@synthesize overBoard,
			frame;

#pragma mark TempMovesEngineDelegate
- (void)updateDone{
	frame = CGRectZero;
}

- (void)updateDisplay:(CGPoint)position lastPoint:(CGPoint)lstPnt{
	float mWidth	= (lstPnt.x - position.x != 0)? (lstPnt.x - position.x) * TILESIZE : TILESIZE;
	float mHeight	= (position.y - lstPnt.y != 0)? (position.y - lstPnt.y) * TILESIZE : TILESIZE;

	if(mWidth < 0){
		position.x++;
		mWidth -= TILESIZE;
	}else if(lstPnt.x - position.x > 0)
		mWidth += TILESIZE;
	
	if(position.y - lstPnt.y > 0)
		mHeight += TILESIZE;
	else if(position.y - lstPnt.y < 0){
		position.y--;
		mHeight -= TILESIZE;
	}
	
	frame = CGRectMake(position.x, position.y, mWidth, mHeight);
	[self moveIntoMatrix: position];
}

- (void)moveIntoMatrix:(CGPoint)matrixPt{
	matrixPt		= invertCoordinateHelper(matrixPt);
	self.position	= CGPointMake(overBoard.x + matrixPt.x * TILESIZE,
								  overBoard.y + matrixPt.y * TILESIZE);
}

- (void)draw{
	glColor4ub(45, 100, 150, 155);
	CGPoint vertices[] = { ccp(0, 0), ccp(0, frame.size.height), ccp(frame.size.width, frame.size.height), ccp(frame.size.width, 0)};
	ccFillPoly(vertices, 4, YES);
}
@end
