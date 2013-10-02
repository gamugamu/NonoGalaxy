//
//  PCConstelationMap.h
//  picrossGame
//
//  Created by loïc Abadie on 02/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ProtocolHelpers.h"

@protocol PCConstelationMapDelegate <NSObject>
- (void)stageWasSelected:(uint)stage forConstelation:(NSString*)constelationName;
- (void)goBackFromConstelationPressed;
@end

@interface PCConstelationMap : CCLayer
- (id)initWithDelegate:(id <PCConstelationMapDelegate>)delegate_ andConstelationName:(NSString*)mapName;
- (id)scene;
@end

typedef struct {
	uint done;
	uint total;
}lvlDone_lvlTotal;

@interface PCMicroConstelationMap : CCNode
- (id)initWithButtonDelegate:(id <GGButonPressedDelegate>)delegate_;
- (void)displayBoard:(NSUInteger)idx;
- (void)undisplayBoard;
- (void)reloadData;
- (NSString*)_currentConstelationName;
- (void)animateCompletionConstellation:(void(^)())completion;
- (BOOL)didNeedRequirement;
@property(nonatomic, readonly, assign)BOOL hasUnlockedMap;
@property(nonatomic, readonly, retain)NSString*	_inAppid;
@property(nonatomic, readonly, retain)NSString*	_mapMessage;
@end;