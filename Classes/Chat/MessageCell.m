//
//  MessageCell.m
//  Teqball
//
//  Created by mohamed souiden on 08/07/16.
//  Copyright © 2016 Teqball. All rights reserved.
//

#import "MessageCell.h"
#import "IconDownloader.h"
@interface MessageCell()

@property (strong, nonatomic) IconDownloader *iconDownloader;
@property (weak, nonatomic) IBOutlet UILabel *partnerLabel;

@end

@implementation MessageCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.iconDownloader = [[IconDownloader alloc] init];
  self.imageSender.layer.cornerRadius = 22;
}

-(void)setMsg:(Message *)msg{
  _msg = msg;
  self.imageSender.layer.cornerRadius = 22;
  self.imageSender.clipsToBounds = YES;
  self.imageRecieved.layer.cornerRadius = 22;
  self.imageRecieved.clipsToBounds = YES;
  if (!msg.sid.length) {
    self.viewRecivedMessage.hidden = NO;
    self.viewSentMessage.hidden = YES;
    self.textRecived.text = msg.message;
    [self drawTextInRect:self.textRecived.frame label:self.textRecived];
  } else {
    self.viewRecivedMessage.hidden = YES;
    self.viewSentMessage.hidden = NO;
    self.textSender.text = msg.message;
    [self drawTextInRect:self.textSender.frame label:self.textSender];
    self.partnerLabel.text = msg.sid;
  }
}

-(void)setUrl:(NSString *)url{
  _url = url;
  if (![url isKindOfClass:[NSNull class]]&& url != nil) {
    
    self.iconDownloader.iconUrl = url;
    NSString* removed=[url stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    self.iconDownloader.fileName = [NSString stringWithFormat:@"msg_%@.png", removed ];
    __weak MessageCell* weakSelf = self;
    [self.iconDownloader setCompletionHandler:^(UIImage *image, BOOL shouldRefresh){
      weakSelf.imageSender.image = image;
    }];
    [self.iconDownloader startDownload];
  }
}

- (void)drawTextInRect:(CGRect)rect label:(UILabel*)lbl {
    UIEdgeInsets insets = {20, 20, 20, 20};
    [lbl drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
