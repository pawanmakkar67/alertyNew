//
//  LibraryConfig.h
//
// Copyright (c) 2008-2013 Bence Balint
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


// Library behavior
#define HAVE_CAPTURE										1
#define HAVE_MEDIA											1
#define HAVE_MEDIA_AUDIO									1
#define HAVE_MEDIA_LIBRARY									1
#define HAVE_AUDIO											1
#define HAVE_ASSETS											1
#define HAVE_FTP											1
#define HAVE_REACHABILITY									1
#define USE_REACHABILITY_22									0
#define USE_REACHABILITY_30									1
#define HAVE_CJSON											0
#define HAVE_EXTERNAL_ACCESSORY								1
#define HAVE_ADDRESS_BOOK									1
#define HAVE_CORE_TEXT										1
#define HAVE_CORE_IMAGE_FILTER								1
#define HAVE_MOVIE_PLAYER									1
#define HAVE_OPEN_GL										1
#define HAVE_CUSTOM_ALERT									0
#define HAVE_IAP											1
#define HAVE_CORE_LOCATION									1
#define HAVE_MAP_KIT										1
#define HAVE_FMDATABASE										1


// IAP url definitions
#define kIAPGetProductIdentifiersURL						@"http://www.viking.tm/iap_get_identifiers"
#define kIAPPurchaseURL										@"http://www.viking.tm/iap_purchase"
#define kIAPRestoreURL										@"http://www.viking.tm/iap_restore"
#define kIAPCheckPurchasedContentURL						@"http://www.viking.tm/iap_verification_status"


// APNS url definitions
#define kAPNSRegisterTokenURL								@"http://www.viking.tm/apns_register_token"
#define kAPNSUnregisterTokenURL								@"http://www.viking.tm/apns_unregister_token"


// TranslucentToolbar
#define TOOLBAR_ENABLE_DYNAMIC_WIDTH_CALCULATION			0						// uses: [UIBarButtonItem valueForKey:@"view"] (KVC framework)
#define kTranslucentToolbarStandardMargin					9.0						// iOS defult
#define kTranslucentToolbarStandardSpacing					10.0					// iOS defult
#define kTranslucentToolbarFixedLeftMargin					9.0
#define kTranslucentToolbarFixedRightMargin					3.0
#define kTranslucentToolbarFixedSpacing						10.0
#define kTranslucentToolbarFixedItemWidthPortrait			44.0
#define kTranslucentToolbarFixedItemWidthLandscape			34.0


// TranslucentToolbar
#define PICKER_ENABLE_SMALL_SIZE							1						// uses: reverse-engeneered number to set height


// Import the rest (app specific config redefines)
#import "config.library.h"

