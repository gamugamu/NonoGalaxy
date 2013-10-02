//
//  PCPicrossGameFactory.m
//  picrossGame
//
//  Created by loïc Abadie on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossGameFactory.h"
#import "PCPicrossEngine.h"
#import "GGTracks.h"

@implementation PCPicrossGameFactory

+ (PCPicrossGame*)returnedRetainedPicrossGame:(NSString*)gameName forStage:(uint)currentStageSelected withDelegate:(id<PCPicrossGameDelegate>)delegate{
	PCPicrossGame* picrossGame		= nil;
	PCPicrossEngine* picrossEngine	= [[PCPicrossEngine alloc] init];
	// check if it's a tutorial case of not. Depending of the case, the class game is not exactly the same
	if([gameName isEqualToString: @"constelation_001.tmx"]){
		switch (currentStageSelected) {
			case 1: picrossGame = [[PCTutorialPicrossGame alloc] initWithEngine: picrossEngine andDelegate: delegate forTutoLesson: tuto_1_basis];
				break;
			case 2: picrossGame = [[PCTutorialPicrossGame alloc] initWithEngine: picrossEngine andDelegate: delegate forTutoLesson: tuto_2_showMove];
				break;
			case 3: picrossGame = [[PCTutorialPicrossGame alloc] initWithEngine: picrossEngine andDelegate: delegate forTutoLesson: tuto_3_10x10];
				break;
			case 4: picrossGame = [[PCTutorialPicrossGame alloc] initWithEngine: picrossEngine andDelegate: delegate forTutoLesson: tuto_4_15x15ShowMove];
				break;
		}
	}
	else
		picrossGame = [[PCPicrossGame alloc] initWithEngine: picrossEngine andDelegate: delegate];
	
	[picrossGame StageWasSelected: currentStageSelected forConstelation: gameName];
    [GGTracks trackStage: gameName stage: currentStageSelected];
    
	[picrossEngine release];
	return picrossGame;
}
@end
