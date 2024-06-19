//
//  NSExtensions.h
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

#import "NSExtensionsConfig.h"

#import "CATextLayerAdditions.h"
#import "CGDrawingAdditions.h"
#import "CIFilterAdditions.h"
#import "MKMapViewAdditions.h"
#import "NSArrayAdditions.h"
#import "NSArrayXMLAdditions.h"
#import "NSArrayXMLNonRecursiveFilteringAdditions.h"
#import "LibraryConfig.h"
#if HAVE_CORE_TEXT
#import "NSAttributedStringAdditions.h"
#endif
#import "NSBundleAdditions.h"
#import "NSCharacterSetAdditions.h"
#import "NSDataAdditions.h"
#import "NSDataMBBase64.h"
#import "NSDataNSDataExtension.h"
#import "NSDateAdditions.h"
#import "NSDateFormatterAdditions.h"
#import "NSDictionaryAdditions.h"
#import "NSDictionaryXMLAdditions.h"
#import "NSEnumeratorAdditions.h"
#import "NSErrorAdditions.h"
#import "NSFileHandleAdditions.h"
#import "NSFileManagerAdditions.h"
#import "NSHelpers.h"
#import "NSIndexPathAdditions.h"
#import "NSLocaleAdditions.h"
#import "NSMutableArrayAdditions.h"
#import "NSMutableDataAdditions.h"
#import "NSMutableDictionaryAdditions.h"
#import "NSMutableStringAdditions.h"
#import "NSNotificationAdditions.h"
#import "NSNotificationCenterAdditions.h"
#import "NSNullAdditions.h"
#import "NSNumberAdditions.h"
#import "NSNumberFormatterAdditions.h"
#import "NSObjectAdditions.h"
#import "NSRangeAdditions.h"
#import "NSStringAdditions.h"
#import "NSStringJustifiedAdditions.h"
#import "NSTimerAdditions.h"
#import "NSURLAdditions.h"
#import "NSUserDefaultsAdditions.h"
#import "OBIAutogrowTextView.h"								// under /OBIAutogrowTextInput/
#import "OBITextInput.h"									// under /OBIAutogrowTextInput/
#import "OBICaseInsensitiveStringExtensions.h"
#import "OBICoverFlow.h"									// under /OBICoverFlow/
#import "OBICryptoExtensions.h"
#import "OBIHashExtensions.h"
#import "OBIJustifiedTextFrame.h"							// under /OBIJustifiedTextFrame/
#import "OBIRandomExtensions.h"
#import "OBIScheduler.h"
#import "OBISchedulerFlag.h"
#import "OBISignExtensions.h"
#import "OBITableGrid.h"									// under /OBITableGrid/
#import "UIAlertViewAdditions.h"
#import "UIApplicationAdditions.h"
#import "UIBarButtonItemAdditions.h"
#import "UIButtonAdditions.h"
#import "UIColorAdditions.h"
#import "UIColorMixing.h"
#import "UIControlAdditions.h"
#import "UIDeviceAdditions.h"
#import "UIFontAdditions.h"
#import "UIImageAdditions.h"
#import "UIImageViewAdditions.h"
#import "UILabelAdditions.h"
#import "UIScreenAdditions.h"
#import "UIScrollViewAdditions.h"
#import "UISegmentedControlPrivateFramework.h"
#import "UITextFieldAdditions.h"
#import "UITextViewAdditions.h"
#import "UIViewAdditions.h"
#import "UIViewControllerAdditions.h"
