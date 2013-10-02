//
//  TempMovesEngine.h
//  picrossGame
//
//  Created by loïc Abadie on 29/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TempMovesEngineDelegate.h"

@interface PCTempMovesEngine : NSObject
- (CGPoint)positionLocked:(CGPoint)tmpPnt isOrigin:(BOOL)isOrigin;
- (void)executeMove:(BOOL (^)(CGPoint, BOOL)) updateBlock;
- (void)cancel;
@property(nonatomic, assign) id <TempMovesEngineDelegate>	delegate;
@property(nonatomic, readonly) BOOL		isExecuting;	// when the state is on and executing.
@property(nonatomic, readonly) BOOL		isOn;			// when the state machine is on
@property(nonatomic, assign)float		timePerUpdate;	// fréquence à laquelle l'update de l'appel se fait auprès du delegate.
@property(nonatomic, retain, readonly) CCArray*	_tmpMove;
@property(nonatomic, assign, readonly) CGPoint genuineCurrentPosition;
@end
