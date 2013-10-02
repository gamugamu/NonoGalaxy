//
//  PCBuyMap.h
//  picrossGame
//
//  Created by loïc Abadie on 19/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "PCMapStore.h"

@interface PCBuyMap : NSObject<SKPaymentTransactionObserver>
- (void)restoreCompletedTransaction;
@property(nonatomic, assign)PCMapStore* mapStore;
@property(nonatomic, assign)id<PCMapStoreDelegate> mapStoreDelegate;
@end
