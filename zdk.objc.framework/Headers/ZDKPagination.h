//
// ZDKPagination.h
// ZDK
//

#ifndef ZDKPagination_h
#define ZDKPagination_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Search pagination
*
*  Describes the search pagination used for paged searching.
*/
@protocol ZDKPagination <ZDKZHandle>

/** \brief Next page URL
*
*  Next page URL.
*
*  \return The next page URL
*/
@property(nonatomic, readonly) NSString*  _Nullable nextPageUrl;

/** \brief Specifies the possibility of having a next page
*
*  Specifies the possibility of having a next page.
*
*  \return
*  \li 0 - next page is available
*  \li 1 - next page is NOT available
*/
@property(nonatomic, readonly) BOOL  nextPage;

/** \brief The number of skipped contacts in the next page
*
*  The number of contacts skipped before selecting records for next page.
*
*  \return The number of skipped contacts in the next page
*/
@property(nonatomic, readonly) int  nextStart;

/** \brief Number of selected next page records
*
*  Number of selected next page records.
*
*  \return Number of selected next page records
*/
@property(nonatomic, readonly) int  nextLimit;

/** \brief Next page ID
*
*  Next page ID for CRMs that supports this type of pagination.
*
*  \return The next page ZDKD
*/
@property(nonatomic, readonly) NSString*  _Nullable nextPageId;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
