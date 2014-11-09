//
//  TweetCellTableViewCell.h
//  TwitterApp
//
//  Created by Rishit Shroff on 11/1/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCellTableViewCell;

@protocol TweetCellTableViewCellDelegate <NSObject>

- (void) TweetCellTableViewCell:(TweetCellTableViewCell *)cell
                 didSelectReply:(BOOL)selected;
- (void) TweetCellTableViewCell:(TweetCellTableViewCell *)cell
                 didreTweet:(BOOL)selected;
- (void) TweetCellTableViewCell:(TweetCellTableViewCell *)cell
                 didFavorited:(BOOL)selected;
- (void) TweetCellTableViewCell:(TweetCellTableViewCell *)cell
                  didSelectUser:(BOOL)selected;
@end

@interface TweetCellTableViewCell : UITableViewCell

@property (nonatomic, weak)id<TweetCellTableViewCellDelegate> delegate;

- (void)setTweet:(Tweet *)tweet;

@end
