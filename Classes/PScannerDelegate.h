//
//  PScannerDelegate.h
//  picrossGame
//
//  Created by loïc Abadie on 26/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCScannerDelegate

#define PICROSSCOLUMN @"picrosscolumn"
#define PICROSSROW @"picrossRow"
typedef enum {
	PICUNCROSSED,
	PICCROSSED,
	PICFILLED,
	PICUNFILLED,
	PICERROR
}picrossState;

typedef enum {
	PICROW = 0,
	PICCOLUMN,
}picross2dArray;

- (void)analyseWillStart:(CGPoint)pnt;
- (void)allPicrossAreMatching;
- (void)currentPercentProgress:(float)progress;
- (void)updatePicrossLeft:(NSDictionary*)PicrossableInfoList;
- (void)updateMatch:(uint)match forMode:(picross2dArray)rowOrColumn currentLine:(uint)line;
@end