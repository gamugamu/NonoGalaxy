//
//  PicrossEngine.m
//  UsingTiled
//
//  Created by loïc Abadie on 05/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "PCPicrossEngine.h"
#import "PCMoveTile.h"
#import "PCScannerMap.h"

@interface PCPicrossEngine()
	@property (nonatomic, retain) PCScannerMap*	_picrossScanner;
@end

@implementation PCPicrossEngine
@synthesize	_picrossScanner;

#pragma mark facade
- (void)newStage:(CCTMXLayer*)map{
	[_picrossScanner newMap:map];
}

- (BOOL)isPicrossable:(CGPoint)position{
	return [_picrossScanner isPicrossable:position];
}

- (void)hasPicrossedTo:(CGPoint)position forState:(picrossState)state{
	if((int)state == -1) return;
	[_picrossScanner hasPicrossedTo:position forState:state];
}

#pragma mark delegate
- (void)setPicrossDelegate:(id<PEngineSubscriber>)delegate{
	[ _picrossScanner setScannerDelegate:(id<PCScannerDelegate>)delegate];
}

#pragma mark alloc/dealloc
- (id)init{
	if(self = [super init]){
		PCScannerMap* picrossScanner = [[PCScannerMap alloc] init];
		[self set_picrossScanner: picrossScanner];
		[picrossScanner release];
	}
	return self;
}

- (void)dealloc{
	[_picrossScanner release];
	[super			dealloc];
}
@end
