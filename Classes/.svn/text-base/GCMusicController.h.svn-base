//
//  GCMusicController.h
//  picrossGame
//
//  Created by loïc Abadie on 19/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCAmbiance.h"

@protocol GCMusicControllerDelegate
- (void)musicEngineIsInitialised;
@end

typedef enum {
	kGSUninitialised, 
	kGSAudioManagerInitialising,  
	kGSAudioManagerInitialised,
	kGSLoadingSounds,
	kGSOkay,//only use when in this state
	kGSFailed
} tGameSoundState;

@interface GCMusicController : NSObject
+ (GCMusicController*)sharedManager;
- (void)setup;
- (void)changeAmbience:(PCAmbianceSound)ambiance withFade:(BOOL)needFading;
@property(nonatomic, assign)id<GCMusicControllerDelegate> delegate;
@property (nonatomic, readonly)tGameSoundState		state;
@end
