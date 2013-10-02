//
//  PCCheckValidityTmx.m
//  picrossGame
//
//  Created by loïc Abadie on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCCheckValidityTmx.h"
#import "GameConfig.h"

#define DEBUGCHECKVALIDITY 1

#ifdef DEBUGCHECKVALIDITY
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

@implementation PCCheckValidityTmx
+ (void)validateMap:(CCTMXTiledMap*)map forStageSet:(CCTMXTiledMap*)stageSets{
	// ------------check what a map should have------------
	// 1] check keys validity 
	NSArray* keys = [[map properties] allKeys];
	NSSet* keyNames = [NSSet setWithObjects: @"comment_fr",  @"comment_en", @"constelationName", @"constelationSize", @"difficulty", nil];

	[keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if(![keyNames containsObject: obj])
			DLog(@"PCCheckValidityTmx Error: keys missings for map. Should have %@ compare %@", [keyNames allObjects], keys);
			
		NSAssert([keyNames containsObject: obj], @"PCCheckValidityTmx Error: keys missings for map. Should have %@", [keyNames allObjects]);
	}];
	
	// layer should not have keys
	CCTMXLayer* layer = nil;
	CCArray* children = [map children];
	CCARRAY_FOREACH(children, layer){
		if([[layer properties] count])
			DLog(@"PCCheckValidityTmx Error: layers in maps should not have keys, please delete %@", [layer properties]);

		NSAssert(![[layer properties] count], @"PCCheckValidityTmx Error: layers in maps should not have keys, please delete %@", [layer properties]);
	}
	
	// 2] should have only 2 layers
	if([[map children] count] != 2)
		DLog(@"PCCheckValidityTmx Error: ther's should be only 2 layers into map, please recheck your tmx file");

	NSAssert(([[map children] count] == 2), @"PCCheckValidityTmx Error: ther's should be only 2 layers into map, please recheck your tmx file");
	
	// 3] if then, check the data layes
	CCTMXLayer* levelLinker = [[map children] objectAtIndex: 0];
	CGSize layerSize		= levelLinker.layerSize;
	
	for (int i = 0; i < layerSize.width; i++) {
		for (int j = 0; j < layerSize.height; j++) {
			uint currentGid = [levelLinker tileGIDAt: (CGPoint){i, j}];
			
			if(!(currentGid == LINKERGID || currentGid == 0))
				DLog(@"PCCheckValidityTmx Error: ther's should only have linkerGid into linkerLayer, please clean it");
			
			NSAssert((currentGid == LINKERGID || currentGid == 0), @"PCCheckValidityTmx Error: ther's should only have linkerGid into linkerLayer, please clean it");
		}
	}
	
	// check the stage gid too
	CCTMXLayer* stageslevel		= [[map children] objectAtIndex: 1];
	CGSize layerSize2			= levelLinker.layerSize;
	NSMutableArray* stageList	= [NSMutableArray array];
	
	// did that match the linkerGid
	for (int i = 0; i < layerSize2.width; i++) {
		for (int j = 0; j < layerSize2.height; j++) {
			uint currentGid = [stageslevel tileGIDAt: (CGPoint){i, j}];
			
			if(currentGid){
				uint gidForLinkerLayer = [levelLinker tileGIDAt: (CGPoint){i, j}];
				if(!(gidForLinkerLayer == LINKERGID))
					DLog(@"PCCheckValidityTmx Error: please check your data: it seems that the stage is not on the linker layer");
				
				NSAssert((gidForLinkerLayer == LINKERGID), @"PCCheckValidityTmx Error: please check your data: it seems that the stage is not on the linker layer");
				[stageList addObject: [NSNumber numberWithUnsignedInt: currentGid]];
			}
		}
	}

	[stageList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return 	[obj1 compare: obj2];
	}];

	// 4] it should have no gap too
	for (int i = 0; i < [stageList count]; i++){
		if(!([[stageList objectAtIndex: i] intValue] == i + 1))
			DLog(@"PCCheckValidityTmx Error: there're s gap into your level layer")
			
		NSAssert(([[stageList objectAtIndex: i] intValue] == i + 1), @"PCCheckValidityTmx Error: there're s gap into your level layer");
	}
	
	// ------------check what a levelSet should have------------
	// 1] levelLayer have to match the total of stages	
	if(!([stageList count] - 1 == [[stageSets children] count]))
		DLog(@"PCCheckValidityTmx Error: your levelLinker doesn't math the stageSet layers, they should have has much layer stage that levellinker ask")

	NSAssert(([stageList count] - 1 == [[stageSets children] count]), @"PCCheckValidityTmx Error: your levelLinker doesn't math the stageSet layers, they should have has much layer stage that levellinker ask");

	// 2] check keys validity
	if([[stageSets properties] count])
		DLog(@"PCCheckValidityTmx Error: layerLevel should not have map properties. Please delete it %@", [stageSets properties])
		
	NSAssert(![[stageSets properties] count], @"PCCheckValidityTmx Error: layerLevel should not have map properties. Please delete it");

	// 3] check keys validity + No lost pixel
	CCTMXLayer* layer2	= nil;
	CCArray* children2	= [stageSets children];

	CCARRAY_FOREACH(children2, layer2){
		NSDictionary* properties	= (NSDictionary*)[layer2 properties];
		NSSet* keyNames				= [NSSet setWithObjects: @"difficulty",  @"matrixSize", nil];
		
		[properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			if(![keyNames containsObject: key])
				DLog(@"PCCheckValidityTmx Error: keys missings for stagelayer. Should have %@", [keyNames allObjects]);
				
			NSAssert([keyNames containsObject: key], @"PCCheckValidityTmx Error: keys missings for stagelayer. Should have %@", [keyNames allObjects]);
			// check lost pixel
			if([key isEqualToString:  @"matrixSize"]){
				int size = [obj intValue];
				
				for (int i = 0; i < PICROSSSIZEMAX; i++) {
					int l = (i > size)? 0 : size;
					for (int j = l; j < PICROSSSIZEMAX; j++) {
						uint currentGid = [layer2 tileGIDAt: (CGPoint){i, j}];
						
						if(!(currentGid == BLANKGIDFORSTAGELAYER))
							DLog(@"PCCheckValidityTmx Error: ther's some pixel lost in your layer, please recheck ur stageSet Tmx")
							
						NSAssert((currentGid == BLANKGIDFORSTAGELAYER), @"PCCheckValidityTmx Error: ther's some pixel lost in your layer, please recheck ur stageSet Tmx");
					}
				}
			}
		}];
	}
}
@end
