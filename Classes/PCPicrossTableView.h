//
//  PCPicrossesDBGalaxyHelper.h
//  picrossGame
//
//  Created by loïc Abadie on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@protocol PCPicrossesDBGalaxyHelperDelegate <NSObject>
- (void)galaxyOnList:(NSUInteger)idx;
- (void)galaxiesRowing;
@end

@interface PCPicrossTableView : CCNode
- (id)initWithDelegate:(id <PCPicrossesDBGalaxyHelperDelegate>)delegate_;
- (void)selectCell:(NSUInteger)idx needAnimate:(BOOL)isAnimating;
- (void)askCurrentGalaxyOnList;
- (void)updateTable;
- (void)setIsAllowingToRow:(BOOL)isAllowing;
- (BOOL)isAllowingToRow;
@property(nonatomic, assign, readonly)NSUInteger numberOfCells;
@end
