//
//  PEngine.h
//  UsingTiled
//
//  Created by loïc Abadie on 06/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "buttonPad.h"
#import "PCScannerMap.h"

@protocol PEngineSubscriber<PCScannerDelegate>
@end

@protocol PEngine <NSObject>
- (void)setPicrossDelegate:(id <PEngineSubscriber>)delegate;
- (void)newStage:(CCTMXLayer*)map;
- (BOOL)isPicrossable:(CGPoint)position;
- (void)hasPicrossedTo:(CGPoint)position forState:(picrossState)state;
@end