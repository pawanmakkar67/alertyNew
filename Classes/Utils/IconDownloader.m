//
//  IconDownloader.m
//
//

#import "IconDownloader.h"

@interface IconDownloader ()

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end


@implementation IconDownloader

+ (UIImage*) getIcon:(NSString*) fileName
{
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/icons/%@", docDir, fileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath: pngFilePath])
	{
		UIImage *image = [UIImage imageWithContentsOfFile:pngFilePath];
		return image;
	}
	return nil;
}

- (void)startDownload
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/icons/%@",docDir, self.fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath: pngFilePath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:pngFilePath];
        if (image) {
            if (self.completionHandler) {
                self.completionHandler(image, NO);
            }
            return;
        }
    }
    self.activeDownload = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.iconUrl]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeDownload = nil;
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    /*UIImage *finalImage;
    if (image.size.width != IconWidth || image.size.height != IconHeight)
    {
        CGSize itemSize = CGSizeMake(IconWidth, IconHeight);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        finalImage = image;
    }*/
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageCacheDirPath = [docDir stringByAppendingPathComponent:@"icons"];
    if (![[NSFileManager defaultManager] fileExistsAtPath: imageCacheDirPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheDirPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:NULL];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/icons/%@",docDir, self.fileName];
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data writeToFile:pngFilePath atomically:YES];
    self.activeDownload = nil;
    self.imageConnection = nil;
    
    if (self.completionHandler)
    {
        self.completionHandler(image, YES);
    }
}

@end
