//
//  GroupsViewController.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

@interface GroupsViewController : BaseViewController <UITableViewDelegate,
													UITableViewDataSource,
													NSFetchedResultsControllerDelegate,
													UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *groupsTableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
