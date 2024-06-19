//
//  IconDownloader.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IconDownloader : NSObject

@property (nonatomic, copy) void (^completionHandler)(UIImage *image, BOOL shouldRefresh);
@property (nonatomic, strong) NSString  *iconUrl;
@property (nonatomic) NSString *fileName;

+ (UIImage*) getIcon:(NSString*) fileName;
- (void)startDownload;
- (void)cancelDownload;

@end
