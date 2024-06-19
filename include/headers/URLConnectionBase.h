//
//  URLConnectionBase.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "ConnectionInfo.h"


typedef enum {
	URLMethodGET,																				// supports NSStrings
	URLMethodURLEncodePOST,																		// supports NSDictionary just as getParams (only NSString)
	URLMethodFormDataPOST,																		// supports for two and more post param (NSData, UIImage)
	URLMethodRawPOST,																			// supports NSData
	URLMethodHEAD
} URLMethod;


typedef enum {
	URLThreadUseGlobal,																			// schedule NSURLConnection in global worker thread
	URLThreadUseMain,																			// schedule NSURLConnection in main thread
	URLThreadUseOwn,																			// schedule NSURLConnection in dedicated thread
	URLThreadUseCurrent																			// schedule NSURLConnection in current thread
} URLThread;


@interface URLConnectionBase : NSObject <NSURLConnectionDelegate,
										 NSURLConnectionDataDelegate>
{
	NSThread *_ownThread;
	NSURLConnection *_connection;
	URLThread _urlThread;
	
	// POST method
	URLMethod _urlMethod;
	// for URLPostNoPost (GET method)
	NSDictionary *_getParams;
	// for URLPostURLEncode (POST method)
	NSDictionary *_postParams;
	// for URLPostFormData (POST method)
	NSArray *_formParams;
	NSArray *_documents;
	NSArray *_filenames;
	// for URLMethodRawPOST (POST method)
	NSData *_rawPostParam;
	// for HTTP header fields
	NSDictionary *_headerFields;
	BOOL _disallowFractions;
	
	BOOL _loading;
	id _userInfo;
	NSTimer *_timeoutTimer;
	
	ConnectionInfo *_connectionInfo;
}

@property (readwrite,assign) URLThread urlThread;
@property (readwrite,assign) URLMethod urlMethod;
@property (readwrite,retain) NSDictionary *getParams;
@property (readwrite,retain) NSDictionary *postParams;
@property (readwrite,retain) NSData *rawPostParam;
@property (readwrite,retain) NSDictionary *headerFields;
@property (readwrite,retain) ConnectionInfo *connectionInfo;
@property (readwrite,assign) NSArray *formParams;
@property (readwrite,assign) NSArray *documents;
@property (readwrite,assign) NSArray *filenames;
@property (readwrite,assign) BOOL disallowFractions;
@property (readonly,getter=isLoading) BOOL loading;
@property (readwrite,retain) id userInfo;

// helper methods
+ (NSString*) completeURL:(NSString*)url withDictionary:(NSDictionary*)getParams allowFractions:(BOOL)fractions;
+ (NSString*) urlEncodeObject:(id)obj forKey:(NSString*)key allowFractions:(BOOL)fractions;
+ (BOOL) isStatusCodeOK:(NSInteger)code;
+ (NSURLRequest*) requestForUrl:(NSString*)url parameters:(NSDictionary*)parameters allowFractions:(BOOL)fractions;
+ (NSURLRequest*) requestForUrl:(NSString*)url
					  urlMethod:(URLMethod)urlMethod
					  getParams:(NSDictionary*)getParams										// for URLPostNoPost
					 postParams:(NSDictionary*)postParams										// for URLPostURLEncode
					 formParams:(NSArray*)formParams											// for URLPostFormData
					  documents:(NSArray*)documents												// for URLPostFormData
					  filenames:(NSArray*)filenames												// for URLPostFormData
				   rawPostParam:(NSData*)rawPostParam											// for URLMethodRawPOST
				   headerFields:(NSDictionary*)headerFields										// for external HTTP header fields
				 downloadOffset:(unsigned long long)offset										// offset for file download
				 allowFractions:(BOOL)fractions;												// allows fractional key-value pairs in parameter (e.g. "...&db=&...")


// shorthand methods
+ (id) connection;

+ (id) download:(NSString*)url
	  urlMethod:(URLMethod)urlMethod
	  getParams:(NSDictionary*)getParams														// for URLPostNoPost
	 postParams:(NSDictionary*)postParams														// for URLPostURLEncode
	 formParams:(NSArray*)formParams															// for URLPostFormData
	  documents:(NSArray*)documents																// for URLPostFormData
	  filenames:(NSArray*)filenames																// for URLPostFormData
   rawPostParam:(NSData*)rawPostParam															// for URLMethodRawPOST
   headerFields:(NSDictionary*)headerFields														// for external HTTP header fields
 downloadOffset:(unsigned long long)offset														// offset for file download
	   userInfo:(id)userInfo;
+ (id) head:(NSString*)url get:(NSDictionary*)get userInfo:(id)userInfo;
+ (id) get:(NSString*)url get:(NSDictionary*)get userInfo:(id)userInfo;
+ (id) postURLEncode:(NSString*)url get:(NSDictionary*)get post:(NSDictionary*)post userInfo:(id)userInfo;
+ (id) postFormData:(NSString*)url get:(NSDictionary*)get forms:(NSArray*)forms documents:(NSArray*)documents filenames:(NSArray*)filenames userInfo:(id)userInfo;
+ (id) postRaw:(NSString*)url get:(NSDictionary*)get post:(NSData*)post userInfo:(id)userInfo;
// operators
- (BOOL) start;
- (void) cancel;

@end


@interface URLConnectionBase ()
@property (readwrite,retain) NSThread *ownThread;
@property (readwrite,retain) NSURLConnection *connection;
@property (readwrite,retain) NSTimer *timeoutTimer;
- (void) terminate;
- (void) connectionDidTimeout;
- (void) openConnectionWithRequest:(NSURLRequest*)request inRunLoop:(NSRunLoop*)runLoop;
// worker threads
+ (void) globalThreadSelector;
- (void) ownThreadSelector;
// security checks
- (BOOL) shouldTrust:(SecTrustRef)trust certificateData:(NSData*)certificateData;				// server evaluates client's certificate
- (BOOL) checkCertificateForTrust:(SecTrustRef)trust againstHashes:(NSArray*)hashes;			// client evaluates server's certificate hash
@end
