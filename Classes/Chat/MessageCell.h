//
//  MessageCell.h
//  Teqball
//
//  Created by mohamed souiden on 08/07/16.
//  Copyright © 2016 Teqball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewSentMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageSender;
@property (weak, nonatomic) IBOutlet UILabel *textSender;
@property (weak, nonatomic) IBOutlet UIView *viewRecivedMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageRecieved;
@property (weak, nonatomic) IBOutlet UILabel *textRecived;
@property (strong,nonatomic) Message * msg;
@property (strong,nonatomic) NSString *url;

@end
