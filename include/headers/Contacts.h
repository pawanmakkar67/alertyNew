//
//  Contacts.h
//
//  Created by Bence Balint on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_ADDRESS_BOOK
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@class Contacts;

@protocol ContactsDelegate <NSObject>
@optional
- (void) contacts:(Contacts*)contacts didSelectPerson:(ABRecordRef)person;
- (void) contacts:(Contacts*)contacts didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
- (void) contactsDidCancel:(Contacts*)contacts;
- (void) contactsDidDismiss:(Contacts*)contacts;
@end


@interface Contacts : NSObject <ABPeoplePickerNavigationControllerDelegate>
{
	id<ContactsDelegate> _delegate;
	UIViewController *_ownerViewController;
	BOOL _numberPicker;
	BOOL _placePicker;
	ABPeoplePickerNavigationController *_peoplePicker;
}

@property (readwrite,assign) IBOutlet UIViewController *ownerViewController;
@property (readonly) ABPeoplePickerNavigationController *peoplePicker;

+ (id) showPersonPicker:(UIViewController*)ownerViewController delegate:(id<ContactsDelegate>)delegate;
+ (id) showNumberPicker:(UIViewController*)ownerViewController delegate:(id<ContactsDelegate>)delegate;
+ (id) showPlacePicker:(UIViewController*)ownerViewController delegate:(id<ContactsDelegate>)delegate;

- (void) dismiss;

+ (BOOL) isDomesticNumber:(NSString*)phone;
+ (BOOL) isGermanNumber:(NSString*)phone;

+ (NSString*) realPhoneNumber:(NSString*)phone;
+ (BOOL) isPhoneNumber:(NSString*)phone;

+ (NSString*) addressBookTipByName:(NSString*)name exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookTipByPhone:(NSString*)phone exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookTipByFax:(NSString*)fax exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookPhoneTipByPhone:(NSString*)phone exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookPhoneTipByFax:(NSString*)fax exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookTipForPhone:(NSString*)phone exactMatch:(BOOL)exactMatch numberTip:(BOOL)numberTip;
+ (NSString*) addressBookTipForFax:(NSString*)fax exactMatch:(BOOL)exactMatch numberTip:(BOOL)numberTip;
+ (NSString*) addressBookTipForNumber:(NSString*)number exactMatch:(BOOL)exactMatch numberTip:(BOOL)numberTip label:(NSString*)label;

+ (NSString*) addressBookFirstMobileFor:(NSString*)name exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookFirstFaxFor:(NSString*)name exactMatch:(BOOL)exactMatch;
+ (NSString*) addressBookFirstFor:(NSString*)name exactMatch:(BOOL)exactMatch label:(NSString*)label;
+ (NSString*) addressBookFirstNumber:(NSString*)name exactMatch:(BOOL)exactMatch;

+ (NSString*) fullNameForPerson:(ABRecordRef)person;
+ (NSDictionary*) items:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
+ (NSString*) cityForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
+ (NSString*) streetForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
+ (NSString*) zipForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;

// helper method to open address book (for new DataIsolation API in iOS 6)
+ (id) accessAddressBookAndDo:(id (^)(ABAddressBookRef addressBook))codeBlock;

// external change notification
- (void) addressBookDirty;

// appearance override
- (void) customizeOutlook;

@end
#endif
