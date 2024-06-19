//
//  IAPManager.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "AbstractSingleton.h"
#import "GWCall.h"


extern NSString *const IAPProductListUpdateDidStart;
extern NSString *const IAPProductListUpdateDidSucceed;
extern NSString *const IAPProductListUpdateDidFail;
extern NSString *const IAPActionDidStart;
extern NSString *const IAPActionDidSucceed;
extern NSString *const IAPActionDidFail;
extern NSString *const IAPTransactionPurchased;
extern NSString *const IAPTransactionRestored;
extern NSString *const IAPTransactionFailed;


typedef enum {
	IAPGainingNone,
	IAPGainingByPurchase,
	IAPGainingByRestore
} IAPGainingMode;


@interface IAPManager : AbstractSingleton <UIAlertViewDelegate,
										   SKRequestDelegate,
										   SKProductsRequestDelegate,
										   SKPaymentTransactionObserver,
										   GWCallDelegate>
{
	GWCall *_listCall;
	GWCall *_purchaseCall;
	GWCall *_restoreCall;
	GWCall *_checkCall;		// may be polled(!)
	
	NSMutableArray *_transactions;
	
	SKProductsRequest *_productsRequest;
	NSArray *_products;
	
	UIAlertView *_alertView;
	
	BOOL _restoring;
	BOOL _purchasing;
	BOOL _canFinish;
	
	IAPGainingMode _gainingMode;
	
	NSInteger _pollCounter;
	BOOL _beQuiet;
}

+ (IAPManager*) instance;

// reset manager state
+ (void) reset;
// busy flag
+ (BOOL) isBusy;
// do not show warnings
+ (BOOL) isQuiet;
+ (void) setQuiet:(BOOL)quiet;
// refresh pruduct list (server ->(id list)-> client ->(products request)-> AppStore ->(products)-> client)
+ (void) refreshProducts;
// purchase/restore access methods
+ (BOOL) startPurchase:(SKProduct*)product;
+ (BOOL) startRestore;
// product list (only valid after [IAPManager refreshProducts] has been successfully finished)
+ (NSArray*) products;
// purchases/restores helpers
+ (NSString*) csvPurchasedProducts;
+ (NSArray*) purchasedProducts;
+ (void) resetPurchasedProducts;
+ (BOOL) isProductPurchased:(NSString*)productIdentifier;
+ (void) addPurchasedProducts:(NSArray*)productIdentifiers receipts:(NSArray*)transactionReceipts;
+ (void) addPurchasedProduct:(NSString*)productIdentifier receipt:(NSData*)transactionReceipt;
+ (void) removePurchasedProducts:(NSArray*)productIdentifiers;
+ (void) removePurchasedProduct:(NSString*)productIdentifier;
// pending purchases/restores helpers
+ (BOOL) hasPendingProducts;
+ (BOOL) sendPendingProductsIfAny;
+ (IAPGainingMode) pendingMode;
+ (NSArray*) pendingProducts;
+ (NSArray*) pendingReceipts;
+ (BOOL) isProductPending:(NSString*)productIdentifier;
+ (void) savePendingProducts:(NSArray*)products receipts:(NSArray*)receipts mode:(IAPGainingMode)mode;
+ (void) clearPendingProducts;

@end


@interface IAPManager ()
// methods to override
- (NSString*) productIdentifiersURL;
- (NSString*) purchaseURL;
- (NSString*) restoreURL;
- (NSString*) checkPurchasedContentURL;
@end
