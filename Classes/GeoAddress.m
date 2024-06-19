//
//  GeoAddress.m
//  Shareroutes
//
//  Created by moni on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoAddress.h"
#import "WifiApInfoViewController.h"

@interface GeoAddress() {
    NSMutableData *_responseData;
    NSURLConnection *_geoRequest;
}
@end

//static const NSString *GOOGLE_GEOCODE = @"https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyASh5SuqnnXaMB4Sh1ktiDJ6yt3k7P2XKk&latlng=";
static const NSString *GOOGLE_GEOCODE = @"https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyA8UkZXxX_KjZ6M8izUbYiY6SLbtHbyjQ0&latlng=";

@implementation GeoAddress 

- (void) getGeoAddressByCoordinate:(CLLocationCoordinate2D)_coord
{
	_geoRequest = nil;
	_responseData = [[NSMutableData alloc] initWithCapacity:65535];
	NSString *url = [NSString stringWithFormat:@"%@%f,%f&sensor=false", GOOGLE_GEOCODE, _coord.latitude, _coord.longitude];
	NSURL * urlObj = [[NSURL alloc] initWithString:url];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlObj cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	_geoRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _geoRequest = nil;
    _responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _geoRequest = nil;
    
    NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    _responseData = nil;
    if ([responseString length] > 0) {
        NSDictionary *jsonString = [responseString JSONValue];
        [self evaluateJSONString:jsonString];
    }
}

- (void)evaluateJSONString:(NSDictionary *)_jsonString {
	
	NSString *route = nil, *street_number = nil, *co = nil, *c = nil;
	NSString *status = [_jsonString objectForKey:@"status"];
	if( [status isEqualToString:@"OK"])
	{
		NSArray *results = [_jsonString objectForKey:@"results"];
		for (NSDictionary *result in results)	{
			NSArray *address_components = [result objectForKey:@"address_components"];
			for (NSDictionary *component in address_components) {
				NSArray *types = [component objectForKey:@"types"];
				for (NSString *type in types) {
					if ([type isEqualToString:@"route"]) {
                        NSString* r = [component objectForKey:@"long_name"];
                        if (![r containsString:@"Unnamed Road"]) {
                            route = r;
                        }
					}
					if ([type isEqualToString:@"street_number"] || [type isEqualToString:@"premise"]) {
						street_number = [component objectForKey:@"long_name"];
					}
					if ([type isEqualToString:@"country"]) {
						co = [component objectForKey:@"long_name"];
					}
					if ([type isEqualToString:@"locality"]) {
						c = [component objectForKey:@"short_name"];
					}
				}
			}
		}
	}
	if( street_number == nil )
		street_number = @"";
	if(route == nil)
		route = @"";
	if(c == nil)
		c = @"";
	if(co == nil)
		co = @"";
	
	if (self.delegate) {
		NSString* address = [NSString stringWithFormat:@"%@ %@, %@", route, street_number, c];
		self.delegate.text = address;
		return;
	}
	[DataManager sharedDataManager].lastLocation.userAddress = [NSString stringWithFormat:@"%@ %@", route, street_number];
	[DataManager sharedDataManager].lastLocation.userCountry = co;
	[DataManager sharedDataManager].lastLocation.userCity = c;
}

- (void) dealloc {
    [_geoRequest cancel];
}

@end

