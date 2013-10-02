//
//  PicrossScanner.h
//  picrossGame
//
//  Created by loïc Abadie on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PScannerDelegate.h"

@interface PCScannerMap : NSObject {
}

- (void)newMap:(CCTMXLayer*)map;
- (BOOL)isPicrossable:(CGPoint)position;
- (void)hasPicrossedTo:(CGPoint)position forState:(picrossState)state;

@property (nonatomic, assign) id<PCScannerDelegate> scannerDelegate;
@end
