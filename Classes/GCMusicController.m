//
//  GCMusicController.m
//  picrossGame
//
//  Created by loïc Abadie on 19/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GCMusicController.h"
#import "CDXPropertyModifierAction.h"
#import "SimpleAudioEngine.h" 

struct fadeStyle{
	ccTime fadeTimeTaken;
	ccTime fadeDuration;
	Float32 fadeStartVolume;
	Float32 fadeEndVolume;
}fader;

@interface GCMusicController(){
	CDAudioManager* am;
}

@property (nonatomic, copy)void (^fadeEnd)(void);
@property (nonatomic, assign)tGameSoundState		state;
@property (nonatomic, assign)PCAmbianceSound		currentAmbiance;
@property (nonatomic, assign)PCAmbianceSound		currentIDPlayMusic;
@property (nonatomic, assign)SimpleAudioEngine*		soundEngine;
@property (nonatomic, assign)BOOL					isSetupOn;
- (void)playBackgroundMusic:(PCAmbianceSound)idPlayMusic;
@end

@implementation GCMusicController
@synthesize isSetupOn,
			state,
			currentIDPlayMusic,
			currentAmbiance,
			soundEngine,
			fadeEnd = _fadeEnd,
			delegate;

#pragma mark public	

- (void)changeAmbience:(PCAmbianceSound)ambiance withFade:(BOOL)needFading{
    static BOOL wasFading = NO;

	if(state != kGSLoadingSounds || state != kGSOkay){
		//NSLog(@"!!! Son pas prêt: state != kGSLoadingSounds || state != kGSOkay");
    }
	else{
		switch (ambiance) {
			case ambianceWorldSelect:{
				[soundEngine preloadBackgroundMusic: MUSICWORLD];
				[soundEngine preloadEffect: SOUNDPOP];
                [soundEngine preloadEffect: SOUNDBELL];
				break;
			}
			
			case ambianceStageSelect:{
				[soundEngine preloadBackgroundMusic: MUSICSTAGES];
                [soundEngine preloadEffect: SOUNDNONOMOVE];
                [soundEngine preloadEffect: SOUNDLOWBLOW];
                [soundEngine preloadEffect: SOUNDTRANSUP];
				break;
			}
			
            case ambiancePlayingPicross:{
                [soundEngine preloadBackgroundMusic: MUSICPLAYINGPICROSS];
                [soundEngine preloadBackgroundMusic: MUSICFAILED];
                [soundEngine preloadBackgroundMusic: MUSICWIN];
                [soundEngine preloadEffect: SOUNDTRANSUP];
                [soundEngine preloadEffect: SOUNDSMALLPOP];
                [soundEngine preloadEffect: SOUNDERROR];
                break;
            }
			default:
				break;
		}
	}
	
	currentAmbiance = ambiance;

	if(state == kGSOkay)    
        if(!needFading || ambiance == ambianceNone){
            am.backgroundMusic.volume = SOUNDMAXVOLUME;
            [self playBackgroundMusic: ambiance];
        }
        else
            [self fadeMusic: nil];
    
    wasFading = needFading;
}

- (void)playBackgroundMusic:(PCAmbianceSound)idPlayMusic{
	switch (currentAmbiance) {
        case ambianceNone:{
            [self fadeBackgroundMusicFrom: SOUNDMAXVOLUME to: 0 duration: SOUNDFADEDURATION];
			break;
		}
        
        case ambianceIntoIntro:{
			[am playBackgroundMusic: MUSICINTRO loop: YES];
			break;
		}
		case ambianceWorldSelect:{
			[am playBackgroundMusic: MUSICWORLD loop: YES];
			break;
		}
			
		case ambianceStageSelect:{
			[am playBackgroundMusic: MUSICSTAGES loop: YES];
			break;
		}
            
        case ambiancePlayingPicross:{
            [am playBackgroundMusic: MUSICPLAYINGPICROSS loop: YES];
            break;
        }
            
        case ambiancePicrossFailed:{
            [am playBackgroundMusic: MUSICFAILED loop: NO];
            break;
        }
            
        case ambiancePicrossWin:{
            [am playBackgroundMusic: MUSICWIN loop: NO];
            break;
        }
		default:
			break;
		}
   
}

- (void)playEventToSound:(NSNotification*)notification{    
	[soundEngine playEffect: [notification object]];
}

#pragma mark private

- (void)fadeMusic:(NSString*)musicName{	
	[self fadeBackgroundMusicFrom: SOUNDMAXVOLUME to: 0 duration: SOUNDFADEDURATION];

	self.fadeEnd = ^{
		am.backgroundMusic.volume = 0;
		[self playBackgroundMusic: currentAmbiance];
		[self fadeBackgroundMusicFrom: 0 to: SOUNDMAXVOLUME duration: SOUNDFADEDURATION];
		self.fadeEnd = nil;
	};
}

- (void)fadeBackgroundMusicFrom:(Float32)startVolume to:(Float32)endVolume duration:(ccTime)duration {
	fader.fadeTimeTaken		= 0;
	fader.fadeDuration		= duration;
	fader.fadeStartVolume	= startVolume;
	fader.fadeEndVolume		= endVolume;
	
	[[CCScheduler sharedScheduler] scheduleUpdateForTarget:self priority:1 paused: NO];
}

- (void)update:(ccTime)delta {
	fader.fadeTimeTaken += delta;
	
	CGFloat timeProportion		= fader.fadeTimeTaken / fader.fadeDuration;
	CGFloat newMusicVolume		= fader.fadeStartVolume + (timeProportion * (fader.fadeEndVolume - fader.fadeStartVolume));
	am.backgroundMusic.volume	= newMusicVolume;
	
	if(timeProportion > 1.0){
		am.backgroundMusic.volume	= fader.fadeEndVolume;
		[[CCScheduler sharedScheduler] unscheduleUpdateForTarget:self];
		
		if(_fadeEnd)
			_fadeEnd();
	}
}

- (void)setUpAudioManager {
	state = kGSAudioManagerInitialising;
	
	//Set up the mixer rate for sound engine. This must be done before the audio manager is initialised.
	//For performance Apple recommends having all your samples at the same sample rate and setting the mixer rate to the same value.
	//22050 Hz (CD_SAMPLE_RATE_MID) gives a nice balance between quality, performance and memory usage but you may want to
	//use a higher value for certain applications such as music games.
	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	
	//Initialise audio manager asynchronously as it can take a few seconds
	//The FXPlusMusicIfNoOtherAudio mode will check if the user is playing music and disable background music playback if 
	//that is the case.
	[CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
}

- (void)asynchronousSetup{
	[self setUpAudioManager];
	
	//Wait for the audio manager to initialise
	while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
		[NSThread sleepForTimeInterval:0.1];
	}	
	
	state = kGSAudioManagerInitialised;
	//Note: although we are using SimpleAudioEngine this is built on top of the shared instance of CDAudioManager.
	//Therefore it is safe to access the shared instance of CDAudioManager if necessary.
	CDAudioManager *audioManager = [CDAudioManager sharedManager];
	if (audioManager.soundEngine == nil || audioManager.soundEngine.functioning == NO) {
		//Something has gone wrong - we have no audio
		state = kGSFailed;
	} else {
		
		//If you are using background music you probably want to do this. Basically it makes sure your background music
		//is paused and resumed properly when the application is resigned and resumed. Without it you will find that
		//music you had paused will restart even if you don't want it to or your music will start playing sooner than
		//you want.
		[audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
		state			= kGSLoadingSounds;
		soundEngine		= [SimpleAudioEngine sharedEngine];

		if(currentAmbiance)
			[self changeAmbience: currentAmbiance withFade: YES];
        
		state			= kGSOkay;
	}
	
	[delegate musicEngineIsInitialised];
}	

- (void)setup {
	//Make sure this only runs once
	if(isSetupOn)
		return;
		
	//This code below is just using the NSOperation framework to run the asynchrounousSetup method in another thread.
	//Note: we do not use asynchronous loading to speed up loading, it is done so other things can occur while the loading
	//is happening. For example display a loading screen to the user.
	NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
	NSInvocationOperation *asynchSetupOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(asynchronousSetup) object:nil];
	[queue addOperation:asynchSetupOperation];
    [asynchSetupOperation autorelease];
	isSetupOn = YES;
}

- (SimpleAudioEngine *)soundEngine{
	if (self.state != kGSOkay && self.state != kGSFailed) {
		//The sound engine is still initialising, wait for it to finish up to a max of 10 seconds 
		int waitCount = 0;

		while (self.state != kGSOkay && self.state != kGSFailed && waitCount < 100) {
			[NSThread sleepForTimeInterval:0.1];
			waitCount++;
		}	
	} 
	
	if (self.state == kGSOkay) {
		//We should only use sounds when the state is okay
		return soundEngine;
	} else {
		//State wasn't okay, so we return nil
		return nil;
	}	
	
}	


#pragma mark alloc/dealloc
static GCMusicController *sharedManager = nil;
+ (GCMusicController *)sharedManager{
	@synchronized(self)     {
		if (!sharedManager)
			sharedManager = [[self alloc] init];
		
		return sharedManager;
	}
	return nil;
}

+ (id)alloc{
	@synchronized([GCMusicController class]){
		sharedManager = [super alloc];
		return sharedManager;
	}
	
	return nil;
}



-(id)init {
	if((self = [super init])) {
		soundEngine		= nil;
		state			= kGSUninitialised;
		am				= [CDAudioManager sharedManager];
		
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(playEventToSound:)
													 name: KSOUNDNOTIF
												   object: nil];
    }
	return self;
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

@end
