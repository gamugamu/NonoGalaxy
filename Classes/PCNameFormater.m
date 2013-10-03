//
//  PCNameFormater.m
//  picrossGame
//
//  Created by loïc Abadie on 04/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCNameFormater.h"
#import "GameConfig.h"

@implementation PCNameFormater

+ (NSString*)formatConstelationFromIndex:(NSUInteger)idx{
	return  [NSString stringWithFormat: constelationMutable, idx];
}

+ (NSUInteger)retrieveIdxFromZipName:(NSString*)name{
	NSString* idxName = [name substringWithRange: NSMakeRange(8, 3)]; // 'nonoSet_' name
	return [idxName integerValue];
}

// generate a name from a number
+ (NSString*)getNameFromSerialisation:(uint)serialisation forType:(nonoFileType)type{
	NSString* sserial	= [NSString stringWithFormat:@"%03u", serialisation];
	NSString* name		= nil;
	
	switch (type) {
		case nonoConstelation:
			name = [NSString stringWithFormat:@"%@%@.tmx", FORMATmap, sserial];				break;
		case nonoStageSet:
			name = [NSString stringWithFormat:@"%@%@.tmx", FORMATstages, sserial];			break;
		case nonoMapDisplay:
			name = [NSString stringWithFormat:@"%@%@.png", FORMATmapDisplay, sserial];		break;
		case nonoSkin:
			name = [NSString stringWithFormat:@"%@%@.png", FORMATskin, sserial];			break;
		case nonoDisplayFolder:
			name = [NSString stringWithFormat:@"%@%@", FOLDERstageDisplay, sserial];		break;
        case nonoNumbers:
			name = [NSString stringWithFormat:@"%@%@.png", FORMATIndice, sserial];              break;
	}
	
	return name;
}

// return all the sets from a number
+ (NSArray*)getNonoFileNameFromSerialisation:(uint)serialisation{
	NSMutableArray* allName = [NSMutableArray arrayWithCapacity: 4];
	
	for (int i = 0; i <= nonoSkin; i++)
		[allName addObject: [PCNameFormater getNameFromSerialisation:serialisation forType: i]];
	
	return allName;
}

// return specific conversion
+ (NSString*)getNonoSetFromMapName:(NSString*)mapName{
	mapName = [mapName stringByReplacingOccurrencesOfString: FORMATmap
												 withString: FORMATnonoSet];
	
	return [mapName stringByReplacingOccurrencesOfString: @"tmx" withString: @"zip"];
}


// return all the sets from a number
+ (NSString*)getMapDisplaySetFromMapName:(NSString*)mapName{
	mapName = [mapName stringByReplacingOccurrencesOfString: FORMATmap
												 withString: FORMATIndice];
	
	return [mapName stringByReplacingOccurrencesOfString: @"tmx" withString: @"png"];
}

+ (NSUInteger)retrieveIdxFromConstellationName:(NSString*)mapName{
    mapName = [mapName stringByReplacingOccurrencesOfString: FORMATmap
												 withString: @""];
	
	return [mapName intValue];
}

+ (NSString*)getIndiceDisplaySetFromMapName:(NSString*)mapName{
	mapName = [mapName stringByReplacingOccurrencesOfString: FORMATmap
												 withString: FORMATmapDisplay];
	
	return [mapName stringByReplacingOccurrencesOfString: @"tmx" withString: @"png"];
}

+ (NSString*)getSkinNameFromMapName:(NSString*)mapName{
	mapName = [mapName stringByReplacingOccurrencesOfString: FORMATmap
												 withString: FORMATskin];
	return mapName;
}
@end
