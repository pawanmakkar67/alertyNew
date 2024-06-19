//
//  ICEContactCell.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICEContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contactRowID;
@property (strong, nonatomic) IBOutlet UILabel *contactRelation;
@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UILabel *contactPhone;

@property (strong, nonatomic) IBOutlet UIView *contactView;
@property (strong, nonatomic) IBOutlet UIView *contactAddView;
@property (strong, nonatomic) IBOutlet UILabel *addNewLabel;

@end
