//
//  PCPicrossGalaxy.m
//  picrossGame
//
//  Created by loïc Abadie on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossGalaxy.h"

@implementation PCPicrossGalaxy

#pragma mark animationTransition
- (void)startAnimating{
	[_mapsTable runAction: [CCSpawn actions:	[CCFadeIn actionWithDuration: 1], 
							[CCEaseBackInOut actionWithAction:  [CCMoveTo actionWithDuration: 1 position:ccp(0, 0)]], nil]];
	[_MrNono	runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1], 
							[CCSpawn actions: [CCFadeIn actionWithDuration: .9f], [CCEaseBackInOut actionWithAction: [CCScaleTo actionWithDuration: .5f scale: 1] ], nil],
							[CCCallBlockN actionWithBlock: BCA(^(CCNode *n){ [self startInput];})], nil]];															   
}
@end
