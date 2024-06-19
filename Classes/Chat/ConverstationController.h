//
//  ConverstationController.h
//  Maps
//
//  Created by Gergely Meszaros-Komaromy on 05/08/16.
//  Copyright © 2016 MapsWithMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioVideo/TwilioVideo.h>

@interface ConverstationController : UIViewController <TVIRemoteDataTrackDelegate>

@property (nonatomic, strong) TVILocalDataTrack *localDataTrack;

@property (nonatomic, strong) NSMutableDictionary* participants;

@end
