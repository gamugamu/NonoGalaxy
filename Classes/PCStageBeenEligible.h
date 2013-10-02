//
//  PCStageBeenEligible.h
//  picrossGame
//
//  Created by loïc Abadie on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PCStageBeenEligible : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * mapName;

@end
