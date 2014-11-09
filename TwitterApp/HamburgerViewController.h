//
//  HamburgerViewController.h
//  TwitterApp
//
//  Created by Rishit Shroff on 11/8/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerViewController : UIViewController

- (void) addContentViewController:(UIViewController *)contentViewController;
- (void) addMenuController:(UIViewController *)cv;

- (void) loggedInSuccessFully;
- (void) showMenu;

+(HamburgerViewController *)controller;

@end
