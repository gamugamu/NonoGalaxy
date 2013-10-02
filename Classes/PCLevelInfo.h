//
//  PCLevelInfo.h
//  picrossGame
//
//  Created by loïc Abadie on 28/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PCLevelInfo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * constelationName;
@property (nonatomic, retain) NSNumber * timeElapsed;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSNumber * totalDone;
@end
