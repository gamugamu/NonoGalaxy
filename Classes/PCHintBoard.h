//
//  PicrossRemainingView.h
//  UsingTiled
//
//  Created by loïc Abadie on 06/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PEngineSubscriber.h"
#import "PCTouchGridProtocol.h"

uint divideUp(uint x, uint y);

@protocol PCHintBoardDelegate <NSObject>
- (void)emptyLineDetected:(picross2dArray)rorOrColumn line:(uint)line;
@end

@interface PCHintBoard : NSObject <PCTouchGridProtocol>
- (id)initWithDelegate:(id<PCHintBoardDelegate>)delegate_ matriceSize:(uint)_mapSize;
- (CCTMXTiledMap*)createBoardForType:(picross2dArray)rowOrColumn imageResolve:(NSDictionary*)imagesResolve resolvePath:(NSString*)path;
- (CCTMXTiledMap*)createMicroBoardForType:(picross2dArray)rowOrColumn;
- (void)reBlackenNumber:(CGPoint)lines;
- (uint*)getHintFootPrintForType:(picross2dArray)rowOrCollum;
//- (void)highlightPosition:(CGPoint)pnt;
//- (void)unHighlightPosition;
- (void)updatePicrossLeft:(NSDictionary*)picrossableInfoList;
- (void)updateMatch:(uint)match forBoard:(picross2dArray)rowOrColumn currentLine:(uint)line;
- (void)updateExceedDisplay:(CGSize)overlay currentPosition:(CGPoint)position;
- (void)realign:(CGPoint)position;
@end
