//
//  PCMapStore.m
//  picrossGame
//
//  Created by loïc Abadie on 16/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCMapStore.h"
#import "PCBuyMap.h"

@interface PCMapStore()<SKProductsRequestDelegate>
@property(nonatomic, retain)PCBuyMap* buyMap;
@property(nonatomic, assign)BOOL isObserverAdded;
@property(nonatomic, retain)NSTimer* timerDelay;
@property(nonatomic, retain)SKProductsRequest *request;
@property(nonatomic, assign)BOOL needPurchase;
@end

@implementation PCMapStore
@synthesize isObserverAdded,
			delegate,
			needPurchase,
			timerDelay	= _timerDelay,
			request		= _request,
			buyMap		= _buyMap;

#pragma mark - public
- (void)productPrice:(NSString*)productName{
	NSSet *productIdentifiers	= [NSSet setWithObject: productName];
    self.request				= [[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers] autorelease];
    _request.delegate			= self;
	needPurchase				= NO;
	
	self.timerDelay				= [NSTimer scheduledTimerWithTimeInterval: 30 target: self selector: @selector(timeOut:) userInfo: self repeats: NO];
    [_request start];
}

- (void)userBoughtItems{
	[[SKPaymentQueue defaultQueue] addTransactionObserver: _buyMap];
	[_buyMap restoreCompletedTransaction];	
}

- (void)requestProductData:(NSSet*)productsName{
	[self cancelRequest];
	
	NSLog(@"----- Can Make payment: %u", [SKPaymentQueue canMakePayments]);	
	if(!isObserverAdded){
		NSLog(@"added observer");
		[[SKPaymentQueue defaultQueue] addTransactionObserver: _buyMap];
		isObserverAdded = YES;
	}
	
	self.delegate				= delegate;
	self.request				= [[[SKProductsRequest alloc] initWithProductIdentifiers: productsName] autorelease];
	_request.delegate			= self;
	needPurchase				= YES;

	self.timerDelay = [NSTimer scheduledTimerWithTimeInterval: 30 target: self selector: @selector(timeOut:) userInfo: self repeats: NO];
	NSLog(@"***********-startRequest %@", productsName);
	[_request start];
}

- (void)cancelRequest{
	NSLog(@"--- map store has canceled the request----");
	[_request cancel];
	[_timerDelay invalidate];
	_buyMap.mapStoreDelegate = nil;
}

- (void)setDelegate:(id<PCMapStoreDelegate>)delegate_{
	delegate					= delegate_;
	_buyMap.mapStoreDelegate	= delegate_;
}

#pragma mark - private
- (void)timeOut:(NSTimer*)timer{
	NSLog(@"----- TIMEOUT -----");
	[delegate requestFailedWithError: [NSError errorWithDomain: @"Time out" code: -11 userInfo: nil]];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	NSArray *myProduct = response.products;
	
	// on arrète le timer
	[_timerDelay invalidate];
	

	[delegate requestReceivedResponse];
	
	// populate UI
	for(int i=0;i < [myProduct count]; i++){
		SKProduct *product = [myProduct objectAtIndex:i];
		NSLog(@"Name: %@ - Price: %f",[product localizedTitle],[[product price] doubleValue]);
		NSLog(@"Product identifier: %@", [product productIdentifier]);
		
		// on sait que si ce n'est pas pour effectuer un achat, c'est juste pour connaître les info du produit.
		if(needPurchase){
			SKMutablePayment *myPayment = [SKMutablePayment paymentWithProduct: [myProduct objectAtIndex: i]];
			[[SKPaymentQueue defaultQueue] addPayment: myPayment];
			NSLog(@"make Paid request %@", myPayment);
		}else{
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			[numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
			[numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
			[numberFormatter setLocale: product.priceLocale];
			NSString *formattedString = [numberFormatter stringFromNumber: product.price];
			[numberFormatter release];
			NSLog(@"DELEGATE CAN KNOW THAT PRODUCT COST %@", formattedString);
			if([delegate respondsToSelector: @selector(productInfoFound:)])
				[delegate productInfoFound: product];
			}
	}
	NSLog(@"response %@ current transaction %@", response, [SKPaymentQueue defaultQueue].transactions);
	
	// si il n'y a pas de produit, on annule la transaction parce que le produit id est certainement invalid
	if(![myProduct count]){
		[_request cancel];
		[delegate requestFailedWithError: [NSError errorWithDomain: @"This Store id seems invalid" code:-10 userInfo: nil]];
	}
}

- (void)requestDidFinish:(SKRequest *)request {
	if([request isKindOfClass: [SKProductsRequest class]])
		NSLog(@"requestDidFinish %@", request);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	[_timerDelay invalidate];
	[delegate requestFailedWithError: error];
}

#pragma mark - alloc / dealloc
- (id)initWithDelegate:(id<PCMapStoreDelegate>)delegate_{
	if (self = [super init]) {
		delegate					= delegate_;
		_buyMap						= [[PCBuyMap alloc] init];
		_buyMap.mapStoreDelegate	= delegate_;
	}
	return self;
}
- (void)dealloc{
	[_timerDelay	invalidate];
	[_timerDelay	release];
	[_request		release];
	[_buyMap		release];
	[super dealloc];
}
@end
