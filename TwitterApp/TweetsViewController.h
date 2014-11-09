//
//  TweetsViewController.h
//  TwitterApp
//
//  Created by Rishit Shroff on 10/30/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCellTableViewCell.h"

@interface TweetsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TweetCellTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isMentions;

@end
