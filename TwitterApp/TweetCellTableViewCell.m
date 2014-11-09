//
//  TweetCellTableViewCell.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/1/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "TweetCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NewTweetUIViewController.h"

@interface TweetCellTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numRetweeted;
@property (weak, nonatomic) IBOutlet UILabel *numFavorited;
@property (weak, nonatomic) IBOutlet UIImageView *replyPic;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedPic;
@property (weak, nonatomic) IBOutlet UIImageView *favoritedPic;
@property (weak, nonatomic) IBOutlet UILabel *text;

@property (weak, nonatomic)Tweet *tweet;

@end

@implementation TweetCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.profilePic.layer setCornerRadius:4];
    [self.profilePic setClipsToBounds:true];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self.profilePic setImageWithURL:[NSURL URLWithString:tweet.user.profilePicURL]];
    [self.name setText:tweet.user.name];
    [self.screenName setText:[NSString stringWithFormat:@"@%@",tweet.user.screenName]];
    [self.text setText:tweet.text];
    [self.numRetweeted setText:[NSString stringWithFormat:@"%lu",tweet.retweeted]];
    [self.numFavorited setText:[NSString stringWithFormat:@"%lu",tweet.favorited]];
    [self.replyPic setImage:[UIImage imageNamed:@"reply.png"]];
    
    if (self.tweet.userFavorited) {
        [self.favoritedPic setImage:[UIImage imageNamed:@"favorite_on.png"]];
    } else {
        [self.favoritedPic setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    
    if (self.tweet.userRetweeted) {
        [self.retweetedPic setImage:[UIImage imageNamed:@"retweet_on.png"]];
    } else {
        [self.retweetedPic setImage:[UIImage imageNamed:@"retweet.png"]];
    }
    
    [self.replyPic setUserInteractionEnabled:true];
    UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyTapped)];
    [self.replyPic addGestureRecognizer:replyTap];
    
    [self.favoritedPic setUserInteractionEnabled:true];
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteTapped)];
    [self.favoritedPic addGestureRecognizer:favoriteTap];
    
    [self.retweetedPic setUserInteractionEnabled:true];
    UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetTapped)];
    [self.retweetedPic addGestureRecognizer:retweetTap];
    
    [self.profilePic setUserInteractionEnabled:true];
    UITapGestureRecognizer *profilePicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileTapped:)];
    [self.profilePic addGestureRecognizer:profilePicTap];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    [self.time setText:[self prettyDate:self.tweet.createdAt]];
}

-(void)replyTapped {
    [self.delegate TweetCellTableViewCell:self didSelectReply:true];
}

- (IBAction)userProfileTapped:(UITapGestureRecognizer *)sender {
    [self.delegate TweetCellTableViewCell:self didSelectUser:true];
}

-(void)favoriteTapped {
    [self.delegate TweetCellTableViewCell:self didFavorited:true];
    if (self.tweet.userFavorited) {
        [self.favoritedPic setImage:[UIImage imageNamed:@"favorite_on.png"]];
    } else {
        [self.favoritedPic setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    [self.numFavorited setText:[NSString stringWithFormat:@"%lu",self.tweet.favorited]];
}

-(void)retweetTapped {
    [self.delegate TweetCellTableViewCell:self didreTweet:true];
    if (self.tweet.userRetweeted) {
        [self.retweetedPic setImage:[UIImage imageNamed:@"retweet_on.png"]];
    }
    [self.numRetweeted setText:[NSString stringWithFormat:@"%lu",self.tweet.retweeted]];
}

- (NSString *)prettyDate:(NSDate *)date
{
    NSString * prettyTimestamp;
    
    float delta = [date timeIntervalSinceNow] * -1;
    
    if (delta < 60) {
        prettyTimestamp = @"now";
    } else if (delta < 120) {
        prettyTimestamp = @"1m";
    } else if (delta < 3600) {
        prettyTimestamp = [NSString stringWithFormat:@"%dm", (int) floor(delta/60.0) ];
    } else if (delta < 7200) {
        prettyTimestamp = @"1h";
    } else if (delta < 86400) {
        prettyTimestamp = [NSString stringWithFormat:@"%dh", (int) floor(delta/3600.0) ];
    } else if (delta < ( 86400 * 2 ) ) {
        prettyTimestamp = @"1d";
    } else if (delta < ( 86400 * 7 ) ) {
        prettyTimestamp = [NSString stringWithFormat:@"%dd", (int) floor(delta/86400.0) ];
    } else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        prettyTimestamp = [NSString stringWithFormat:@"on %@", [formatter stringFromDate:date]];
    }
    
    return prettyTimestamp;
}

@end
