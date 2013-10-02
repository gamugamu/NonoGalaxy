//
//  HelloWorldLayer.h
//  UsingTiled
//
//  Created by loïc Abadie on 03/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "cocos2d.h"
#import "PEngineSubscriber.h"
#import "SquareJoystick.h"
#import "PicrossPad.h"

@protocol PCPicrossGameDelegate <NSObject>
- (void)stageWillExit;
- (void)stageExit:(NSString*)mapName;
@end

@interface PCPicrossGame : CCLayer <buttonPadDelegate, squarePadDelegate>{
}

- (id)scene;
- (id)initWithEngine:(id <PEngine>)engine andDelegate:(id <PCPicrossGameDelegate>)delegate_;
- (void)StageWasSelected:(uint)stage forConstelation:(NSString*)constelationName;
@end
