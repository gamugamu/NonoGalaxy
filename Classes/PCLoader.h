//
//  PCLoader.h
//  picrossGame
//
//  Created by loïc Abadie on 22/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface PCLoader : CCLayer
- (id)scene;
- (id)initWithLoaderDelegate:(id)delegate callBackWhenLoadingIsDone:(void(^)())loadingDone;
@end
