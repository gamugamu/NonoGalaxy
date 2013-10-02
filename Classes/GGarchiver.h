//
//  GGarchiver.h
//  Lover's Day
//
//  Created by loïc Abadie on 14/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GGarchiver : NSObject
+ (void)archivingData:(id)Data withName:(NSString*)name;
+ (id)unarchiveData:(NSString*)path;
@end
