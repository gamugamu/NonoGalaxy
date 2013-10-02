//
//  PCConnectToDatabase.m
//  picrossGame
//
//  Created by loïc Abadie on 04/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PCConnectToDatabase.h"
#import "PCFilesManager.h"
#import "GameConfig.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

@interface PCConnectToDatabase()<NSXMLParserDelegate>
- (void)downloadSpecificConstelations:(NSArray*)constelationList;
- (void)analyseConstelationListData:(NSData*)data;
- (void)downloadIsVoid;
@property(nonatomic, assign)BOOL isTheTagWanted;
@property(nonatomic, assign)BOOL isRequestFailed;
@property(nonatomic, copy)void (^downloadComplete)(CDBDownloadError error, NSArray* newMap);
@property(nonatomic, retain)NSArray* _mapsIdx;
@end

@implementation PCConnectToDatabase
@synthesize isTheTagWanted,
            isRequestFailed,
            downloadComplete    = _downloadComplete,
            isReadyToDownload   = _isReadyToDownload,
            _mapsIdx;

#pragma mark ============================ public ===============================
#pragma mark ===================================================================

#pragma mark - public

- (void)downloadConstelationslist:(void(^)(CDBDownloadError error, NSArray* newMap))onCompletion{
    _isReadyToDownload              = NO;
    self.downloadComplete           = onCompletion;
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: GamugamuConstelatioListURL]];
    
    [request setCompletionBlock:^{
        [request retain];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self analyseConstelationListData: [request responseData]];
            [request release];
        });
	}];
    
	[request setFailedBlock:^{
        [self downloadDone: CDBDownloadError_cantConnectToServer withMap: nil];
	}];
    
	[request startAsynchronous];
}

- (void)downloadSpecificConstelations:(NSArray*)constelationList{
    
	ASINetworkQueue* queue = [[ASINetworkQueue alloc] init];
	[queue setDelegate: self];
	[queue setRequestDidFailSelector: @selector(downloadConstelationListFailed:)];
	[queue setQueueDidFinishSelector: @selector(downloadConstelationListComplete:)];
	
	for (NSString* nonoSets in constelationList) {
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: GamugamuSpecificConstelationURL]];
		[request setPostValue: nonoSets forKey: ConstKey];
		[request setDownloadDestinationPath: [[PCFilesManager sharedPCFileManager] downloadedFiles: nonoSets]];
        
		[queue addOperation:request];
	}
	[queue go];
}

#pragma mark private methode
- (void)analyseConstelationListData:(NSData*)data{
	NSError* errorString = nil;
	NSArray* dt =	[[NSPropertyListSerialization	propertyListWithData: data
															 options: NSPropertyListImmutable
															  format: nil
															   error: &errorString] objectForKey: ConstKey];
		
	NSMutableSet*	importedList	= [NSMutableSet setWithArray: dt];
    
    if(errorString){
        // Impossible de désérialiser les données
        [self downloadDone: CDBDownloadError_DataWrong withMap: nil];
		return;
	}
	NSSet*			currentList		= [NSSet setWithArray: [[PCFilesManager sharedPCFileManager] zipMapsList]];
    
	// check if there's a nasty ".DS_Store" in it
	[importedList removeObject: @".DS_Store"];
	[importedList minusSet: currentList];
    
	if([importedList count]){
        NSMutableArray* limitedSize = nil;
       
        if(importedList.count >= MAX_MAP_FOR_DOWNLOAD_IN_ONE_TIME){
            int numberOfMaps = (currentList.count == 0)? MAX_MAP_FOR_DOWNLOAD_FIRST_TIME : MAX_MAP_FOR_DOWNLOAD_IN_ONE_TIME;
            limitedSize = [NSMutableArray  arrayWithCapacity: numberOfMaps];
            NSSortDescriptor * sortDesc = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];

            NSMutableArray* indexedList = [[[importedList sortedArrayUsingDescriptors: @[sortDesc]] mutableCopy] autorelease];
            [sortDesc release];
            
            for(int i  = 0 ; i < numberOfMaps; i++){
                id object = [indexedList firstObject];
                [limitedSize addObject: object];
                [indexedList removeObject: object];
            }
        }else
            limitedSize = (NSMutableArray*)importedList;
        
        self._mapsIdx = limitedSize;
        [self downloadSpecificConstelations: limitedSize];
    }else{
        self._mapsIdx = nil;
		[self downloadIsVoid];
    }
}

#pragma mark ASIFormDataRequest Delegate
- (void)downloadIsVoid{
    [self downloadDone: CDBDownloadError_NotingNew withMap: nil];
}

- (void)downloadConstelationListComplete:(ASINetworkQueue *)queue{
	[queue release];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (isRequestFailed){
            [self downloadDone: CDBDownloadError_RequestFailed withMap: nil];
            return;
        }
        
        NSError* error = nil;
        
        uint errorCount = [[PCFilesManager sharedPCFileManager] unzipDownloadedData: &error];
        
        if(error || errorCount)
            [self downloadDone: CDBDownloadError_RequestFailed withMap: nil];
        else
            [self downloadDone: CDBDownloadError_none withMap: _mapsIdx];
    });
}

- (void)downloadConstelationListFailed:(ASINetworkQueue *)queue{
	isRequestFailed     = YES;
}

#pragma mark alloc / dealloc

- (id)init{
    if(self = [super init]){
        _isReadyToDownload = YES;
    }
    return self;
}

- (void)dealloc{
    [_downloadComplete  release];
	[_mapsIdx           release];
	[super dealloc];
}

#pragma mark ============================ private ==============================
#pragma mark ===================================================================

- (void)downloadDone: (CDBDownloadError)error withMap: (NSArray*)maps{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_downloadComplete)
            _downloadComplete(error, maps);

        _isReadyToDownload = YES;
    });
}

@end
