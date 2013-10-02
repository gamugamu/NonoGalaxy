//
//  CursorView.m
//  UsingTiled
//
//  Created by loïc Abadie on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PCCursorView.h"

@interface PCCursorView()
@end

@implementation PCCursorView
@synthesize matrix;

- (void)setMatrix:(CGRect)matrix_{	
	//compensate symetrie
	matrix_.origin.x += self.contentSize.width/2;
	matrix_.origin.y += self.contentSize.height/2;
	
	self.position						= ccp(matrix_.origin.x, 
											  matrix_.origin.y);
	matrix = matrix_;
}

- (void)newTouchPointIntoMatrice:(CGPoint)pnt{
	self.visible	= YES;
	self.position	= CGPointMake(matrix.origin.x + pnt.x * matrix.size.width,
								  matrix.origin.y + pnt.y * matrix.size.height);
}

- (void)touchPointIntoMatriceEnded{
	self.visible	= NO;
}

- (void)cancelTouchPoint{
	self.visible	= NO;
}
@end
