//
// ZDKBanafoContactSearchCriteria.h
// ZDK
//

#ifndef ZDKBanafoContactSearchCriteria_h
#define ZDKBanafoContactSearchCriteria_h

#import <Foundation/Foundation.h>
#import "ZDKContactType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo listing contacts search criteria
*
*  Describes the search criteria used for listing Banafo contacts.
*/
@protocol ZDKBanafoContactSearchCriteria <ZDKZHandle>

/** \brief Contact ID of the required contact
*
*  Contact ID of the required contact.
*  If set, a search for specific contact will be made. In that case 'Provider()' MUST also be set and 'Types()' MUST have a
*  single type filled in. All other parameters will be discarded!
*
*  \return The contact ID of the required contact
*/
@property(nonatomic, readonly) NSString*  _Nullable contactId;

/** \brief Contacts provider to be searched for
*
*  Slug that specifies the provider contacts desired, could be set to "banafo" for local contacts, if not specified
*  contacts for all active providers will be returned.
*  Example: zoho
*
*  \return The provider which contacts to be searched for
*/
@property(nonatomic, readonly) NSString*  _Nullable provider;

/** \brief Word to search for
*
*  Word to search for - name, company name, email, phone, etc.
*  Example: John
*
*  \return The word to search for
*/
@property(nonatomic, readonly) NSString*  _Nullable search;

/** \brief List of types to filter by
*
*  List of types to filter by. If not specified it looks for all supported types by the provider.
*  Example: ContactType::Lead, ContactType::Account
*
*  \return The list of types to filter by
*/
@property(nonatomic, readonly) NSArray<NSNumber*>*  _Nullable types;

/** \brief Phone number to search for
*
*  Phone number to search for.
*  Example: +61 1900 321 555
*
*  \return The phone number to search for
*/
@property(nonatomic, readonly) NSString*  _Nullable phone;

/** \brief National number for improved phone number searches
*
*  National number for improved phone number searches, taken into account only when 'Phone()' is also present.
*  Example: 1900321555
*
*  \return The national number for improved phone number searches
*/
@property(nonatomic, readonly) NSString*  _Nullable nationalNumber;

/** \brief Reverse phone lookup
*
*  Indicates whether the search will be a Reverse Lookup or normal Contact Listing.
*  In case is set to 'true', 'Region()' and 'Phone()' MUST be set while all other parameters will be discarded!
*
*  \return
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic, readonly) BOOL  reverseLookup;

/** \brief Region code
*
*  Two-letter region code for parsing phone numbers without county code.
*  Example: AU
*
*  \return The region code
*/
@property(nonatomic, readonly) NSString*  _Nullable region;

/** \brief Starting offset
*
*  The number of contacts wished to be skipped before selecting records (if start is not provide, start will be
*  set to 0 as a default), pagination will only work if the provider is specified.
*  Example: 0
*
*  \return The starting offset
*/
@property(nonatomic, readonly) int  start;

/** \brief Number of retrieved contacts limit
*
*  Number of contacts per page (if limit is not provided, the maximum limit per provider will be used), pagination will
*  only work if the provider is specified.
*  Example: 10
*
*  \return The number of retrieved contacts limit
*/
@property(nonatomic, readonly) int  limit;

/** \brief Next page ID
*
*  Unique next page id, required by some CRMs to get next page results (PageId could be found in pagination object of
*  the previous page request's response).
*  Example: eu4hru34hrfu43irh3
*
*  \return The next page ZDKD
*/
@property(nonatomic, readonly) NSString*  _Nullable pageId;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
