//
//  PCConstelationEngine.h
//  picrossGame
//
//  Created by loïc Abadie on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
	unknow,
	accessible,
	notAccessible,
}typeAccessNode;

typedef struct{
	CGPoint startPnt;
	CGPoint endPnt;
	int	Xdotedmargin;
	int	Ydotedmargin;
}vertices;

@interface PCNodes : NSObject
@property (nonatomic, assign)CGPoint	pnt;
@property (nonatomic, assign)float		cost;
@property (nonatomic, assign)PCNodes*	smallestNeighboor;
+ (id)node:(CGPoint)pnt;
- (void)reinitValue;
- (id)initWithPnt:(CGPoint)pnt_;
@end

@interface PCConstelationMapEngine : NSObject{
	CGSize mapSize;
}
- (void)computeMutableItinerary:(CCTMXLayer*)linker mapSize:(CGSize)mapSize_ itinerary:(vertices**)vertices_ verticesLenght:(uint*)lenght_ mapDotSegment:(uint)mapDots_;
- (void)computeAllTheItinerary:(vertices**)vertices_ verticesLenght:(uint*)lenght_ mapDotSegment:(uint)madDots;
- (void)computeItinerary:(vertices**)vertices_ verticesLenght:(uint*)lenght_ mapDotSegment:(uint)madDots forPath:(NSArray*)path;
- (void)pathfinder:(CGPoint)spnt endPoint:(CGPoint)ePnt returnedPath:(CGPoint**)rpath length:(uint*)lenght;
- (void)filterPathfinder:(NSSet*)removePath;
- (void)pathfindAccessibleNodes:(NSSet*)nodeAccessible inaccessible:(NSSet*)nodeInaccessible returnedAccessSet:(NSArray**)raccess returnedInaccessSet:(NSArray**)rinaccess;
+ (id)engineWithConstelationName:(NSString*)name mapSize:(CGSize)mapSize linker:(CCTMXLayer*)linker;
- (id)initWithConstelationName:(NSString*)name mapSize:(CGSize)mapSize linker:(CCTMXLayer*)linker;
@end
