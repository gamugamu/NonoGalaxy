//
//  PCNameFormater.h
//  picrossGame
//
//  Created by loïc Abadie on 04/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	nonoConstelation = 0,
	nonoStageSet,
	nonoMapDisplay,
	nonoSkin,
	nonoDisplayFolder,
}nonoFileType;

@interface PCNameFormater : NSObject
+ (NSString*)formatConstelationFromIndex:(NSUInteger)idx;//<--- obsolete
+ (NSString*)getNameFromSerialisation:(uint)serialisation forType:(nonoFileType)type;
+ (NSArray*)getNonoFileNameFromSerialisation:(uint)serialisation;
+ (NSString*)getNonoSetFromMapName:(NSString*)mapName;
+ (NSString*)getMapDisplaySetFromMapName:(NSString*)mapName;
+ (NSString*)getSkinNameFromMapName:(NSString*)mapName;
+ (NSUInteger)retrieveIdxFromZipName:(NSString*)name;
+ (NSUInteger)retrieveIdxFromConstellationName:(NSString*)name;
@end
