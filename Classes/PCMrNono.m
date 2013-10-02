//
//  PCMrNono.m
//  picrossGame
//
//  Created by loïc Abadie on 31/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCMrNono.h"
#import "CCLabelBMFontMultiline.h"
#import "GGPrivateDoc.h"


#define Key_Position    @"K_Pstin"
#define Key_MapName     @"K_MpNme"

@interface PCMrNono()
@property(nonatomic, retain)PCBubble*				_bubbleLogic;
@property(nonatomic, retain)PCNonoDisplay*			_nonoDisplay;
@property(nonatomic, retain)NSString*               currentMapName;
@end
	
@implementation PCMrNono
@synthesize delegate,
			_bubbleLogic,
			_nonoDisplay,
            currentMapName   = _currentMapName;

@synthesize currentPosition;

#pragma mark public

- (void)changeAppearance:(nonoStyle)nonoStyle bubbleStyle:(bubbleStyle)bubbleStyle{
	[_nonoDisplay changeNonoStyle: nonoStyle];
	[_bubbleLogic changeBubbleStyle: bubbleStyle];
}

- (void)talk:(NSArray*)messages{
	[_bubbleLogic popUpBubbleWithMessages: messages];
}

- (void)stopTalkin{
	[_bubbleLogic unPopBubble];
}

- (void)setDisplayPosition:(CGPoint)pnt{
	_nonoDisplay.position = pnt;
}

- (CGPoint)displayPosition{
	return _nonoDisplay.position;
}

- (CGPoint)currentPosition{
	return _nonoDisplay.currentPosition;
}

- (void)setCurrentPosition:(CGPoint)currentPosition_{
	[_nonoDisplay setCurrentPosition: currentPosition_];
}

- (void)setIsMoving:(BOOL)isMoving{
	[_nonoDisplay setIsMoving: isMoving];
}

- (BOOL)isMoving{
	return _nonoDisplay.isMoving;
}

- (void)moveToPoints:(CGPoint*)pnt lenght:(uint)lenght matrice:(CGSize)size inverseY:(uint)invertY{
	[_nonoDisplay moveToPoints: pnt lenght: lenght matrice: size inverseY: invertY];
}

- (void)setDelegate:(id<PCMrNonoDelegate>)delegate_{
	_nonoDisplay.delegate = delegate_;
	_bubbleLogic.delegate = delegate_;
}

- (BOOL)canRepositionOnTheSameMap:(NSString*)currentMap{
    BOOL isSameName         = [currentMap isEqualToString: _currentMapName];
    self.currentMapName  = currentMap;
    return isSameName;
}

- (void)savePosition{
    NSString* path              = [[GGPrivateDoc privateDocsDirectory: @"nonoPosition"] stringByAppendingPathComponent: @"aaaaa"];
    NSDictionary* dictionnary   = [NSDictionary dictionaryWithObjectsAndKeys: _currentMapName, Key_MapName, NSStringFromCGPoint(_nonoDisplay.currentPosition), Key_Position, nil];
    [dictionnary writeToFile: path atomically: YES];
}

- (void)restorPosition{
    NSString* path                  = [[GGPrivateDoc privateDocsDirectory: @"nonoPosition"] stringByAppendingPathComponent: @"aaaaa"];
    NSDictionary* dictionnary       = [NSDictionary dictionaryWithContentsOfFile: path];
    self.currentMapName             = [dictionnary valueForKey: Key_MapName];
    _nonoDisplay.currentPosition    =  CGPointFromString([dictionnary valueForKey: Key_Position]);
}

// permet d'informer les phylactères du prix du stage à afficher. Par soucis d'encapsulation, on passe par MRNono.
- (void)informAboutPrice:(float)price{

}

#pragma mark setup

- (void)setUpbubbleLogic{
	self._bubbleLogic = [[[PCBubble alloc] initWithDelegate: delegate] autorelease];
	[self addChild: _bubbleLogic];
}

- (void)setUpNonoDisplay{
	self._nonoDisplay = [[[PCNonoDisplay alloc] initWithDelegate: delegate] autorelease];
	[self addChild: _nonoDisplay];
}

#pragma mark overide

- (void)onExit{
	[self stopAllActions];
    [self savePosition];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"nono.plist"];//<---
	[super onExit];
}

#pragma mark alloc / dealloc

- (id)initWithDelegate:(id<PCMrNonoDelegate>)delegate_ appearance:(nonoStyle)style bubbleAppearance:(bubbleStyle)bubbleStyle{
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"nono.plist"];//<---

	if(self = [super init]){
		delegate = delegate_;
		[self setUpNonoDisplay];
		[self setUpbubbleLogic];
        [self restorPosition];
		[self changeAppearance: style bubbleStyle: bubbleStyle];
	}
	return self;
}

- (void)dealloc{
	[_bubbleLogic			release];
	[_nonoDisplay			release];
	[super					dealloc];
}
@end
