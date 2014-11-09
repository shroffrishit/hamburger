//
//  MenuViewController.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/8/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuOptionTableViewCell.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"
#import "HamburgerViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "TwitterClient.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (strong, nonatomic) NSMutableDictionary *options;
@property (strong, nonatomic) NSArray *optionLabels;
@property (strong, nonatomic) HamburgerViewController *hvc;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the Background Color
    long rgbValue = 0x55ACEE;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    
    [self.menuTable registerNib:[UINib nibWithNibName:@"MenuOptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuOptionTableViewCell"];
    self.menuTable.rowHeight = UITableViewAutomaticDimension;
    
    self.hvc = [HamburgerViewController controller];
    
    self.optionLabels = @[@"Home",
                          @"Profile",
                          @"Mentions",
                          @"Logout"];
    
    self.options = [NSMutableDictionary dictionary];
    
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    tvc.isMentions = false;
    [self.options setObject:[[UINavigationController alloc] initWithRootViewController:tvc] forKey:@"Home"];
    [self.options setObject:[[UINavigationController alloc] initWithRootViewController:[[ProfileViewController alloc] init]] forKey:@"Profile"];
    
    TweetsViewController *mentionsController = [[TweetsViewController alloc] init];
    mentionsController.isMentions = true;
    
    [self.options setObject:[[UINavigationController alloc] initWithRootViewController:mentionsController] forKey:@"Mentions"];
    
    [self.options setObject:[[LoginViewController alloc] init] forKey:@"Logout"];
    
    User *user = [User currentUser];
    
    if (user == nil) {
        [self.hvc addContentViewController:
         (UIViewController *)[self.options objectForKey:@"Logout"]];
    } else {
        [self.hvc addContentViewController:
         (UIViewController *)[self.options objectForKey:@"Home"]];
    }

    self.menuTable.layer.borderWidth = 0.0f;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MenuOptionTableViewCell *cell = [self.menuTable dequeueReusableCellWithIdentifier:@"MenuOptionTableViewCell" forIndexPath:indexPath];
    [cell.menuText setText:self.optionLabels[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIViewController *vc = (UIViewController *)[self.options objectForKey:self.optionLabels[indexPath.row]];
    
    if ([self.optionLabels[indexPath.row] isEqualToString:@"Logout"]) {
        [User setCurrentUser:nil];
        [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    }
    [self.hvc addContentViewController:vc];
}

- (void) showHomePage {
    User *user = [User currentUser];
    
    if (user == nil) {
        [self.hvc addContentViewController:
         (UIViewController *)[self.options objectForKey:@"Logout"]];
    } else {
        [self.hvc addContentViewController:
         (UIViewController *)[self.options objectForKey:@"Home"]];
    }
}

@end
