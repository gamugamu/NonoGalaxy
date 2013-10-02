//
//  PCConnectToDatabase.h
//  picrossGame
//
//  Created by loïc Abadie on 04/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CDBDownloadError_none,
    CDBDownloadError_cantConnectToServer    = -11,
    CDBDownloadError_DataWrong              = -12,
    CDBDownloadError_RequestFailed          = -13,
    CDBDownloadError_NotingNew              = -14 // lorsque rien de nouveau n'a été téléchargé
}CDBDownloadError;

@interface PCConnectToDatabase : NSObject
- (void)downloadConstelationslist:(void(^)(CDBDownloadError error, NSArray* newMap))onCompletion;
@property(assign, readonly)BOOL isReadyToDownload;
@end
