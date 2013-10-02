//
//  PCBuyMap.m
//  picrossGame
//
//  Created by loïc Abadie on 19/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCBuyMap.h"
@interface PCBuyMap()
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)completeTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;
@property(nonatomic, assign)SKPaymentQueue* paymentQueue;
@end

@implementation PCBuyMap
@synthesize paymentQueue,
			mapStore,
			mapStoreDelegate;

#pragma mark - public
- (void)restoreCompletedTransaction{
	NSLog(@"*****------*****");
	[paymentQueue restoreCompletedTransactions];
}

#pragma mark - StoreDelegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
	for (SKPaymentTransaction *transaction in transactions){
		switch (transaction.transactionState){
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
	NSLog(@"Transaction removedTransactions %@", mapStoreDelegate);
	[mapStoreDelegate transactionsDone: mapStore];
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
	NSLog(@"Transaction made an error %@", error);
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
	NSLog(@"Transaction Ended (paymentQueueRestoreCompletedTransactionsFinished) %@", queue);
	for (SKPaymentTransaction* transaction in queue.transactions) {
		NSLog(@"%@ - %@ -> %@", transaction, transaction.transactionIdentifier, transaction.payment.productIdentifier);
	}
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction{
	if (transaction.error.code != SKErrorPaymentCancelled){
		// Optionally, display an error here.
	}
	[paymentQueue finishTransaction: transaction];
	NSLog(@"Transaction failed %@", transaction);
	[mapStoreDelegate requestFinishDidPaid: NO];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
	//If you want to save the transaction
	// [self recordTransaction: transaction];
	
	//Provide the new content
	// [self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
	//Finish the transaction
	[paymentQueue finishTransaction: transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction{
	//If you want to save the transaction
	//[self recordTransaction: transaction];
	
	//Provide the new content
	//[self provideContent: transaction.payment.productIdentifier];
	NSLog(@"completeTransaction %@", transaction);
	[paymentQueue finishTransaction: transaction];
	[mapStoreDelegate requestFinishDidPaid: YES];
}

#pragma mark - alloc / dealloc
- (id)init{
	if (self = [super init]) {
		paymentQueue = [SKPaymentQueue defaultQueue];
	}
	return self;
}
- (void)dealloc{
	[paymentQueue removeTransactionObserver: self];
	[super dealloc];
}
@end
