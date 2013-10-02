//
//  PCGrid.m
//  picrossGame
//
//  Created by loïc Abadie on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCGrid.h"
#import "GameConfig.h"
@interface PCGrid()
@property(nonatomic, assign)int		szGridDemi;
@property(nonatomic, assign)CGPoint* grids;
@end

@implementation PCGrid
@synthesize szGridDemi,
			grids;


- (void)draw{
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glColor4ub(250, 250, 250, 150);
	glLineWidth(1);
	// remember szGridDemi is half the points
	for (int i = 0; i < szGridDemi; i++){
		uint mv = i * 2;
		ccDrawLine(grids[mv], grids[mv + 1]);
	}
    
    glBlendFunc( CC_BLEND_SRC, CC_BLEND_DST );
}

#pragma mark alloc/dealloc
#define cgpointPerIter 4
- (id)initWithMatrice:(uint)matriceSize{
	if((self = [super init])){
		int gdlght		= matriceSize / SIZEGRIDCUT - 1;
		uint szGrid		= gdlght * 4;
		grids			= calloc(sizeof(CGPoint), szGrid);
		szGridDemi		= gdlght * 2;
		
		uint start	= 0;
		uint end	= TILESIZE * matriceSize;
		
		for(int i = 0; i < gdlght; i++){
			uint jump	= (i + 1) * TILESIZE * SIZEGRIDCUT;
			uint push	= i*cgpointPerIter;
			
			grids[push++]	= (CGPoint){start, jump};	// x starts
			grids[push++]	= (CGPoint){end, jump};		// x ends
			grids[push++]	= (CGPoint){jump, start};	// y starts
			grids[push]		= (CGPoint){jump, end};		// y ends
		}		
	}
	return self;
}

- (void)dealloc{
	free(grids);
	[super dealloc];
}
@end
