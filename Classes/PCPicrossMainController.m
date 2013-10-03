//
//  PicrossController.m
//  UsingTiled
//
//  Created by loïc Abadie on 05/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossMainController.h"
#import "PCPicrossGalaxyMenu.h"
#import "PCConstelationMap.h"
#import "PCPicrossGameFactory.h"
#import "PCLoader.h"
#import "PCHomePage.h"
#import "GCMusicController.h"
#import "GCTransition.h"
#import "GameConfig.h"
#import "GGRateMe.h"

#import "GGPrivateDoc.h"

@interface PCPicrossMainController()<GCMusicControllerDelegate, PCPicrossGameDelegate, PCConstelationMapDelegate, PCPicrossGalaxyMenuDelegate> 
- (void)startUpScene;
- (void)eagleContext;
- (void)changeSceneAsync:(SEL)selector withParams:(NSArray*)params;
@property(nonatomic, retain)GCMusicController*	_musicController;
@property(nonatomic, retain)CCScene*			_currentScene;
@property(nonatomic, retain)NSArray*			_currentParams;
@property(nonatomic, assign)SEL					callFunc;
@property(nonatomic, assign)BOOL				isMusicAvailable;
@end

NSLock *lock;
@implementation PCPicrossMainController
@synthesize isMusicAvailable,
			callFunc,
			_currentParams,
            _currentScene,
			_musicController;
 
#pragma mark private
#pragma mark changeScene
- (void)startUpScene{
	[[CCDirector sharedDirector] setProjection:CCDirectorProjection2D];
	CCScene* startScene = [[CCScene alloc] init];
	[[CCDirector sharedDirector] runWithScene: startScene];
	[startScene release];
    
#if (!PCDEBUG_DISABLESOUND)
	if([GCMusicController sharedManager].state == kGSOkay){
#endif
    
#if IS_SERVER_MODE == 1
    [self changeSceneAsync: @selector(homeScene)	withParams: nil];
#else
    [self changeSceneAsync: @selector(galaxiesScene) withParams: nil];
    // [self changeSceneAsync:@selector(constelationScene:)	withParams: [NSArray arrayWithObjects: @"constelation_006.tmx", nil]];
    // [self changeSceneAsync:@selector(stageScene:)			withParams: [NSArray arrayWithObjects: @"constelation_005.tmx", [NSNumber numberWithInt: 15], nil]];
#endif
   
#if (!PCDEBUG_DISABLESOUND)
    }
#endif
}

- (void)galaxiesScene{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[self eagleContext];
    [[GCMusicController sharedManager] changeAmbience: ambianceWorldSelect withFade: NO];
	PCPicrossGalaxyMenu* picrossGalaxy	= [[PCPicrossGalaxyMenu alloc] initWithGalaxyDelegate: self];

	[self loadScene: [picrossGalaxy scene]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GGRateMe displayReviewMe: nil];
    });
    
	[picrossGalaxy	release];
	[pool			release];
}

static BOOL wasBeforInStageScene = NO;

- (void)homeScene{
	NSAutoreleasePool* pool		= [[NSAutoreleasePool alloc] init];
    [self eagleContext];
	PCHomePage* homePage        = [PCHomePage new];

    [homePage displayButton:^() {
        if(callFunc == @selector(galaxiesScene))
            return;
        
        callFunc = @selector(galaxiesScene);
        [self callLoaderOnTransitionEnd: nil];
    }];
    
    [[GCMusicController sharedManager] changeAmbience: ambianceIntoIntro withFade: NO];
    [self loadScene: [homePage scene]];

    [homePage release];
	[pool release];
}

- (void)constelationScene:(NSArray*)params{
    if([PCPicrossGalaxyMenu needToShowConstelationCompletion]){
        [self galaxiesScene];
        return;
    }
    
	NSAutoreleasePool* pool				= [[NSAutoreleasePool alloc] init];
	[self eagleContext];
	PCConstelationMap* constelationMap	= [[PCConstelationMap alloc] initWithDelegate: (id <PCConstelationMapDelegate>)self 
																  andConstelationName: [params objectAtIndex: 0]];

	
	if(wasBeforInStageScene){
		[constelationMap addChild: [GCTransition transitionWithCallBack:^(){
					wasBeforInStageScene	= NO;
			CCNode* trans					= [constelationMap getChildByTag: 150];
			[constelationMap removeChild: trans cleanup: YES];
            
#if (!PCDEBUG_DISABLESOUND)    
            [[GCMusicController sharedManager] changeAmbience: ambianceStageSelect withFade: NO];
#endif

		} isReverse: YES] z: 150 tag: 150];
	}
	[self loadScene: [constelationMap scene]];

	[constelationMap	release];
	[pool				release];
}

- (void)stageScene:(NSArray*)params{
	NSAutoreleasePool* pool				= [[NSAutoreleasePool alloc] init];
	[self eagleContext];
	
	NSString* currentMap				= [params objectAtIndex: 0];
	uint currentStageSelected			= [[params objectAtIndex: 1] unsignedIntValue];
	PCPicrossGame*		picrossGame		= [PCPicrossGameFactory returnedRetainedPicrossGame: currentMap
																			forStage: currentStageSelected 
																		withDelegate: self];
    
	[picrossGame addChild: [GCTransition transitionWithCallBack:^(){
		CCNode* trans = [picrossGame getChildByTag: 150];
		[picrossGame removeChild: trans cleanup: YES];

#if (!PCDEBUG_DISABLESOUND)
		[[GCMusicController sharedManager] changeAmbience: ambiancePlayingPicross withFade: NO];
#endif
    } isReverse: YES] z: 150 tag: 150];
	
	[self loadScene: [picrossGame scene]];

	[picrossGame	release];
	[pool			release];
}

- (void)callLoaderOnTransitionEnd:(void(^)())onTransitionDone{
    const float sceneDuration = .5f;
	PCLoader* loader = [[PCLoader alloc] initWithLoaderDelegate: self
                                      callBackWhenLoadingIsDone:^{
                                          NSLog(@"loader Done %@", onTransitionDone);
                                          if(onTransitionDone)
                                              onTransitionDone();
                                      }];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration: sceneDuration scene: [loader scene]]];
    
	[loader release];
}

- (void)loadScene:(CCScene*)scene{
	_currentScene = scene;
	[[CCDirector sharedDirector] replaceScene: scene];
}

#pragma mark logic

- (void)changeSceneAsync:(SEL)selector withParams:(NSArray*)params{
	NSInvocationOperation* sceneLoadOp	= [[[NSInvocationOperation alloc] initWithTarget:self selector: selector object: params] autorelease];
	NSOperationQueue *opQ				= [[[NSOperationQueue alloc] init] autorelease]; 
    [opQ addOperation: sceneLoadOp];
}

- (void)eagleContext{
	EAGLContext *k_context = [[[EAGLContext alloc]
                               initWithAPI: kEAGLRenderingAPIOpenGLES1
                               sharegroup: [[[[CCDirector sharedDirector] openGLView] context] sharegroup]] autorelease];    
    [EAGLContext setCurrentContext:k_context];
}

#pragma mark musicDelegate

- (void)musicEngineIsInitialised{
	isMusicAvailable = YES;
	
	[self changeSceneAsync:@selector(galaxiesScene)		withParams: nil];
}

#pragma mark PCPicrossGalaxyMenuDelegate

- (void)backPressed{
    if(callFunc == @selector(homeScene))
        return;
    
    callFunc = @selector(homeScene);
    [[GCMusicController sharedManager] changeAmbience: ambianceIntoIntro withFade: NO];
    [self callLoaderOnTransitionEnd: nil];
}

#pragma mark - PCLoaderDelegate
- (void)loadingPageIsSet{
    NSLog(@"change %@", _currentParams);
	[self changeSceneAsync: callFunc withParams: _currentParams];
}

- (void)constelationHasBeenSelected:(NSString*)constelationName{
	callFunc = @selector(constelationScene:);
	[self set_currentParams: [NSArray arrayWithObjects: constelationName, nil]];

    [[GCMusicController sharedManager] changeAmbience: ambianceNone withFade: YES];

	[self callLoaderOnTransitionEnd: ^(){
        // on fait un petit décalage, sinon on a l'impression que la music viens avant
        // la scene
        [self performSelector: @selector(playMusicWithDelay) withObject: nil afterDelay: .5f];
    }];
}

- (void)playMusicWithDelay{
    [[GCMusicController sharedManager] changeAmbience: ambianceStageSelect withFade: NO];
}

#pragma mark PCConstelationMapDelegate

- (void)stageWasSelected:(uint)stage forConstelation:(NSString*)constelationName{
	callFunc = @selector(stageScene:);
	[self set_currentParams: [NSArray arrayWithObjects: constelationName, [NSNumber numberWithInt: stage], nil]];

    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDTRANSUP];
	[_currentScene addChild: [GCTransition transitionWithCallBack:^(){
        
#if (!PCDEBUG_DISABLESOUND)
		[[GCMusicController sharedManager] changeAmbience: ambianceNone withFade: YES];
#endif
		[self callLoaderOnTransitionEnd: nil];
	} isReverse: NO] z: 150 tag: 0];
}

- (void)goBackFromConstelationPressed{
	callFunc = @selector(galaxiesScene);

	[self set_currentParams: nil];
	[self callLoaderOnTransitionEnd: nil];
}

#pragma mark PCPicrossGameDelegate

- (void)stageWillExit{
    [[NSNotificationCenter defaultCenter] postNotificationName: KSOUNDNOTIF object: SOUNDTRANSUP];
}

- (void)stageExit:(NSString*)mapName{
	callFunc				= @selector(constelationScene:);
	wasBeforInStageScene	= YES;
	[self set_currentParams: [NSArray arrayWithObjects: mapName, nil]];
	
#if (!PCDEBUG_DISABLESOUND)
    [[GCMusicController sharedManager] changeAmbience: ambianceNone withFade: YES];
#endif
    
	[self callLoaderOnTransitionEnd: nil];
}

#pragma mark alloc/Dealloc
- (id)init{
	if(self = [super init]){
		lock = [[NSLock alloc] init];
#if (!PCDEBUG_DISABLESOUND)
		[[GCMusicController sharedManager] setDelegate: self];
#endif
		[self startUpScene];
	}
	return self;
}

- (void)dealloc{
	[_currentParams		release];
	[_currentScene		release];
	[_musicController	release];
	[super				dealloc];
}
@end
