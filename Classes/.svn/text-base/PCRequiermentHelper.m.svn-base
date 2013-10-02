//
//  PCRequiermentHelper.m
//  picrossGame
//
//  Created by loïc Abadie on 02/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCRequiermentHelper.h"
#import "PCPicrossDataBase.h"
#import "PCRequirmentDone.h"
#import "GGPrivateDoc.h"

@interface PCRequiermentHelper(){
	PCPicrossDataBase*	_dataBase;
	NSDictionary*		_messageRequierment;
	NSArray*			_requirmentsDone;
}
@property(nonatomic, retain)NSArray* requirmentsDone;
@end

@implementation PCRequiermentHelper
@synthesize requirmentsDone = _requirmentsDone;

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark --------------------------------------- public ---------------------------------------#

- (void)requirmentIsAchieved:(NSString*)key{
	// on se sauvegarde que si le requirment n'a jms été fait.
	if(![self didSucceedRequirment: key]){
		[_dataBase saveRequirment: key];
		self.requirmentsDone	= [_dataBase requirmentsDone];
	}
}

- (BOOL)didSucceedRequirment:(NSString*)key{
	for (PCRequirmentDone* requirment in _requirmentsDone) {
		if([requirment.name isEqualToString: key]){
			return YES;
		}
	}
	return NO;
}

- (NSString*)messageForRequirment:(NSString*)key{
	return [_messageRequierment valueForKey: key];
}

#pragma mark - alloc / dealloc

- (id)init{
	if(self = [super init]){
		[self setUpDataBase];
		[self setUpMessagesRequirement];
	}
	return self;
}

- (void)dealloc{
	[_messageRequierment release];
	[super dealloc];
}

#pragma mark --------------------------------------------------------------------------------------#
#pragma mark -------------------------------------- private ---------------------------------------#

- (void)setUpDataBase{
	_dataBase				= [PCPicrossDataBase sharedPCPicrossDataBase];
	self.requirmentsDone	= [_dataBase requirmentsDone];
	[self requirmentIsAchieved: @"chabada"];
}

- (void)setUpMessagesRequirement{	
	NSString* path		= [[NSBundle mainBundle] pathForResource: @"requirementDialogue" ofType: @"plist"];
	_messageRequierment = [[NSDictionary dictionaryWithContentsOfFile: path] retain];
}
@end
