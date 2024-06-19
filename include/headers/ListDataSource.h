//
//  ListDataSource.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLFetcher.h"
#import "ListDataParser.h"
#import "ParallelDownload.h"
#import "DataSourceStates.h"
#import "ListItem.h"


@protocol ListDataSourceBase;

@protocol ListDataSourceDelegate <NSObject>
@required
- (void) dataSourceSuccess:(id<ListDataSourceBase>)datasource;
- (void) dataSourceFail:(id<ListDataSourceBase>)datasource;
@optional
- (void) dataSourceUpdateSuccess:(id<ListDataSourceBase>)datasource index:(NSInteger)index;
- (void) dataSourceUpdateFail:(id<ListDataSourceBase>)datasource index:(NSInteger)index;
- (void) dataSourceUpdateSuccess:(id<ListDataSourceBase>)datasource indexPath:(NSIndexPath*)indexPath;
- (void) dataSourceUpdateFail:(id<ListDataSourceBase>)datasource indexPath:(NSIndexPath*)indexPath;
@end


@protocol ListDataSourceBase <NSObject>
@required
- (id) initWithDelegate:(id<ListDataSourceDelegate>)delegate parser:(id<ListDataParser>)parser;
- (void) get:(id)param;
- (void) cancel;
- (NSError*) error;
- (DSStatus) status;
- (void) clear;
- (void) invalidate;
- (Class) itemClass;
@end


@protocol ListDataSource <ListDataSourceBase>
@property (readwrite,assign) NSInteger total;
@property (readonly,retain) NSMutableArray *list;
@end


@protocol PlainSectionedListDataSource <ListDataSourceBase>
@property (readwrite,assign) NSInteger total;
@property (readonly,retain) NSMutableArray *headers;
@property (readonly,retain) NSMutableArray *footers;
@property (readonly,retain) NSMutableArray *lists;
@end


extern NSString *const DSParameterURLKey;
extern NSString *const DSParameterGETKey;


@interface ListDataSourceBase : NSObject <ListDataSource,
										  URLFetcherDelegate,
										  ListItemDelegate>
{
	id<ListDataSourceDelegate> _delegate;
	id<ListDataParser> _parser;
	NSMutableArray *_list;
//	NSInteger _total;
	URLFetcher *_fetcher;
	NSError *_error;
	DSStatus _status;
}

@end


@interface ListDataSourceBase ()
@property (readwrite,assign) id<ListDataSourceDelegate> delegate;
@property (readwrite,retain) id<ListDataParser> parser;
@property (readwrite,retain) NSMutableArray *list;
@property (readwrite,retain) URLFetcher *fetcher;
@property (readwrite,retain) NSError *error;
@property (nonatomic,assign) DSStatus status;
- (void) processResponse:(NSData*)data;
@end


@interface TransparentListDataSource : NSObject <ListDataSource,
												 ListItemDelegate>
{
	id<ListDataSourceDelegate> _delegate;
	DSStatus _status;
}

@end


@interface TransparentListDataSource ()
@property (readwrite,assign) id<ListDataSourceDelegate> delegate;
@property (nonatomic,assign) DSStatus status;
@end


@interface PlainSectionedListDataSourceBase : NSObject <PlainSectionedListDataSource,
														URLFetcherDelegate,
														ListItemDelegate>
{
	id<ListDataSourceDelegate> _delegate;
	id<ListDataParser> _parser;
	NSMutableArray *_lists;
	NSMutableArray *_headers;
	NSMutableArray *_footers;
//	NSInteger _total;
	URLFetcher *_fetcher;
	NSError *_error;
	DSStatus _status;
}

@end


@interface PlainSectionedListDataSourceBase ()
@property (readwrite,assign) id<ListDataSourceDelegate> delegate;
@property (readwrite,retain) id<ListDataParser> parser;
@property (readwrite,retain) NSMutableArray *lists;
@property (readwrite,retain) NSMutableArray *headers;
@property (readwrite,retain) NSMutableArray *footers;
@property (readwrite,retain) URLFetcher *fetcher;
@property (readwrite,retain) NSError *error;
@property (nonatomic,assign) DSStatus status;
- (void) processResponse:(NSData*)data;
@end


@interface SectionedListDataSourceBase : NSObject <PlainSectionedListDataSource,
												   ListItemDelegate>
{
	id<ListDataSourceDelegate> _delegate;
	id<ListDataParser> _parser;
	NSMutableArray *_lists;
	NSMutableArray *_headers;
	NSMutableArray *_footers;
//	NSInteger _total;
	NSError *_error;
	DSStatus _status;
	BOOL _createListItems;
}

@property (readwrite,assign) BOOL createListItems;

@end


@interface SectionedListDataSourceBase ()
@property (readwrite,assign) id<ListDataSourceDelegate> delegate;
@property (readwrite,retain) id<ListDataParser> parser;
@property (readwrite,retain) NSMutableArray *lists;
@property (readwrite,retain) NSMutableArray *headers;
@property (readwrite,retain) NSMutableArray *footers;
@property (readwrite,retain) NSError *error;
@property (nonatomic,assign) DSStatus status;

@end
