//
// ZDKBanafoContact.h
// ZDK
//

#ifndef ZDKBanafoContact_h
#define ZDKBanafoContact_h

#import <Foundation/Foundation.h>
#import "ZDKContactType.h"
#import "ZDKBanafoPhone.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Contact
*
*  Describes the Banafo contact.
*/
@protocol ZDKBanafoContact <ZDKZHandle>

/** \brief Banafo contact ID
*
*  ID of the contact in the external provider (if missing remote id, the returned value is the id from db).
*
*  \return The contact ID from the Banafo DB
*/
@property(nonatomic, readonly) NSString*  _Nullable banafoId;

/** \brief Remote provider contact ID
*
*  ID of the contact in the external provider.
*
*  \return The contact ID from the external provider DB
*/
@property(nonatomic, readonly) NSString*  _Nullable remoteId;

/** \brief Remote contact provider
*
*  Provider of the contact (external contact provider, might be CRM provider or zoiper).
*
*  \return The provider of the contact
*/
@property(nonatomic, readonly) NSString*  _Nullable remoteProvider;

/** \brief Fullname of the contact
*
*  Fullname of the contact.
*
*  \return The fullname of the contact
*/
@property(nonatomic, readonly) NSString*  _Nullable displayName;

/** \brief Firstname of the contact
*
*  Firstname of the contact.
*
*  \return The firstname of the contact
*/
@property(nonatomic, readonly) NSString*  _Nullable firstName;

/** \brief Middlename of the contact
*
*  Middlename of the contact.
*
*  \return The middlename of the contact
*/
@property(nonatomic, readonly) NSString*  _Nullable middleName;

/** \brief Lastname of the contact
*
*  Lastname of the contact.
*
*  \return The lastname of the contact
*/
@property(nonatomic, readonly) NSString*  _Nullable lastName;

/** \brief Type of the contact
*
*  Type of the contact, depends on the provider's supported types.
*
*  \return The contact type
*
*  \see ContactType
*/
@property(nonatomic, readonly) ZDKContactType  type;

/** \brief URL to the contact's page
*
*  Link to contact's page in the specific provider.
*
*  \return The URL to the contact's page
*/
@property(nonatomic, readonly) NSString*  _Nullable url;

/** \brief Name of the company
*
*  Name of the company.
*
*  \return The name of the company
*/
@property(nonatomic, readonly) NSString*  _Nullable company;

/** \brief List of emails of the contact
*
*  List of emails of the contact.
*
*  \return The list of emails of the contact
*/
@property(nonatomic, readonly) NSArray*  _Nullable emails;

/** \brief List of phones of the contact
*
*  List of phones of the contact.
*
*  \return The list of phones of the contact
*
*  \see ZDKBanafoPhone
*/
@property(nonatomic, readonly) NSArray<id<ZDKBanafoPhone>>*  _Nullable phones;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
