//
//  UIApplicationAdditions.h
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
#import <UIKit/UIKit.h>
#import "NSExtensionsConfig.h"


@interface UIApplication (ExtendedMethods)

// uses: valueForKey: on [UIApplication sharedApplication].delegate to try to find the first view controller (keys: @"navigationController", "tabBarController")
+ (UIViewController*) firstController;
// uses: valueForKey: on [UIApplication sharedApplication].delegate to try to find the first view controller (keys: @"navigationController", "tabBarController")
+ (UIViewController*) firstModalController;
// uses: valueForKey: on [UIApplication sharedApplication].delegate to try to find the first view (keys: @"navigationController", "tabBarController", "window")
+ (UIView*) firstView;

+ (void) exit;

+ (UIApplicationState) state;

+ (UIWindow*) window;
+ (CGRect) mainBounds;
+ (CGRect) mainRect;

+ (NSString*) urlFilePath:(NSString*)path;
+ (NSString*) urlPath:(NSString*)path prefix:(NSString*)prefix;

+ (NSString*) formattedAppendToPath:(NSString*)path fileName:(NSString*)fileName;
+ (NSString*) pathForDirectory:(NSSearchPathDirectory)searchPathDirectory fileName:(NSString*)fileName;
+ (NSString*) localized:(NSString*)localization resourcePath:(NSString*)fileName;
+ (NSString*) localized:(NSString*)localization resourcePathWithFormat:(NSString*)fileName arguments:(va_list)args;
+ (NSString*) localized:(NSString*)localization resourcePathWithFormat:(NSString*)fileName, ...;
+ (NSString*) bundlePath:(NSString*)fileName;
+ (NSString*) bundlePathWithFormat:(NSString*)fileName arguments:(va_list)args;
+ (NSString*) bundlePathWithFormat:(NSString*)fileName, ...;
+ (NSString*) cachePath:(NSString*)fileName;
+ (NSString*) cachePathWithFormat:(NSString*)fileName arguments:(va_list)args;
+ (NSString*) cachePathWithFormat:(NSString*)fileName, ...;
+ (NSString*) libraryPath:(NSString*)fileName;
+ (NSString*) libraryPathWithFormat:(NSString*)fileName arguments:(va_list)args;
+ (NSString*) libraryPathWithFormat:(NSString*)fileName, ...;
+ (NSString*) documentPath:(NSString*)fileName;
+ (NSString*) documentPathWithFormat:(NSString*)fileName arguments:(va_list)args;
+ (NSString*) documentPathWithFormat:(NSString*)fileName, ...;
+ (NSString*) tempPath:(NSString*)fileName;
+ (NSString*) tempPathWithFormat:(NSString*)fileName arguments:(va_list)args;
+ (NSString*) tempPathWithFormat:(NSString*)fileName, ...;

// e.g. "temp.txt" will be .../temppath/temp.XXXXXXXX.txt where 'X's will be replaced (the file will be created)
+ (NSString*) tempFile:(NSString*)fileName;
// e.g. "temp.txt" will be .../temppath/temp.XXXXXXXX.txt where 'X's will be replaced (the file will be created then deleted)
+ (NSString*) tempFileName:(NSString*)fileName;
// e.g. "temp.XXXXXXXX.txt" will be .../temppath/temp.XXXXXXXX.txt where 'X's will be replaced (the file will be created)
+ (NSString*) tempFileWithPattern:(NSString*)filePattern;
// e.g. "temp.XXXXXXXX.txt" will be .../temppath/temp.XXXXXXXX.txt where 'X's will be replaced (the file will be created then deleted)
+ (NSString*) tempFileNameWithPattern:(NSString*)filePattern;

+ (NSString*) generateUIDFor:(NSObject*)object;

+ (NSString*) developmentRegion;
+ (NSString*) displayName;
+ (NSString*) executableName;
+ (NSString*) bundleName;
+ (NSString*) bundleIdentifier;

+ (NSString*) bundleVersionString;
+ (NSString*) bundleMajorString;
+ (NSString*) bundleMinorString;
+ (NSString*) bundleBuildString;
+ (double) bundleVersion;
+ (NSInteger) bundleMajor;
+ (NSInteger) bundleMinor;
+ (NSInteger) bundleBuild;

+ (NSString*) appVersionString;
+ (NSString*) appMajorString;
+ (NSString*) appMinorString;
+ (NSString*) appBuildString;
+ (double) appVersion;
+ (NSInteger) appMajor;
+ (NSInteger) appMinor;
+ (NSInteger) appBuild;

+ (NSString*) currentThreadName;
+ (NSInteger) currentThreadNumber;

+ (BOOL) piracyCheckBySignerIdentity;

/*+ (NSString*) MIMETypeForFileAtPath:(NSString*)path defaultMIMEType:(NSString*)defaultType;*/

@end
