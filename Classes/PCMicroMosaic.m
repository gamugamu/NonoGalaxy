//
//  PCMicroMosaic.m
//  picrossGame
//
//  Created by loïc Abadie on 13/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCMicroMosaic.h"
#import "GameConfig.h"
@interface RedSquare : CCNode
@end

@interface PCMicroMosaic()
@property(nonatomic, retain)CCTMXLayer* _microGrid;
@property(nonatomic, assign)uint		microGridSize;
@end

@implementation PCMicroMosaic
@synthesize microGridSize,
			_microGrid;

// this is the view helper, who show the stage in miniSize
#pragma mark public
- (void)updateGrid:(CGPoint)pnt withCrossState:(picrossState)picState{
	(picState == PICFILLED)?	[_microGrid setTileGID:2 at:pnt] :
								[_microGrid	setTileGID:1 at: pnt];
}

- (void)newTouchPointIntoMatrice:(CGPoint)pnt{
}

- (void)updateExceedDisplay:(CGSize)exceed{

}

#pragma mark getter/setter
- (CGSize)contentSize{
	return _microGrid.contentSize;
}

#pragma mark display logic
#define PCMicroMosaicFileName @"microMosaik.tmx"
#define MTAGGrid 0

#define calculSize(sz)(CGPoint){10 -(sz * (3.1 / 2)), 12 -(sz * (3.1 / 2))};

- (void)createGrid:(CGSize)gridSize{
	microGridSize			= gridSize.width * MICROTILESIZE;
	CCTMXTiledMap* layer	= [[CCTMXTiledMap alloc] initWithTMXFile: PCMicroMosaicFileName andMapSize: gridSize];

	[self			set_microGrid:	(CCTMXLayer* )[layer	getChildByTag:0]];
	[_microGrid		fillWithGid: 1];
    
    layer.scale     = .5f;
	layer.position  = calculSize(gridSize.width);
    
    CCSprite* result = [CCSprite spriteWithFile: screenOnMap];
    result.position  = ccp(10, 60);
    [self addChild: result];

#ifdef DEBUGMICRO
    CCColorLayer* taille5 = [CCColorLayer layerWithColor:(ccColor4B){255, 0, 0, 255}
                                                   width: 15
                                                  height: 15];
    taille5.position = calculSize(5);

    CCColorLayer* taille10 = [CCColorLayer layerWithColor:(ccColor4B){0, 255, 0, 255}
                                                   width: 30
                                                  height: 30];
    taille10.position = calculSize(10);
    
    CCColorLayer* taille15 = [CCColorLayer layerWithColor:(ccColor4B){0, 0, 255, 255}
                                                   width: 45
                                                  height: 45];
    
    taille15.position = calculSize(15);
    CCColorLayer* taille20 = [CCColorLayer layerWithColor:(ccColor4B){255, 0, 255, 255}
                                                   width: 60
                                                  height: 60];
    
    taille20.position = calculSize(20);
    
    [self addChild: taille20];
    [self addChild: taille15];
    [self addChild: taille10];
    [self addChild: taille5];
#endif
    
    [self addChild: layer];
	[layer			release];
}

- (void)displayMicroLeftGrid:(CCTMXTiledMap*)mLeftBoard microUpBoard:(CCTMXTiledMap*)mUpBoard{
	CGSize gridSize = [self getChildByTag: MTAGGrid].contentSize;
	
	mUpBoard.position	= (CGPoint){0, (uint)gridSize.height};
	mLeftBoard.position = (CGPoint){-(int)mLeftBoard.contentSize.width, 0};
	[self addChild: mUpBoard];
	[self addChild: mLeftBoard];
}

- (void)displayRedSquare{
}

#pragma mark alloc/dealloc
- (id)initWithGrid:(CGSize)gridSize microLeftBoard:(CCTMXTiledMap*)mLeftBoard microUpBoard:(CCTMXTiledMap*)mUpBoard{
	if((self = [super init])){
		[self createGrid: gridSize];
	}
	
	return self;
}

- (void)dealloc{
	[_microGrid		release];
	[super			dealloc];
}
@end

@implementation RedSquare

- (void)draw{
	glColor4ub(255, 0, 0, 255);
	glLineWidth(1);
	CGPoint vertices[] = { ccp(0,0), ccp(0,ONETOHEIGHTIPADHEIGHT), ccp(ONETOHEIGHTIPADWIDHT, ONETOHEIGHTIPADHEIGHT), ccp(ONETOHEIGHTIPADWIDHT,0)};
	ccDrawPoly( vertices, 4, YES);
}

@end