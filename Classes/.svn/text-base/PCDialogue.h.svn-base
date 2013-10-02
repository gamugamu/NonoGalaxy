//
//  PCDialogue.h
//  picrossGame
//
//  Created by loïc Abadie on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PadButtons.h"
#import "cocos2d.h"
#import "PCNonoDisplay.h"

typedef enum{
	wasNoDisplay	= 0,
	wasInTouch		= 1,
	wasInMoving		= 2
}lastDisplayState;

@protocol GCDialogueDelegate
- (void)askUndo;
- (void)askNext;
- (BOOL)hasNext;
- (BOOL)hasBack;
@end

@interface PCDialogue : CCNode
- (id)initWithDelegate:(id <GCDialogueDelegate>)delegate_ andMrNono:(PCNonoDisplay*)mrNono_;
- (void)dialogue:(NSString*)dialogueText;
- (void)displayTutoImage:(uint)tutoImage;
- (void)displaySequencesImage:(NSArray*)images;
- (void)hideNext:(BOOL)needHide;
- (void)hidePrevious:(BOOL)needHide;
@end

@interface PCStateDialogue : NSObject
- (void)distroyActions;
@property(nonatomic, retain)NSString*			_stateDialogue;
@property(nonatomic, retain)CCArray*			_actions;
@property(nonatomic, assign)uint				stateEvent;
@property(nonatomic, assign)buttonType			stateButton;
@property(nonatomic, assign)BOOL				isUndoIsForced;
@property(nonatomic, assign)lastDisplayState	stateDisplay;
@end