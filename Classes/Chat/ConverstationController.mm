//
//  ConverstationController.m
//  Maps
//
//  Created by Gergely Meszaros-Komaromy on 05/08/16.
//  Copyright © 2016 MapsWithMe. All rights reserved.
//

#import "ConverstationController.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessageTimeCell.h"

@interface ConverstationController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSMutableArray* msgArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtMsg;
@property (weak, nonatomic) IBOutlet UIView *viewAddCom;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (strong, nonatomic) NSDate* lastMessageDate;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation ConverstationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.txtMsg.delegate = self;
    self.msgArray = [NSMutableArray array];
    self.participants = [NSMutableDictionary dictionary];
    
    [self registerForKeyboardNotifications];
    
    self.tableView.transform = CGAffineTransformMakeScale (1,-1);
    
    UIGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard {
    [self.txtMsg resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  /*self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:NULL action:NULL];
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  if (self.conversationId == 0) {
    self.navigationItem.title = self.conv.name;
  }
  //if (!self.recipientThumbnail) {
    [API getConversations:[MapsAppDelegate theApp].securityToken completion:^(NSArray *conversations, NSString *errorMessage) {
      for (int i=0; i<conversations.count; i++) {
        Conversation* c = [[Conversation alloc] initWithDictionary:conversations[i]];
        if (c.convId == self.conversationId) {
          self.conv = c;
          self.navigationItem.title = self.conv.name;
          [API getFriendsList:[MapsAppDelegate theApp].securityToken completion:^(NSArray *friends, NSString *errorMessage) {
            for (NSUInteger i=0; i<friends.count; i++) {
              Friend* f = [friends objectAtIndex:i];
              if (f.frontendId == self.conv.userId) {
                NSString* profileImg = @" ";
                if (f.facebookId) {
                  profileImg = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",f.facebookId];
                }else{
                  profileImg = f.thumbnail;
                }
                self.recipientThumbnail = profileImg;
                [self.tableView reloadData];
                break;
              }
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
              [self.tableView reloadData];
            }];
          }];
          break;
        }
      }
    }];
  //}
  
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  [self retrieveMessages];*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.msgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id data = [self.msgArray objectAtIndex:indexPath.row];
    
    if ([data isKindOfClass:NSDate.class]) {
        MessageTimeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTimeCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MessageTimeCell" owner:nil options:nil][0];
        }
        cell.date = data;
        cell.transform = CGAffineTransformMakeScale (1,-1);
        cell.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.25];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil][0];
    }
    Message* m = (Message*)data;
    cell.msg = m;
    //cell.url = self.recipientThumbnail;
    cell.transform = CGAffineTransformMakeScale (1,-1);
    cell.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.25];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
  [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

- (void)registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        /*if ((int)[[UIScreen mainScreen] nativeBounds].size.height == 2436) {
            self.bottomViewConstraint.constant = kbSize.height - 96.0 - 90.0;
        } else {
            self.bottomViewConstraint.constant = kbSize.height - 60.0 - 90.0;
        }*/
        
        CGRect frame = [self.view convertRect:self.view.frame fromView:nil];
        
        self.bottomViewConstraint.constant = kbSize.height - UIScreen.mainScreen.bounds.size.height + frame.size.height - frame.origin.y;
        double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger keyboardAnimationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:keyboardAnimationCurve
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil
         ];
        if (self.msgArray.count>2) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary* info = [aNotification userInfo];
        self.bottomViewConstraint.constant = 0.0;
        double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger keyboardAnimationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:keyboardAnimationCurve
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil
         ];
    }];
}

/*-(void)retrieveMessages {
  [self.progress startAnimating];
  if (self.conversationId == 0) {
    self.conversationId = self.conv.convId;
  }
  [API getMessages:[MapsAppDelegate theApp].securityToken iduser:self.conversationId completion:^(NSMutableArray *msg, NSString *errorMessage) {
    NSString* lastDate = nil;
    NSDate* lastDateDate = nil;
    self.msgArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<[msg count]; i++) {
      NSDictionary * dict = [msg  objectAtIndex:i];
      Message* msgs = [[Message alloc] initWithDict:dict];
      NSString* date = [MessageTimeCell timeLeftSinceDate:msgs.created];
      if (!lastDate || [lastDate compare:date] != NSOrderedSame) {
        if (!lastDateDate || [msgs.created timeIntervalSinceDate:lastDateDate] > 300) {
          [self.msgArray addObject:date];
        }
        lastDate = date;
        lastDateDate = msgs.created;
      }
      [self.msgArray addObject:msgs];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [self.progress stopAnimating];
      [self.tableView reloadData];
      if (self.msgArray.count>3) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
      }
    }];
  }];
}*/

- (IBAction)sendMsg:(id)sender {
    
    [self addMessage:self.txtMsg.text sid:nil];
    [self.localDataTrack sendString:self.txtMsg.text];
    self.txtMsg.text = @"";
    [self.txtMsg resignFirstResponder];
    
    if (self.msgArray.count>2) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
    
  //[self.progress startAnimating];
  /*if (self.conversationId == 0) {
    self.conversationId = self.conv.convId;
  }
  NSString* param = [NSString stringWithFormat:@"message=%@", [API percentEscapeString:_txtMsg.text]];
  [API sendMessages:[MapsAppDelegate theApp].securityToken iduser: self.conversationId param:param completion:^(NSDictionary *res, NSString *) {
      NSLog(@"%@",res);
    if ([[res objectForKey:@"success"]integerValue]==1) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          self.txtMsg.text = @"";
              [self.txtMsg resignFirstResponder];
          [self retrieveMessages];
      }];
    }
  }];*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void) addMessage:(NSString*)message sid:(NSString*)sid {
    Message* m = [[Message alloc] init];
    m.message = message;
    m.created = [NSDate date];
    m.sid = sid;
    if (!self.lastMessageDate || [self.lastMessageDate timeIntervalSinceNow] < -60 ) {
        [self.msgArray insertObject:[NSDate date] atIndex:0];
        self.lastMessageDate = [NSDate date];
    }
    [self.msgArray insertObject:m atIndex:0];
    [self.tableView reloadData];
}

#pragma mark -

- (void)remoteDataTrack:(TVIRemoteDataTrack *)remoteDataTrack didReceiveData:(NSData *)message {
    
}

- (void)remoteDataTrack:(TVIRemoteDataTrack *)remoteDataTrack didReceiveString:(NSString *)message {
    TVIRemoteParticipant* participant = self.participants[remoteDataTrack.sid];
    if (participant) {
        [self addMessage:message sid:participant.identity];
    } else {
        [self addMessage:message sid:@"unknown"];
    }
}


@end
