//
//  PCMapStore.h
//  picrossGame
//
//  Created by loïc Abadie on 16/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class PCMapStore;

@protocol PCMapStoreDelegate <NSObject>
@required
- (void)requestReceivedResponse;
- (void)requestFinishDidPaid:(BOOL)hasPaid;
- (void)requestFailedWithError:(NSError*)error;
- (void)transactionsDone:(PCMapStore*)mapStore;
@optional
- (void)productInfoFound:(SKProduct*)product;
@end

@interface PCMapStore : NSObject
- (id)initWithDelegate:(id <PCMapStoreDelegate>)delegate_;
- (void)productPrice:(NSString*)productName;
- (void)userBoughtItems;
- (void)requestProductData:(NSSet*)productsName;
- (void)cancelRequest;
@property(nonatomic, assign)id <PCMapStoreDelegate> delegate;
@end
