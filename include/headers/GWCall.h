//
//  GWCall.h
//
//  Created by Bence Balint on 2010.12.07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLFetcher.h"
#import "URLDownloader.h"


extern NSString *const GWOptionPureParameters;		// don't append basic parameters

extern NSString *const GWMethodHEADKey;				// keys & values for HEAD submit method
extern NSString *const GWMethodGETKey;				// keys & values for GET submit method
extern NSString *const GWMethodPOSTKey;				// keys & values for POST submit method
extern NSString *const GWMethodFORMSKey;			// keys & values for POST-FormData submit method
extern NSString *const GWMethodRawPOSTKey;			// value for raw POST submit method
extern NSString *const GWDocumentsKey;				// document names for POST-FormData submit method
extern NSString *const GWFilenamesKey;				// file names for POST-FormData submit method
extern NSString *const GWHTTPHeadersKey;			// keys & values for HTTP header fields

extern NSString *const GWCRawDataResponseKey;		// used for GWProtocolRAW as key for raw data response
extern NSString *const GWCFilePathResponseKey;		// used for GWProtocolFileDownload as key for the saved file path


@class GWCall;

@protocol GWCallDelegate <NSObject>
@optional
- (void) gwCallDidStart:(GWCall*)gwCall;
- (void) gwCallDidSucceed:(GWCall*)gwCall;
- (void) gwCallDidFail:(GWCall*)gwCall;
- (void) gwCallProgress:(GWCall*)gwCall;
@end


typedef enum {
	GWProtocolRAW,
	GWProtocolJSON,
	GWProtocolPList,
	GWProtocolXML,
	GWProtocolFileDownload
} GWProtocolType;


//
// usage:
// ------
// NSDictionary *get = _nsdictionary(_nsdictionary(@"value1", @"key1"), GWMethodGETKey);
// [GWManager registerCall:[GWCall sendData:[GWManager instance]
//								 parameters:get
//								   userInfo:nil]];
//

@interface GWCall : NSObject <URLFetcherDelegate,
							  URLDownloaderDelegate>
{
	id<GWCallDelegate> _delegate;
	URLFetcher *_fetcher;
	URLDownloader *_downloader;
	NSDictionary *_parameters;
	NSMutableDictionary *_response;
	id _userInfo;
	GWProtocolType _protocolType;
	BOOL _searchForSuccess;
	ConnectionInfo *_connectionInfo;
}

@property (readwrite,assign) GWProtocolType protocolType;
@property (readwrite,assign) BOOL searchForSuccess;
@property (readwrite,retain) ConnectionInfo *connectionInfo;

// default download methods
+ (id) gwCall:(NSString*)url
		 path:(NSString*)path
	 delegate:(id<GWCallDelegate>)delegate
   parameters:(NSDictionary*)parameters
	 userInfo:(id)userInfo
 protocolType:(GWProtocolType)protocol
searchForSuccess:(BOOL)search;
+ (NSMutableDictionary*) checkParameters:(NSDictionary*)parameters;
- (void) start;
- (BOOL) isLoading;
- (void) cancel;
- (NSMutableDictionary*) response;

// Info call (just to fetch responseHeaders)
+ (id) infoCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo;
// Gateway calls
+ (id) dataCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo;
+ (id) jsonCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo;
+ (id) jsonCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo searchForSuccess:(BOOL)search;
+ (id) plistCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo;
+ (id) plistCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo searchForSuccess:(BOOL)search;
+ (id) xmlCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo;
+ (id) xmlCall:(id<GWCallDelegate>)delegate baseURL:(NSString*)url parameters:(NSDictionary*)parameters userInfo:(id)userInfo searchForSuccess:(BOOL)search;
+ (id) fileDownload:(id<GWCallDelegate>)delegate baseURL:(NSString*)url filePath:(NSString*)path parameters:(NSDictionary*)parameters userInfo:(id)userInfo;
// IAP calls
+ (id) iapGetProductIdentifiers:(NSString*)url delegate:(id<GWCallDelegate>)delegate userInfo:(id)userInfo;															// get PruductIdentifier strings
+ (id) iapPurchase:(NSString*)url delegate:(id<GWCallDelegate>)delegate receipt:(NSData*)receipt identifier:(NSString*)identifier userInfo:(id)userInfo;			// send transaction receipt from SKPaymentTransaction on purchase
+ (id) iapPurchase:(NSString*)url delegate:(id<GWCallDelegate>)delegate receipts:(NSArray*)receipts identifiers:(NSArray*)identifiers userInfo:(id)userInfo;		// send transaction receipts from SKPaymentTransaction on purchase
+ (id) iapRestore:(NSString*)url delegate:(id<GWCallDelegate>)delegate receipt:(NSData*)receipt identifier:(NSString*)identifier userInfo:(id)userInfo;				// send transaction receipt from SKPaymentTransaction on restore
+ (id) iapRestore:(NSString*)url delegate:(id<GWCallDelegate>)delegate receipts:(NSArray*)receipts identifiers:(NSArray*)identifiers userInfo:(id)userInfo;			// send transaction receipts from SKPaymentQueue on restore all product
+ (id) iapCheckPurchasedContent:(NSString*)url delegate:(id<GWCallDelegate>)delegate identifier:(NSString*)identifier userInfo:(id)userInfo;						// polls(!) the server to check Transaction state with product identifier
+ (id) iapCheckPurchasedContent:(NSString*)url delegate:(id<GWCallDelegate>)delegate identifiers:(NSArray*)identifiers userInfo:(id)userInfo;						// polls(!) the server to check Transaction state with product identifiers
// APNS calls
+ (id) apnsRegisterToken:(NSString*)url delegate:(id<GWCallDelegate>)delegate token:(NSData*)token userInfo:(id)userInfo;											// register APNS
+ (id) apnsUnregisterToken:(NSString*)url delegate:(id<GWCallDelegate>)delegate token:(NSData*)token userInfo:(id)userInfo;											// unregister APNS

// helper methods
+ (NSArray*) createDocumentsFor:(NSArray*)posts name:(NSString*)name;
+ (NSArray*) createFilenamesFor:(NSArray*)posts image:(NSString*)image data:(NSString*)data;

// default parameters
+ (NSMutableDictionary*) gwCallGETParameters:(NSDictionary*)dictionary;
+ (NSMutableDictionary*) gwCallPOSTParameters:(NSDictionary*)dictionary;

@end


@interface GWCall ()
@property (readwrite,assign) id<GWCallDelegate> delegate;
@property (readwrite,retain) URLFetcher *fetcher;
@property (readwrite,retain) URLDownloader *downloader;
@property (readwrite,retain) NSDictionary *parameters;
@property (readwrite,retain) NSMutableDictionary *response;
@property (readwrite,retain) id userInfo;
- (BOOL) processResponse:(NSData*)data;
@end
