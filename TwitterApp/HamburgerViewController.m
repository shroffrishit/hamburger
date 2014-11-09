//
//  HamburgerViewController.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/8/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "HamburgerViewController.h"
#import "MenuViewController.h"

@interface HamburgerViewController ()

@property (atomic, assign) MenuViewController *menuViewController;
@property (atomic, assign) UIViewController *contentViewController;
@property (atomic, assign) BOOL menuIsOpen;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id) initWithViews {
    self = [super init];
    
    if (self) {
        self.leftView = [[UIView alloc] init];
        [self.leftView setBackgroundColor:[UIColor clearColor]];
        CGRect leftFrame = self.view.bounds;
        leftFrame.size.width = 160;
        self.leftView.frame = leftFrame;
        
        self.contentView = [[UIView alloc] init];
        [self.contentView setBackgroundColor:[UIColor orangeColor]];
        self.contentView.frame = self.view.bounds;
        [self.contentView setUserInteractionEnabled:true];
        
        [self.view addSubview:self.leftView];
        [self.view addSubview:self.contentView];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(onCustomPan:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onCustomPan:(UIPanGestureRecognizer *)sender {
    
    UIGestureRecognizerState state = sender.state;
    
    bool shouldShow = [sender velocityInView:self.view].x > 0 ? true : false;
    
    
    if (state == UIGestureRecognizerStateBegan) {
        if (shouldShow) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect contentFrame = self.view.bounds;
                contentFrame.origin.x = 80;
                self.contentView.frame = contentFrame;
            }];
            self.menuIsOpen = true;
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect contentFrame = self.view.bounds;
                contentFrame.origin.x = self.view.bounds.origin.x;
                self.contentView.frame = contentFrame;
            }];
            self.menuIsOpen = false;
        }
    }
}

- (void) addContentViewController:(UIViewController *)cv {
    self.contentViewController = cv;
    cv.view.frame = self.contentView.bounds;
    [self.contentView addSubview:cv.view];
    [self addChildViewController:self.contentViewController];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect contentFrame = self.view.bounds;
        contentFrame.origin.x = self.view.bounds.origin.x;
        self.contentView.frame = contentFrame;
    }];
    self.menuIsOpen = false;
}

- (void) addMenuController:(UIViewController *)cv {
    self.menuViewController = (MenuViewController *)cv;
    cv.view.frame = self.leftView.bounds;
    [self.leftView addSubview:cv.view];
    [self addChildViewController:self.menuViewController];
}

- (UIViewController *) getMenuController {
    return self.menuViewController;
}

- (void) loggedInSuccessFully {
    [self.menuViewController showHomePage];
}


- (void) showMenu {
    if (!self.menuIsOpen) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect contentFrame = self.view.bounds;
            contentFrame.origin.x = 80;
            self.contentView.frame = contentFrame;
        }];
        self.menuIsOpen = true;
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect contentFrame = self.view.bounds;
            contentFrame.origin.x = self.view.bounds.origin.x;
            self.contentView.frame = contentFrame;
        }];
        self.menuIsOpen = false;
    }
}

static HamburgerViewController *_controller = nil;

+(HamburgerViewController *)controller {
    if (_controller == nil) {
        _controller = [[HamburgerViewController alloc] initWithViews];
    }
    return _controller;
}

@end
