//
//  MyClass.m
//  picrossGame
//
//  Created by loïc Abadie on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCConstelationMapEngine.h"
#import "GameConfig.h"

@interface PCConstelationMapEngine()
@property(nonatomic, retain)NSMutableArray*	_neighboorNodes;
@property(nonatomic, retain)NSMutableArray*	_allPathNodes;
@property(nonatomic, assign)vertices*		_itinerary;
@property(nonatomic, assign)CGPoint*		_gridPath;
@property(nonatomic, assign)uint			itineraryLenght;
@end

@implementation PCConstelationMapEngine
@synthesize _itinerary,
			_allPathNodes,
			itineraryLenght,
			_gridPath,
			_neighboorNodes;

- (void)analyseLinks:(CCTMXLayer*)linker{
	[self set_neighboorNodes: [NSMutableArray array]];
	
	for (int j = 0; j < (uint)mapSize.height; j++) 
		for (int i = 0; i < (uint)mapSize.width; i++){
			uint constGid = [linker tileGIDAt:(CGPoint){i, j}];
			
			if(constGid == LINKERGID)
				[_neighboorNodes addObject: [PCNodes node:(CGPoint){i, j}]];
		}
		
	[self set_allPathNodes: [[_neighboorNodes copy] autorelease]];
}

- (void)filterPathfinder:(NSSet*)removePath{	

	for (NSValue* pnt in removePath) {
		[_neighboorNodes filterUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			return !CGPointEqualToPoint(((PCNodes*)evaluatedObject).pnt, [pnt CGPointValue]);
		}]];
	}
}

#define ITINARYTABSIZE 30

#define realignItinirary(pnta, pntb){\
	[xItinerary sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {\
	if(((PCNodes*)obj1).pntb == ((PCNodes*)obj2).pntb)\
		return (((PCNodes*)obj1).pnta < ((PCNodes*)obj2).pnta)? NSOrderedAscending : NSOrderedDescending;\
\
	return (((PCNodes*)obj1).pntb < ((PCNodes*)obj2).pntb)? NSOrderedAscending : NSOrderedDescending;\
	}];\
}\


// (pnta > pntb)? bPnt : aPn -> because we want the point to the lefter side
#define getItinirary(pnta, pntb, Xdotedmargin, Ydotedmargin)\
	isNewVertice	= NO;\
	tmpPnt			= CGPointZero;\
	for (int i = 0; i < last; i++) {\
		CGPoint aPnt = ((PCNodes*)[xItinerary objectAtIndex: i]).pnt;\
		CGPoint bPnt = ((PCNodes*)[xItinerary objectAtIndex: i + 1]).pnt;\
		if (fabsf(pnta - pntb) == 1){\
			if(!isNewVertice){\
				isNewVertice = YES;\
				if(itineraryLenght > ITINARYTABSIZE)\
					_itinerary = realloc(_itinerary, sizeof(vertices) * (ITINARYTABSIZE + itineraryLenght));\
				_itinerary[itineraryLenght] = (vertices){(pnta > pntb)? bPnt : aPnt, CGPointZero, Xdotedmargin, Ydotedmargin};\
			}\
			tmpPnt = bPnt;\
		}else{\
			if(isNewVertice){\
				_itinerary[itineraryLenght] = (vertices){_itinerary[itineraryLenght].startPnt, tmpPnt, Xdotedmargin, Ydotedmargin};\
				itineraryLenght++;\
			}\
			isNewVertice = NO;\
		}\
		if(i == last - 1 && isNewVertice){\
			_itinerary[itineraryLenght] = (vertices){_itinerary[itineraryLenght].startPnt, tmpPnt, Xdotedmargin, Ydotedmargin};\
			itineraryLenght++;\
		}\
}

- (void)computeMutableItinerary:(CCTMXLayer*)linker mapSize:(CGSize)mapSize_ itinerary:(vertices**)vertices_ verticesLenght:(uint*)lenght_ mapDotSegment:(uint)mapDots_{
	mapSize = mapSize_;
	[self analyseLinks: linker];
	[self computeAllTheItinerary: vertices_ verticesLenght: lenght_ mapDotSegment: mapDots_];
}

- (void)computeAllTheItinerary:(vertices**)vertices_ verticesLenght:(uint*)lenght_ mapDotSegment:(uint)madDots{
	[self computeItinerary:vertices_ verticesLenght:lenght_ mapDotSegment:madDots forPath: nil];
}

// used to draw the path, so we optimise getting the smallest segments possible
- (void)computeItinerary:(vertices**)vertices_ verticesLenght:(uint*)lenght_ mapDotSegment:(uint)madDots forPath:(NSArray*)path{
	free(_itinerary);
	_itinerary = NULL;
/*
	if(![path count]){
		*vertices_	= nil,
		*lenght_	= 0;
		return;
	}
*/		
	NSMutableArray* xItinerary	= (path)? [path mutableCopy] : [_allPathNodes mutableCopy];
	
	itineraryLenght				= 0;
	_itinerary					= malloc(sizeof(vertices) * ITINARYTABSIZE);
	BOOL isNewVertice			= NO;
	CGPoint tmpPnt				= CGPointZero;
	uint last					= [xItinerary count]? [xItinerary count] - 1 : 0;

    realignItinirary(pnt.x, pnt.y);	// realign the y value, so it will be simpler get the X vertices
	getItinirary(aPnt.x, bPnt.x, madDots, 0);	// get x vertices
	realignItinirary(pnt.y, pnt.x);	// realign the x value
	getItinirary(aPnt.y, bPnt.y, 0, -madDots);	// get y vertices
 
	_itinerary	= realloc(_itinerary, sizeof(vertices) * itineraryLenght);	// adjusting the data, don't waste o
	*vertices_	= _itinerary;
	*lenght_	= itineraryLenght;

	[xItinerary release];
}
//(sPnt.x == cPnt.x || sPnt.y == cPnt.y ) && (fabsf(sPnt.x - cPnt.x) == 1 || fabsf(sPnt.y - cPnt.y) == 1)
// [if(currentAccess != unknow)] so it's an access or notAccessible state
#define compareAccess(){\
	NSValue* aPntObject		= [NSValue valueWithCGPoint: farestNode.pnt];\
	if([pointAccessible containsObject: aPntObject]){\
		if(currentAccess == notAccessible){\
			CGPoint cPnt	= farestNode.pnt;\
			if(fabs(cPnt.x - lPnt.x) == 1 || fabs(cPnt.y - lPnt.y) == 1){\
				[nodeInaccessibles addObject: farestNode];\
            }\
		}\
		if(currentAccess != accessible){\
			currentAccess = accessible;\
		}\
	}\
	else if([pointInaccessible containsObject: aPntObject]){\
		if(currentAccess == accessible){\
		}\
		if(currentAccess != notAccessible){\
			currentAccess = notAccessible;\
        }\
    }\
    else{\
        currentAccess = unknow;\
        [unknowAccess addObject: farestNode];\
    }\
\
	lPnt = farestNode.pnt;\
        (currentAccess == accessible)? [nodeAccessibles addObject: farestNode] : [nodeInaccessibles addObject: farestNode];\
}


// used to separate what's walkable, what's not walkable
- (void)pathfindAccessibleNodes:(NSSet*)pointAccessible inaccessible:(NSSet*)pointInaccessible returnedAccessSet:(NSArray**)raccess returnedInaccessSet:(NSArray**)rinaccess{
	// 1] we MUST start with a node Pnt; so that we're not in between two nodes
	[self pathfinder: [[pointAccessible anyObject] CGPointValue]
			endPoint: ((PCNodes*)[_neighboorNodes objectAtIndex: 1]).pnt 
		returnedPath: nil 
			  length: nil];
		
	NSMutableSet*	nodeAccessibles		= [NSMutableSet set];
	NSMutableSet*	nodeInaccessibles	= [NSMutableSet set];
    NSMutableSet*	unknowAccess        = [NSMutableSet set];
    
	typeAccessNode	currentAccess	= unknow;
	NSMutableArray* enumerateList	= [_neighboorNodes mutableCopy];

	[enumerateList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return ((PCNodes*)obj1).cost < ((PCNodes*)obj2).cost;
	}];
	
	// NSLog(@"pathfindAllTheNodes, get neighboor %@", enumerateList);
	// at 0 we get the greatest cost node
	PCNodes* farestNode = nil;
	CGPoint lPnt		= CGPointZero;

	while ([enumerateList count]) {
		farestNode = [enumerateList objectAtIndex: 0];
		[enumerateList removeObject: farestNode];
		compareAccess();
		
		while (farestNode.smallestNeighboor) {
			farestNode			= farestNode.smallestNeighboor;
			compareAccess();
			
			if(![enumerateList containsObject: farestNode]){
				break;
			}
			else
				[enumerateList removeObject: farestNode];
		}
	}

	// (currentAccess == accessible)? NSLog(@"*****************-") : NSLog(@"-----------------*");
	// 1] clean
	[enumerateList		release];
	
	// 2] here we try to get all the neighboorsclose to them done
	NSMutableSet* interSectNeighboor	= [nodeAccessibles mutableCopy];
	NSMutableArray* closestNotDone		= [[nodeInaccessibles allObjects] mutableCopy];

   // [interSectNeighboor filterUsingPredicate: [NSPredicate predicateWithFormat:@"cost < 2"]];

	// NSLog(@"get Green %@, red %@", *raccess, *rinaccess);
	[interSectNeighboor intersectSet: nodeInaccessibles];
    
	[closestNotDone sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return ((PCNodes*)obj1).cost < ((PCNodes*)obj2).cost;
	}];
	
	NSMutableSet* tmpNeighboor          = [[NSMutableSet alloc] init];
	NSMutableSet* unknowNodesToRemove   = [NSMutableSet set];
    NSMutableSet* nodeU                 = [NSMutableSet set];

	// this algorythme take all branches and go bask to the root (where the intersect is).
	// if a level node is found we keep his reference for later, so when we are back to the root
	// we always have the last closest levelNeighboor to the root.
	// Because we made a sort to have the biggest cost to the smallest, we're sure that all branches are evaluated
    for (PCNodes* nodes in unknowAccess) {
        NSValue* nodeAvailable = nil;
        for(int i = 0; i < 4; i++){
            static CGPoint matrice[] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
            NSValue* valueInte = [NSValue valueWithCGPoint: (CGPoint){nodes.pnt.x + matrice[i].x , nodes.pnt.y + matrice[i].y}];
            if([pointAccessible containsObject: valueInte]){
                nodeAvailable = valueInte;
                break;
            }
        }if(nodeAvailable){
            for(int i = 0; i < 4; i++){
                static CGPoint matrice[] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
                NSValue* valueInte = [NSValue valueWithCGPoint: (CGPoint){nodes.pnt.x + matrice[i].x , nodes.pnt.y + matrice[i].y}];
                if([pointAccessible containsObject: valueInte] || [pointInaccessible containsObject: valueInte]){
                    uint lenght = 0;

                    [self pathfinder: [valueInte CGPointValue]
                            endPoint: [nodeAvailable CGPointValue]
                        returnedPath: nil
                              length: &lenght];

                    if(lenght){
                        [nodeInaccessibles removeObject: nodes];
                        [nodeAccessibles addObject: nodes];
                        
                        CGPoint valueIntePnt    = [valueInte CGPointValue];
                        
                        NSPredicate * predicate = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
                            return ((CGPoint)[obj pnt]).x == valueIntePnt.x && ((CGPoint)[obj pnt]).y == valueIntePnt.y;
                        }];
                        
                        NSSet* result = [nodeInaccessibles filteredSetUsingPredicate: predicate];
                        
                       // if(!result.count)
                         //   result = [nodeAccessibles filteredSetUsingPredicate: predicate];
                       
                        if(result.count){
                            PCNodes* nodeR = [result anyObject];
                            NSLog(@"*---> %@", nodeR);
                            //
                            [nodeU addObject: nodeR];
                            [nodeAccessibles addObject: nodeR];
                        }
                    }
                }
            }
        }else{
            [unknowNodesToRemove addObject: nodes];
        }
    }

    
    //[nodeAccessibles minusSet: unknowAccess];
    
    // on réevalue toute les nodes intermédiares, et on détermine si on est accessible
    // ou pas.
	while ([closestNotDone count] > [interSectNeighboor count]) {
		farestNode = [closestNotDone objectAtIndex: 0];
		[closestNotDone removeObject: farestNode];
		
		while (farestNode.cost) {			
			// is in the intersect?

			if([interSectNeighboor containsObject: farestNode.smallestNeighboor]){
				//NSLog(@" intersect %@", farestNode);
								
				[closestNotDone removeObject: farestNode];
				[tmpNeighboor	addObject: farestNode];
               // NSLog(@"** ---> add %@", farestNode);

				__block uint linked = 0;
				
				[tmpNeighboor enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
					if([pointInaccessible containsObject: [NSValue valueWithCGPoint: ((PCNodes*)obj).pnt]])
						linked++;
				}];
				
				// because it's several level neighboor close connected
				if(linked >= 1){
					[tmpNeighboor removeAllObjects];
					[tmpNeighboor addObject: farestNode];
				}

				// ajust the data
				[nodeAccessibles	unionSet: tmpNeighboor];
				// clean then
				[tmpNeighboor	removeAllObjects];
				
				farestNode	= [closestNotDone objectAtIndex: 0];				
				continue;
			}
			
			// we touched another neighboorNode, but not the intersect
			else if([pointInaccessible containsObject: [NSValue valueWithCGPoint: farestNode.pnt]]){
				// clean before adding new list
				[tmpNeighboor removeAllObjects];
				[tmpNeighboor addObject: farestNode];
			}
			else{
				[tmpNeighboor addObject: farestNode];
			}
			[closestNotDone removeObject: farestNode];
			farestNode	= farestNode.smallestNeighboor;
		}	
	}
	
	// 2] clean
	[interSectNeighboor	release];
	[closestNotDone		release];
	[tmpNeighboor		release];

	[nodeInaccessibles	minusSet: nodeAccessibles];
	tmpNeighboor = [[NSMutableSet alloc] init];
	
	// 3] finally repath the inaccessibles node, finding the connex node to accessbilles nodes - so they are no 'missing' hole
	for (id obj in nodeInaccessibles) {
		PCNodes* neighboorIsConnexe =  ((PCNodes*)obj).smallestNeighboor;
		//NSLog(@"***** -> %@", obj);
		if([pointAccessible containsObject: neighboorIsConnexe] && [pointInaccessible containsObject: [NSValue valueWithCGPoint: ((PCNodes*)neighboorIsConnexe).pnt]]){
			[tmpNeighboor addObject: neighboorIsConnexe];
		}
	}
	
	[nodeInaccessibles unionSet: tmpNeighboor];
	[tmpNeighboor release];
    
    [nodeInaccessibles unionSet: nodeU];

	*raccess						= [nodeAccessibles allObjects];
	*rinaccess						= [nodeInaccessibles allObjects];
}

- (void)pathfinder:(CGPoint)spnt endPoint:(CGPoint)ePnt returnedPath:(CGPoint**)rpath length:(uint*)lenght{
	if(CGPointEqualToPoint(spnt, ePnt) || CGSizeEqualToSize(mapSize, CGSizeZero))
		return;
		
	NSMutableArray* list			= [_neighboorNodes mutableCopy];
	PCNodes*		cNode			= nil;	
	PCNodes* reverseNode			= nil;	
	uint			bit				= 1;
	
	
	for (int i = 0; i < [list count]; i++) {
		CGPoint nodePnt = ((PCNodes*)[list objectAtIndex: i]).pnt;
		
		if(CGPointEqualToPoint(nodePnt, spnt)){
			cNode		= [list objectAtIndex: i];
			bit			= bit << 1;
		}
		else if(CGPointEqualToPoint(nodePnt, ePnt)){
			reverseNode = [list objectAtIndex: i];
			bit			= bit << 2;
		}
		if(cNode && reverseNode) break;
	}
 
	// here we modul the path, used when the node doesn't exist but been's added (like a new tmp node)
	switch (bit) {
			// start from a tmp pnt, end to a tmp pnt
		case 1:{
					PCNodes* endNode	=  [PCNodes node: ePnt];
					reverseNode			= endNode;
					[list addObject: endNode];
					PCNodes* startNode	=  [PCNodes node: spnt];
					cNode				= startNode;
					[list addObject: startNode];
		}break;
			
		case 2:{	PCNodes* endNode	=  [PCNodes node: ePnt];
					reverseNode			= endNode;
					[list addObject: endNode];	
			break;
		}
		
		case 4:{	PCNodes* startNode	=  [PCNodes node: spnt];
					cNode				= startNode;
					[list addObject: startNode];	
			break;
		}
	}
	
	if (!reverseNode) {
		*lenght	= 0;
		*rpath	= nil;
		[list release];
		return;
	}
	
	// don't forget to reinitialise the node value
	[_neighboorNodes makeObjectsPerformSelector: @selector(reinitValue)];
	
	if (cNode){
		// Djikstra pathfinder
		cNode.cost				= 0;

		while ([list count]) {
			PCNodes* cNode	= [list objectAtIndex: 0];
			
			for (int i = 0; i < [list count]; i++) {
				PCNodes* tmpNode = [list objectAtIndex:i];
				
				if(cNode.cost > tmpNode.cost)
					cNode = tmpNode;
			}
			
			[list removeObject: cNode];
			
			if(cNode.cost == INFINITY || [list count] == 0)	
				break;
			CGPoint sPnt = cNode.pnt;
			
			for (int j = 0; j < [list count]; j++) {
				PCNodes* tmpNode	= [list objectAtIndex: j];
				CGPoint cPnt		= tmpNode.pnt;
				
				if ((sPnt.x == cPnt.x || sPnt.y == cPnt.y ) && (fabsf(sPnt.x - cPnt.x) == 1 || fabsf(sPnt.y - cPnt.y) == 1)){
					if(cNode.cost + 1 < tmpNode.cost){
						tmpNode.cost = cNode.cost + 1;
						if(!tmpNode.smallestNeighboor || tmpNode.smallestNeighboor.cost > cNode.smallestNeighboor.cost)
							tmpNode.smallestNeighboor = cNode;
					}
				}
			}
		}
	}


	[list release];
	
	// if there no move, then do go further
	if(!reverseNode.cost || reverseNode.cost == INFINITY)	return;

	uint pathCount			= reverseNode.cost;
	uint count				= 1;
	free(_gridPath);
	_gridPath				= malloc(sizeof(CGPoint)*pathCount);
	
	do{
		_gridPath[pathCount - count]	= reverseNode.pnt;
		reverseNode						= reverseNode.smallestNeighboor;
		count++;
	}
	while (reverseNode.smallestNeighboor);
	
	// if all ok then we assign the values
	if(lenght)
		*lenght	= pathCount;
    if(rpath)
        *rpath	= _gridPath;
}

#pragma mark alloc/dealloc
+ (id)engineWithConstelationName:(NSString*)name mapSize:(CGSize)mapSize linker:(CCTMXLayer*)linker{
	return [[[PCConstelationMapEngine alloc] initWithConstelationName: name
															  mapSize: mapSize
															   linker: linker] autorelease];
}

- (id)initWithConstelationName:(NSString*)name mapSize:(CGSize)mapSize_ linker:(CCTMXLayer*)linker{
	if(self = [super init]){
		mapSize = mapSize_;
		[self analyseLinks: linker];
	}
	return self;
}

- (void)dealloc{
	free(_gridPath);
	free(_itinerary);
	[_allPathNodes		release];
	[_neighboorNodes	release];
	[super				dealloc];
}
@end

@implementation PCNodes
@synthesize cost,
			pnt,
			smallestNeighboor;

+ (id)node:(CGPoint)pnt{
	return [[[PCNodes alloc] initWithPnt: pnt] autorelease];
}

- (void)reinitValue{
	cost				= INFINITY;
	smallestNeighboor	= nil;
}

- (id)initWithPnt:(CGPoint)pnt_{
	if(self = [super init]){
		pnt		= pnt_;
		cost	= INFINITY;
	}
	return self;
}

-(NSString*)description{
	return [NSString stringWithFormat:@"'Node' [%f - %f cost: %f - smallest neighboor %f - %f [%f]]", pnt.x, pnt.y, cost, smallestNeighboor.pnt.x,  smallestNeighboor.pnt.y ,smallestNeighboor.cost];
}
@end