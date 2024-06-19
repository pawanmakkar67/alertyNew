//
//  MediaPicker.h
//
//  Created by Bence Balint on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_MEDIA
#import <UIKit/UIKit.h>
#if HAVE_MEDIA_LIBRARY
#import <MediaPlayer/MediaPlayer.h>
#endif
#if HAVE_ASSETS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#import "TSLibraryImport.h"
#import <AVFoundation/AVFoundation.h>
#endif
#if HAVE_MEDIA_AUDIO
#import <AVFoundation/AVFoundation.h>
#endif


// MediaPicker prefixes
extern NSString *const MPImagePrefix;
extern NSString *const MPTrackPrefix;
extern NSString *const MPVideoPrefix;
extern NSString *const MPAudioPrefix;

// MediaDescriptor descriptor
extern NSString *const MDIDKey;
extern NSString *const MDFileNameKey;
extern NSString *const MDTitleKey;
extern NSString *const MDAlbumKey;
extern NSString *const MDArtistKey;
extern NSString *const MDGenreKey;
extern NSString *const MDDurationKey;
extern NSString *const MDBPMKey;
extern NSString *const MDWidthKey;
extern NSString *const MDHeightKey;


#if HAVE_ASSETS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
typedef enum {
	AESuccess			= 0,
	AEDRMError			= 1,
	AEExportError		= 2,
	AEExceptionError	= 3
} AssetExportError;
#endif


@class MediaPicker;

@protocol MediaPickerDelegate <NSObject>
@optional
- (void) mediaPicker:(MediaPicker*)mediaPicker didChooseImage:(UIImage*)image;
- (void) mediaPicker:(MediaPicker*)mediaPicker didChooseVideo:(NSString*)url;
- (void) mediaPickerDidFinishImportingImage:(MediaPicker*)mediaPicker;
- (void) mediaPickerDidFinishImportingVideo:(MediaPicker*)mediaPicker;
#if HAVE_MEDIA_LIBRARY
- (void) mediaPicker:(MediaPicker*)mediaPicker didChooseSongs:(MPMediaItemCollection*)songs;
#endif
#if HAVE_MEDIA_AUDIO
- (void) mediaPicker:(MediaPicker*)mediaPicker didChooseAudio:(NSString*)url;
- (void) mediaPickerDidFinishImportingAudio:(MediaPicker*)mediaPicker;
#endif
#if HAVE_ASSETS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
- (BOOL) mediaPicker:(MediaPicker*)mediaPicker songImportDidSucceed:(NSDictionary*)descriptor;
- (BOOL) mediaPicker:(MediaPicker*)mediaPicker songImportDidFail:(NSDictionary*)descriptor error:(AssetExportError)error;
- (void) mediaPickerDidFinishImportingSongs:(MediaPicker*)mediaPicker;
#endif
- (void) mediaPickerWillDismiss:(MediaPicker*)mediaPicker;
- (void) mediaPickerDidDismiss:(MediaPicker*)mediaPicker;
@end


#if HAVE_MEDIA_AUDIO
@protocol AudioRecorderInterface <NSObject>
@required
- (MediaPicker*) ownerPicker;
- (void) setOwnerPicker:(MediaPicker*)ownerPicker;
- (void) setShouldAutorotate:(BOOL)shouldAutorotate;
@optional
- (void) audioRecorderDidStart:(MediaPicker*)mediaPicker;
- (void) audioRecorderDidStop:(MediaPicker*)mediaPicker;
- (void) audioRecorderErrorDidOccur:(MediaPicker*)mediaPicker;
- (void) audioRecorderBeginInterruption:(MediaPicker*)mediaPicker;
- (void) audioRecorderEndInterruption:(MediaPicker*)mediaPicker;
@end
#endif


@interface MediaPicker : NSObject <UINavigationControllerDelegate,
								   UIImagePickerControllerDelegate
#if HAVE_MEDIA_LIBRARY
								   , MPMediaPickerControllerDelegate
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
								   , UIPopoverControllerDelegate
#endif
#if HAVE_MEDIA_AUDIO
								   , AVAudioRecorderDelegate
#endif
>
{
	id<MediaPickerDelegate> _delegate;
	id _userInfo;
	UIViewController *_ownerViewController;
	UIImagePickerController *_imagePicker;
	BOOL _captureVideo;
	BOOL _importVideos;
	NSString *_videoDirectory;
	BOOL _importImages;
	NSString *_imageDirectory;
	BOOL _asJPG;
	CGSize _desiredSize;
	CGFloat _jpgQuality;
	NSDictionary *_lastImportedMediaDescriptor;
#if HAVE_MEDIA_LIBRARY
	MPMediaPickerController *_mediaPicker;
#endif
#if HAVE_ASSETS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	BOOL _importAssets;
	NSString *_assetDirectory;
	NSMutableArray *_itemsToImport;
	NSMutableArray *_itemsImported;
	NSMutableArray *_itemsFailed;
	TSLibraryImport *_assetSession;
	BOOL _importCancelled;
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	UIPopoverController *_contentPopover;
#endif
#if HAVE_MEDIA_AUDIO
	AVAudioRecorder *_audioRecorder;
	BOOL _importAudios;
	NSString *_audioDirectory;
	UIViewController<AudioRecorderInterface> *_audioRecorderInterface;
#endif
	BOOL _dismissedByUserInteraction;
	BOOL _imageNormalizationDisabled;
}

@property (readwrite,assign) IBOutlet UIViewController *ownerViewController;
@property (readwrite,assign) id<MediaPickerDelegate> delegate;
@property (readwrite,retain) id userInfo;
@property (readwrite,retain) UIImagePickerController *imagePicker;
@property (readwrite,assign) BOOL captureVideo;
@property (readwrite,assign) BOOL importVideos;
@property (readwrite,retain) NSString *videoDirectory;
#if HAVE_MEDIA_LIBRARY
@property (readwrite,retain) MPMediaPickerController *mediaPicker;
#endif
@property (readwrite,assign) BOOL importImages;
@property (readwrite,retain) NSString *imageDirectory;
@property (readwrite,assign) BOOL asJPG;
@property (readwrite,assign) CGSize desiredSize;
@property (readwrite,assign) CGFloat jpgQuality;
@property (readwrite,retain) NSDictionary *lastImportedMediaDescriptor;
#if HAVE_ASSETS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
@property (readwrite,assign) BOOL importAssets;
@property (readwrite,retain) NSString *assetDirectory;
@property (readwrite,retain) NSMutableArray *itemsToImport;
@property (readwrite,retain) NSMutableArray *itemsImported;
@property (readwrite,retain) NSMutableArray *itemsFailed;
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
@property (readwrite,retain) UIPopoverController *contentPopover;
#endif
#if HAVE_MEDIA_AUDIO
@property (readwrite,retain) AVAudioRecorder *audioRecorder;
@property (readwrite,assign) BOOL importAudios;
@property (readwrite,retain) NSString *audioDirectory;
@property (readwrite,retain) UIViewController<AudioRecorderInterface> *audioRecorderInterface;
#endif
@property (readwrite,assign,getter=isDismissedByUserInteraction) BOOL dismissedByUserInteraction;
@property (readwrite,assign,getter=isImageNormalizationDisabled) BOOL imageNormalizationDisabled;

+ (NSArray*) availablePhotoSourceTypes;
+ (NSArray*) availableMediaTypesForSource:(UIImagePickerControllerSourceType)sourceType;
+ (NSArray*) availableCaptureModesForCamera:(UIImagePickerControllerCameraDevice)cameraDevice;

+ (id) captureVideoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate quality:(UIImagePickerControllerQualityType)quality editable:(BOOL)editable;
+ (id) importVideoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate quality:(UIImagePickerControllerQualityType)quality editable:(BOOL)editable videoDirectory:(NSString*)directory;
+ (id) importVideoFromSavedVideos:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable videoDirectory:(NSString*)directory popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) importVideoFromSavedVideos:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable videoDirectory:(NSString*)directory popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;

+ (id) takePhotoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable;
+ (id) importPhotoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable imageDirectory:(NSString*)directory desiredSize:(CGSize)size asJPG:(BOOL)jpg jpgQuality:(CGFloat)quality;

+ (id) choosePhotoFromSavedPhotos:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) choosePhotoFromSavedPhotos:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;
+ (id) importPhotoFromSavedPhotos:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable imageDirectory:(NSString*)directory desiredSize:(CGSize)size asJPG:(BOOL)jpg jpgQuality:(CGFloat)quality popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) importPhotoFromSavedPhotos:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable imageDirectory:(NSString*)directory desiredSize:(CGSize)size asJPG:(BOOL)jpg jpgQuality:(CGFloat)quality popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;
+ (id) choosePhotoFromPhotoLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) choosePhotoFromPhotoLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;
+ (id) importPhotoFromMediaLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable imageDirectory:(NSString*)directory desiredSize:(CGSize)size asJPG:(BOOL)jpg jpgQuality:(CGFloat)quality popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) importPhotoFromMediaLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate editable:(BOOL)editable imageDirectory:(NSString*)directory desiredSize:(CGSize)size asJPG:(BOOL)jpg jpgQuality:(CGFloat)quality popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;

#if HAVE_MEDIA_LIBRARY
+ (id) chooseSongsFromMediaLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate multiselect:(BOOL)multiselect popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) chooseSongsFromMediaLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate multiselect:(BOOL)multiselect popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;
#endif
#if HAVE_MEDIA_AUDIO
+ (id) recordAudioFromMicrophone:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate quality:(AVAudioQuality)quality;
+ (id) importAudioFromMicrophone:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate quality:(AVAudioQuality)quality audioDirectory:(NSString*)directory;
- (void) startAudioRecord;
- (void) stopAudioRecord;
- (void) cancelAudioRecord;
#endif
#if HAVE_ASSETS && __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
+ (id) importSongsFromMediaLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate multiselect:(BOOL)multiselect assetDirectory:(NSString*)directory popoverSize:(CGSize)popoverSize popoverFrom:(CGRect)popoverFrom;
+ (id) importSongsFromMediaLibrary:(UIViewController*)ownerViewController delegate:(id<MediaPickerDelegate>)delegate multiselect:(BOOL)multiselect assetDirectory:(NSString*)directory popoverSize:(CGSize)popoverSize popoverButton:(UIBarButtonItem*)popoverButton;
- (void) cancelAssetImporting;
#endif
- (void) dismiss:(BOOL)animated;
- (void) cancelImportingAndUnregisterDelegate;

+ (NSDictionary*) mediaDescriptorWithID:(NSInteger)idx
							   fileName:(NSString*)fileName
								  title:(NSString*)title;

+ (NSDictionary*) mediaDescriptorWithID:(NSInteger)idx
							   fileName:(NSString*)fileName
								  title:(NSString*)title
								  width:(CGFloat)width
								 height:(CGFloat)height;

+ (NSDictionary*) mediaDescriptorWithID:(NSInteger)idx
							   fileName:(NSString*)fileName
								  title:(NSString*)title
								  album:(NSString*)album
								 artist:(NSString*)artist
								  genre:(NSString*)genre
							   duration:(NSTimeInterval)duration
									bpm:(NSUInteger)bpm;

@end
#endif
