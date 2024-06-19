//
//  CustomSwitch.h
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 11..
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomSwitchBtn : UIButton{

}

@property(nonatomic, retain) UIImage* onImage;
@property(nonatomic, retain) UIImage* offImage;
@property(nonatomic, assign) BOOL statusBtn;
- (void)setStatusBtn:(BOOL)status;



@end

NS_ASSUME_NONNULL_END
