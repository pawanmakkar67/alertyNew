//
//  NSFileManagerAdditions.h
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


@interface NSFileManager (ExtendedMethods)

+ (BOOL) saveData:(NSData*)data toPath:(NSString*)ffn;
+ (BOOL) saveData:(NSData*)data toPath:(NSString*)ffn error:(NSError**)error;
+ (unsigned long long) fileSize:(NSString*)path;
+ (BOOL) appendFile:(NSString*)path data:(NSData*)data;
+ (BOOL) deleteFile:(NSString*)path;
+ (BOOL) createFile:(NSString*)path;
+ (BOOL) existsFile:(NSString*)path;
+ (BOOL) existsFile:(NSString*)path isDirectory:(BOOL*)isDirectory;
+ (BOOL) deleteDirectory:(NSString*)path;
+ (BOOL) createDirectory:(NSString*)path;
+ (BOOL) existsDirectory:(NSString*)path;
+ (BOOL) copyFileFrom:(NSString*)fromPath to:(NSString*)toPath;
+ (BOOL) moveFileFrom:(NSString*)fromPath to:(NSString*)toPath;
+ (NSArray*) list:(NSString*)path;
+ (NSArray*) list:(NSString*)path type:(NSString*)type;
+ (NSArray*) list:(NSString*)path type:(NSString*)type prefix:(NSString*)prefix;
+ (NSArray*) list:(NSString*)path type:(NSString*)type prefix:(NSString*)prefix dirs:(BOOL)dirs;
+ (NSArray*) listAll:(NSString*)path;
+ (NSArray*) recursiveList:(NSString*)path;
+ (NSArray*) recursiveList:(NSString*)path type:(NSString*)type;
+ (NSArray*) recursiveList:(NSString*)path type:(NSString*)type prefix:(NSString*)prefix;
+ (NSArray*) recursiveList:(NSString*)path type:(NSString*)type prefix:(NSString*)prefix dirs:(BOOL)dirs;
+ (NSArray*) recursiveListAll:(NSString*)path;
+ (NSArray*) finderList:(NSString*)path;
+ (NSArray*) finderList:(NSString*)path type:(NSString*)type;
+ (NSArray*) directories:(NSString*)path;
+ (BOOL) isDirectoryEmpty:(NSString*)path;
+ (NSDate*) modificationDate:(NSString*)path;
+ (NSDate*) creationDate:(NSString*)path;
+ (BOOL) excludeFromBackup:(NSString*)path exclude:(BOOL)exclude;

@end
