//
//  PCPicrossGalaxyMenuHelerp.m
//  picrossGame
//
//  Created by loïc Abadie on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossGalaxyMenuHelper.h"
#import "PCFilesManager.h"
#import "PCNameFormater.h"

@interface PCPicrossGalaxyMenuHelper()
@property(nonatomic, retain)CCNode* inAnimate;
@property(nonatomic, assign)SEL		inAnimateCallBack;
@end

@implementation PCPicrossGalaxyMenuHelper
@synthesize inAnimate			= _inAnimate,
			inAnimateCallBack	= _inAnimateCallBack,
			MrNono				= _MrNono;

#pragma mark =============================== public ====================================
#pragma mark ===========================================================================

#define ktag_newMap 120

- (void)animateNewMapAdded:(NSArray*)newMaps intoNode:(CCNode*)node nodeSelectorWhenDone:(SEL)callBack{
	self.inAnimate			= node;
	self.inAnimateCallBack	= callBack;
	
	// l'image en cours
	CCSprite*	newMap	= [CCSprite node];
	newMap.position		= (CGPoint){100, 100};
	newMap.tag			= ktag_newMap;
	[node addChild: newMap];
	
	[self iterateAnimateNewMap: [newMaps objectEnumerator]];
}

#pragma mark - alloc / dealloc

- (void)dealloc{
	[_MrNono	release];
	[_inAnimate release];
	[super dealloc];
}

#pragma mark =============================== private ====================================
#pragma mark ===========================================================================

- (void)iterateAnimateNewMap:(NSEnumerator*)enumerator {
	CCSprite*		newMap			= (CCSprite*)[_inAnimate getChildByTag: ktag_newMap];
	NSString*		mapName			= [enumerator nextObject];
	PCFilesManager* filemanager		= [PCFilesManager sharedPCFileManager];
	static int		count			= 0;

	if(mapName){
		NSUInteger		newIdx				= [PCNameFormater retrieveIdxFromZipName: mapName];
		NSString*		fileName			= [filemanager getDisplayStageForIdx: newIdx];
		CCTexture2D*	tex					= [[CCTextureCache sharedTextureCache] addImage: fileName];
		NSDictionary*	info				= [filemanager infoFromIndexedMap: newIdx];
		NSString*		keys				= [NSString stringWithFormat:@"Nono_Message_NewMapAdded_%u", (count++)? count % 2 + 1 : 0];
		NSString*		dyMessage			= NSLocalizedString(keys, nil);
		NSString*		message				= [NSString stringWithFormat: @"%@%@", dyMessage, [info valueForKey: @"constelationName"]];
						newMap.texture		= tex;
						newMap.position		= ccp(300, 450);
						newMap.textureRect	= (CGRect){{0,0}, tex.contentSize};
						newMap.opacity		= 0;
						newMap.scale		= .5f;
        
        [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDNONOMOVE];

		[_MrNono changeAppearance: nonoStanding bubbleStyle: messageWithConstelation];
		[_MrNono talk: [NSArray arrayWithObject: message]];
		
		[newMap	runAction:	[CCSequence actions:
							[CCSpawn actions: [CCMoveTo actionWithDuration: .5f position: ccp(400, 350)], [CCFadeIn actionWithDuration: .5f], [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: 1] ], nil],
                            [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){  [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDLOWBLOW];})],
                            [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: 1.2f] ],
                            [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: 1]],
                            [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){  [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDSMALLPOP];})],
							[CCSpawn actions: [CCFadeOut actionWithDuration: .5f], [CCEaseBackInOut actionWithAction: [CCMoveTo actionWithDuration: 1 position: ccp(450, -100)]], [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: .7f]], nil],
                            [CCCallBlockN actionWithBlock: BCA(^(CCNode *n){ [self iterateAnimateNewMap: enumerator];})], nil]];
		
	}else {
        [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDNONOMOVE];
		[_MrNono talk: [NSArray arrayWithObject: NSLocalizedString(@"Nono_Message_NewMapAdded_Done", nil)]];
		[_inAnimate removeChild: newMap cleanup: YES];
		[_inAnimate performSelector: _inAnimateCallBack];
	}
}
#undef ktag_newMap

@end