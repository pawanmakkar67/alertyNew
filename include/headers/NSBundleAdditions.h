//
//  NSBundleAdditions.h
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


@interface NSBundle (ExtendedMethods)

+ (id) loadFirstFromNib:(NSString*)name;
+ (id) loadFirstFromNib:(NSString*)name bundle:(NSBundle*)bundle;
+ (id) loadNibNamed:(NSString*)name firstClass:(Class)cls;
+ (id) loadNibNamed:(NSString*)name firstClass:(Class)cls bundle:(NSBundle*)bundle;
+ (id) loadNibNamed:(NSString*)name firstClass:(Class)cls owner:(id)owner;
+ (id) loadNibNamed:(NSString*)name firstClass:(Class)cls owner:(id)owner bundle:(NSBundle*)bundle;
+ (id) loadNibNamed:(NSString*)name firstClass:(Class)cls owner:(id)owner proxy:(id)proxy;
+ (id) loadNibNamed:(NSString*)name firstClass:(Class)cls owner:(id)owner proxy:(id)proxy bundle:(NSBundle*)bundle;
+ (NSArray*) loadNibNamed:(NSString*)name;
+ (NSArray*) loadNibNamed:(NSString*)name bundle:(NSBundle*)bundle;
+ (NSArray*) loadNibNamed:(NSString*)name owner:(id)owner;
+ (NSArray*) loadNibNamed:(NSString*)name owner:(id)owner bundle:(NSBundle*)bundle;
+ (NSArray*) loadNibNamed:(NSString*)name owner:(id)owner proxy:(id)proxy;
+ (NSArray*) loadNibNamed:(NSString*)name owner:(id)owner proxy:(id)proxy bundle:(NSBundle*)bundle;

+ (id) extractObjectFrom:(NSArray*)topLevelObjects ofType:(Class)cls;

+ (NSBundle*) libraryBundle;

+ (NSString*) urlSchemeForRole:(NSString*)role;
- (NSString*) urlSchemeForRole:(NSString*)role;

@end
