//
//  ProtocolHelpers.h
//  picrossGame
//
//  Created by loïc Abadie on 02/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GGButonPressedDelegate <NSObject>
- (void)buttonHasBeenPressed:(id)sender;
@optional
- (BOOL)didMapShouldStay;
@end
