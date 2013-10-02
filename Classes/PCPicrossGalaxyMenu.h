//
//  PCPicrossGalaxyMenu.h
//  picrossGame
//
//  Created by loïc Abadie on 01/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@protocol PCPicrossGalaxyMenuDelegate <NSObject>
- (void)constelationHasBeenSelected:(NSString*)constelationName;
- (void)backPressed;
@end

@interface PCPicrossGalaxyMenu : CCLayerGradient
- (id)scene;
- (id)initWithGalaxyDelegate:(id <PCPicrossGalaxyMenuDelegate>)delegate_;
+ (BOOL)needToShowConstelationCompletion;
+ (void)shoulAnimateContelationCompleted;
@end
