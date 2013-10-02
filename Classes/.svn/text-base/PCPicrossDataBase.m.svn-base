//
//  PCPicrossDataBase.m
//  picrossGame
//
//  Created by loïc Abadie on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCPicrossDataBase.h"
#import "PCViewLevelInfo.h"
#import "PCFilesManager.h"
#import "PCGalaxyInfo.h"
#import "PCStageBeenEligible.h"
#import <CoreData/CoreData.h>

@interface PCPicrossDataBase()
- (NSURL*)applicationDocumentsDirectory;
- (void)makeRequestForObject:(NSString*)entityName withDescriptor:(NSArray*)descriptors;
- (void)changeMapPaidStatusForName:(NSString*)mapName saveOrErase:(BOOL)isSaved;
@property(nonatomic, retain, readonly) NSManagedObjectContext*			managedObjectContext;
@property(nonatomic, retain, readonly) NSManagedObjectModel*			managedObjectModel;
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator*	persistentStoreCoordinator;
@property(nonatomic, retain)NSFetchRequest*								_fetchRequest;
@property(nonatomic, retain)NSFetchedResultsController*					_Fcontroller;
@end

@implementation PCPicrossDataBase
@synthesize 	_fetchRequest,
				_Fcontroller,
				managedObjectContext		= __managedObjectContext,
				managedObjectModel			= __managedObjectModel,
				persistentStoreCoordinator	= __persistentStoreCoordinator;


#pragma mark core data methodes
#pragma mark core data public
#define switchToFetch(fetchName, key)\
	if(![_fetchRequest.entityName isEqualToString: fetchName]){\
		NSSortDescriptor* descriptor	=  [[NSSortDescriptor alloc] initWithKey: key ascending: YES];\
		[self makeRequestForObject: fetchName withDescriptor: [NSArray arrayWithObject: descriptor]];\
		[descriptor release];\
	}

- (BOOL)stageElibgibleHasAlreadyBeenDisplayed:(uint)level forConstelationName:(NSString*)constelationName{
	NSManagedObjectContext* context				= [self managedObjectContext];
	NSFetchRequest*			fetch				= [[NSFetchRequest alloc] initWithEntityName: @"PCStageBeenEligible"];
	[fetch setPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat: @"(mapName == '%@') AND (level == %u)", constelationName, level]]]; 
							fetch.fetchLimit	= 1;
	
	PCStageBeenEligible* stageBeenEligible;
	NSArray* dataList = [context executeFetchRequest: fetch error: nil];
	[fetch release];

	if([dataList count]){
		return YES;
	}
	else{
		stageBeenEligible	= [NSEntityDescription insertNewObjectForEntityForName: @"PCStageBeenEligible"   
														  inManagedObjectContext: context];
		stageBeenEligible.level		= [NSNumber numberWithUnsignedInt: level];
		stageBeenEligible.mapName	= constelationName;
		[context save: nil];
		return NO;
	}
}

- (void)addNewEntry:(levelInfoDB*)managedObject forName:(NSString*)constelationName{
	NSManagedObjectContext* context = [self managedObjectContext];
	PCLevelInfo *newEntrie			= nil;
	// si le fetchControoler n'est pas le bon, on refait un predicate avec le PCLevelInfo
	switchToFetch(@"PCLevelInfo", @"level");
		
	//if the ojbect exist, then change it. Overelse, create it
	[_fetchRequest setPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat: @"(constelationName == '%@') AND (level == %u)", constelationName, managedObject->level]]]; 
	[_fetchRequest setFetchLimit: 1];

	NSArray* dataList = [context executeFetchRequest: _fetchRequest error: nil];	

	if ([dataList count]) {
		newEntrie = [dataList objectAtIndex: 0]; 
		// si jamais le stage existe déjà on controle si le stage a déj) été réalisé.
		// Cela permet de compter le nombre de victoire déjà réalisée.
		if([newEntrie.isDone boolValue])
			newEntrie.totalDone = [NSNumber numberWithInt: [[newEntrie totalDone] intValue] + 1];
	}else
		newEntrie = [NSEntityDescription insertNewObjectForEntityForName: @"PCLevelInfo"
												  inManagedObjectContext: context];
	
	[newEntrie setConstelationName:	constelationName];
	[newEntrie setTimeElapsed:		[NSNumber numberWithInteger: managedObject->timeElapsed]];
	[newEntrie setIsDone:			[NSNumber numberWithBool: managedObject->isDone]];
	[newEntrie setLevel:			[NSNumber numberWithInt: managedObject->level]];

	 NSError *error = nil;
	[context save: &error];
	 
	if(error)
		NSLog(@"error occured when %@", error);
}

- (void)removeEntry:(levelInfoDB*)managedObject forName:(NSString*)constelationName{
	NSManagedObjectContext* context = [self managedObjectContext];
	// si le fetchControoler n'est pas le bon, on refait un predicate avec le PCLevelInfo
	switchToFetch(@"PCLevelInfo", @"level");
	
	//if the ojbect exist, then change it. Overelse, create it
	[_fetchRequest setPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat: @"(constelationName == '%@') AND (level == %u)", constelationName, managedObject->level]]]; 
	[_fetchRequest setFetchLimit: 1];

	NSArray* result = [context executeFetchRequest: _fetchRequest error: nil];
	
	for (id levels in result){
		[context deleteObject: levels];
	}
	
	NSError *error = nil;
	[context save: &error];

}

- (PCLevelInfo*)levelInfoForConstelationName:(NSString*)constelationName level:(uint)level{
	NSManagedObjectContext* context = [self managedObjectContext];
	// si le fetchControoler n'est pas le bon, on refait un predicate avec le PCLevelInfo
	switchToFetch(@"PCLevelInfo", @"level");
	
	[_fetchRequest setPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat: @"constelationName == '%@' && level == %u", constelationName, level]]]; 
	[_fetchRequest setFetchLimit: 1];
	NSArray* dataList				= [context executeFetchRequest:_fetchRequest error: nil];	
	
	if([dataList count])
		return  [dataList objectAtIndex: 0];
	else
		return nil;
}

- (NSDictionary*)entriesForConstelation:(NSString*)constelationName{
	NSManagedObjectContext* context = [self managedObjectContext];
	// si le fetchControoler n'est pas le bon, on refait un predicate avec le PCLevelInfo
	switchToFetch(@"PCLevelInfo", @"level");
	
	[_fetchRequest setPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat: @"constelationName == '%@'", constelationName]]]; 
	[_fetchRequest setFetchLimit: 0];
	NSArray* dataList				= [context executeFetchRequest:_fetchRequest error: nil];	
	NSMutableDictionary* dataKeys	= [NSMutableDictionary dictionaryWithCapacity: [dataList count]];
	
	[dataList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[dataKeys setObject: obj forKey: ((PCLevelInfo*)obj).level];
	}];
	
	return dataKeys;
}

- (void)saveRequirment:(NSString*)requirmentName{
	NSManagedObjectContext* context = [self managedObjectContext];
	NSManagedObject* requirment		= [NSEntityDescription insertNewObjectForEntityForName: @"PCRequirmentDone"   
																 inManagedObjectContext: context];
	
	[requirment setValue: requirmentName forKey: @"name"];
	[context save: nil];
}

- (NSArray*)requirmentsDone{
	NSManagedObjectContext* context = [self managedObjectContext];
	// si le fetchControoler n'est pas le bon, on refait un predicate avec le PCLevelInfo
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"PCRequirmentDone"];
	return [context executeFetchRequest: request error: nil];
}

- (void)addPaidedMap:(NSString*)mapName{
	[self changeMapPaidStatusForName: mapName saveOrErase: YES];
}

- (void)removePaidedMap:(NSString*)mapName{
	[self changeMapPaidStatusForName: mapName saveOrErase: NO];
}

- (void)changeMapPaidStatusForName:(NSString*)mapName saveOrErase:(BOOL)isSaved{
	NSManagedObjectContext* context = [self managedObjectContext];
	switchToFetch(@"PCGalaxyInfo", @"name");
	PCGalaxyInfo *mapPaidEntry		= nil;
	
	//if the ojbect exist, then change it. Overelse, create it
	[_fetchRequest setPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat: @"name == '%@'", mapName]]]; 
	[_fetchRequest setFetchLimit: 1];
	
	NSArray* dataList = [context executeFetchRequest: _fetchRequest error: nil];	
	
	if ([dataList count]) {
		mapPaidEntry = [dataList objectAtIndex: 0]; 
	}else{
		mapPaidEntry = [NSEntityDescription insertNewObjectForEntityForName: @"PCGalaxyInfo" inManagedObjectContext: context];
	}
	
	mapPaidEntry.name			= mapName;
	mapPaidEntry.hasBeenPaid	= isSaved;
	
	NSError *error = nil;
	[context save: &error];
	
	if(error)
		NSLog(@"error occured when %@", error);
	
	NSLog(@"SAVED mapPAid %@", mapPaidEntry.name);
}

- (PCConstelationInfo*)constelationForIdx:(uint)idx{
    NSManagedObjectContext* context         = [self managedObjectContext];
    NSFetchRequest* request                 = [NSFetchRequest fetchRequestWithEntityName: @"PCConstelationInfo"];
    NSPredicate* predicate                  = [NSPredicate predicateWithFormat: @"idx == %u", idx];
    request.predicate                       = predicate;
    PCConstelationInfo *constelationInfo	= nil;
    NSArray* dataList                       = [context executeFetchRequest: request
                                                                     error: nil];
        
    if(dataList.count)
        constelationInfo = [dataList objectAtIndex: 0];
    else{
		constelationInfo = [NSEntityDescription insertNewObjectForEntityForName: @"PCConstelationInfo"
                                                         inManagedObjectContext: context];
        constelationInfo.idx = [NSNumber numberWithInt: idx];
	}
    
    NSError *error = nil;
	[context save: &error];

    return constelationInfo;
}

- (NSArray*)allConstelationComplete{
	NSManagedObjectContext* context = [self managedObjectContext];
    NSFetchRequest* request         = [NSFetchRequest fetchRequestWithEntityName: @"PCConstelationInfo"];
    NSArray* dataList               = [context executeFetchRequest: request
                                                             error: nil];
    
    return dataList;
}

- (NSSet*)mapPaid{
	NSManagedObjectContext* context = [self managedObjectContext];
	switchToFetch(@"PCGalaxyInfo", @"name");
	NSArray* dataList = [context executeFetchRequest: _fetchRequest error: nil];
	NSMutableSet* set = [NSMutableSet setWithCapacity: [dataList count]];
	
	for (PCGalaxyInfo* galaxyInfo in dataList){
		if(galaxyInfo.hasBeenPaid)
			[set addObject: galaxyInfo.name];
	}
	
	return set;
}

- (NSSet*)allMaps{
    return nil;
}

- (void)cleanDataBase{
	NSManagedObjectContext* context = [self managedObjectContext];
	[_fetchRequest setEntity:[NSEntityDescription entityForName:@"PCLevelInfo" inManagedObjectContext: context]];
	NSArray* result = [context executeFetchRequest: _fetchRequest error: nil];
	
	for (id levels in result)
		[context deleteObject: levels];
	
	NSError *error = nil;
	[context save: &error];
}

#pragma mark core data private
- (void)makeRequestForObject:(NSString*)entityName withDescriptor:(NSArray*)descriptors{
	NSManagedObjectContext *context = [self managedObjectContext];	
	self._fetchRequest				= [[[NSFetchRequest alloc] init] autorelease];	
	[_fetchRequest setEntity: [NSEntityDescription	entityForName: entityName inManagedObjectContext: context]];
	[_fetchRequest setSortDescriptors: descriptors];
} 

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil){
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            /*
             Replace this implementation with code to handle the error appropriately.
             abort() causes the application to generate a crash log and terminate. 
			 You should not use this function in a shipping application, although 
			 it may be useful during development. If it is not possible to recover 
			 from the error, display an alert panel that instructs the user to quit 
			 the application by pressing the Home button.
             */
            NSLog(@"[saveContext]: Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext{
    if (__managedObjectContext != nil)
        return __managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil){
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel{
    if (__managedObjectModel != nil)
        return __managedObjectModel;
    
    NSURL *modelURL			= [[NSBundle mainBundle] URLForResource:@"picrossDataBase" withExtension:@"momd"];
    __managedObjectModel	= [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (__persistentStoreCoordinator != nil)
        return __persistentStoreCoordinator;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"picrossDataBase.xcdatamodeld"];
    NSError *error	= nil;
	
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. You should 
		 not use this function in a shipping application, although it may be useful during
		 development. If it is not possible to recover from the error, display an alert panel
		 that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the
		 file path. Often, a file URL is pointing into the application's resources directory
		 instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce
		 their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary
		 as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         Lightweight migration will only work for a limited set of schema changes; consult
		 "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark singletonInstance
#pragma mark alloc/dealloc
static PCPicrossDataBase* _sharedMySingleton = nil;

+ (PCPicrossDataBase*)sharedPCPicrossDataBase{
	@synchronized([PCPicrossDataBase class])
	{
		if (!_sharedMySingleton)
			_sharedMySingleton = [[self alloc] init];
		
	}
	
	return _sharedMySingleton;
}

+ (id)alloc{
	@synchronized([PCPicrossDataBase class]){
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
	
	return nil;
}

- (void)dealloc{
	[_Fcontroller					release];
	[_fetchRequest					release];
	[__managedObjectContext			release];
	[__managedObjectModel			release];
	[__persistentStoreCoordinator	release];	
   	[super dealloc];
}
@end
