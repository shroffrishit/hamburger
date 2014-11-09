//
//  MainViewController.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/7/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic)UIView *contentView;
@property (strong, nonatomic)UIView *menuView;
@property (strong, nonatomic)UIViewController *contentViewController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[UIView alloc] init];
    self.menuView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.menuView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setMenuController:(UIViewController *)lc {
    self.menuView = lc.view;
}

- (void) setContentController:(UIViewController *)cv {
    CGRect frame = self.view.bounds;
    
    self.contentView = cv.view;
    self.contentView.frame = frame;
    [self.view addSubview:self.contentView];
}

@end
