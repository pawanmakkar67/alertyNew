//
//  UIDeviceAdditions.h
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
#import "LibraryConfig.h"
#if HAVE_AUDIO
#import <AudioToolbox/AudioServices.h>		// for sound IDs
#endif


@interface UIDevice (ExtendedMethods)

#if HAVE_AUDIO
+ (void) vibrate;
+ (void) beep:(NSString*)name;
+ (BOOL) isMuted;							// works only on iOS < 5.0
#endif
// From the 1st, May 2013 Apple will reject the app which will use uniqueIdentifier.
// Therefore UDID and formattedUDID are mapped to MAC and formattedMAC.
// Apple decided to give back constant 3C-00-00-00-00-00 for MAC address now on.
// Therefore use [UIDevice identifierForVendor] now on.
+ (NSString*) MAC;
+ (NSString*) formattedMAC;
+ (NSString*) UDID;
+ (NSString*) formattedUDID;
+ (NSString*) vendorID;
+ (NSString*) formattedVendorID;

+ (NSString*) machine;
+ (BOOL) isIPadDevice;
+ (BOOL) isIPhoneDevice;
+ (BOOL) isIPhone5Device;
+ (BOOL) isIPad;
+ (BOOL) isIPhone;
+ (BOOL) isIPhone5;
+ (BOOL) appBackgroundingSupported;
+ (NSString*) preferredLanguage;
+ (NSString*) preferredFormat;
+ (NSString*) twoCharacterPreferredLanguage;
+ (NSString*) OSVersionString;
+ (NSString*) OSMajorString;
+ (NSString*) OSMinorString;
+ (NSString*) OSBuildString;
+ (double) OSVersion;
+ (NSInteger) OSMajor;
+ (NSInteger) OSMinor;
+ (NSInteger) OSBuild;
+ (unsigned long long) fullDiskSize;
+ (unsigned long long) freeDiskSize;
+ (unsigned long long) usedDiskSize;
+ (unsigned long int) fullMemSize;
+ (unsigned long int) freeMemSize;
+ (unsigned long int) usedMemSize;
+ (unsigned long int) appMemSize;
+ (unsigned long int) virtualMemSize;
+ (UIInterfaceOrientation) realInterfaceOrientation;

@end
