//
//  PCPicrossRequestInApp.h
//  picrossGame
//
//  Created by loïc Abadie on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PCMrNono.h"

@protocol PCRequestInAppDelegate
- (void)requestDone:(BOOL)didBought;
@end

// gére la transition entre galaxieMap, et la transaction vers appStore
@interface PCRequestInApp : CCNode<PCMrNonoDelegate>
- (id)initWithMrNono:(PCMrNono*)mrNono;
- (void)requestInAppMap:(NSString*)mapName currentMapIdx:(NSUInteger)mapIdx;
@property(nonatomic, assign)id <PCRequestInAppDelegate> delegate;
@end
