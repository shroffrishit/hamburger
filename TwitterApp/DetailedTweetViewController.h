//
//  DetailedTweetViewController.h
//  TwitterApp
//
//  Created by Rishit Shroff on 11/1/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface DetailedTweetViewController : UIViewController<UITextFieldDelegate>

@property(strong, nonatomic) Tweet *tweet;

@end
