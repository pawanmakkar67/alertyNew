//
//  TimerSelectWlanViewController.m
//  Alerty
//
//  Created by Viking on 2018. 02. 08..
//

#import "TimerSelectWlanViewController.h"
#import "AlertyDBMgr.h"
#import "WifiApMgr.h"
#import "AlertySettingsMgr.h"

@interface TimerSelectWlanViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* wifiaps;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimerSelectWlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // reload wifiaps
    self.wifiaps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wifiaps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WifiApCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WifiApCell"];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    WifiAP *w = self.wifiaps[indexPath.row];
    cell.textLabel.text = w.name;
    cell.accessoryView.hidden = ([w.type intValue] != kWifiAPTypeUser);
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0];
    cell.detailTextLabel.text = w.info;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate wlanSelected:self.wifiaps[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
