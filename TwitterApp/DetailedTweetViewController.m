//
//  DetailedTweetViewController.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/1/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "DetailedTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "NewTweetUIViewController.h"
#import "ProfileViewController.h"

@interface DetailedTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UIImageView *replyPic;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedPic;
@property (weak, nonatomic) IBOutlet UIImageView *favoritedPic;
- (IBAction)onTweetPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *retweetCnt;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCnt;
@property (weak, nonatomic) IBOutlet UITextField *replyMsg;

@end

@implementation DetailedTweetViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.translucent = NO;
    
    

    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackPressed)];
    [backButton setTintColor:[UIColor whiteColor]];
    
    [self setTitle:@"Tweet"];
    [self.navigationItem setLeftBarButtonItem:backButton];
    // Set the Background Color
    long rgbValue = 0x55ACEE;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.profilePic setImageWithURL:[NSURL URLWithString:self.tweet.user.profilePicURL]];
    [self.userName setText:self.tweet.user.name];
    [self.screenName setText:[NSString stringWithFormat:@"@%@", self.tweet.user.screenName]];
    [self.status setText:self.tweet.text];
    [self.retweetCnt setText:[NSString stringWithFormat:@"%lu RETWEETS",self.tweet.retweeted]];
    [self.favoriteCnt setText:[NSString stringWithFormat:@"%lu FAVORITES",self.tweet.favorited]];
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
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.tweet.createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    [self.createdAt setText:dateString];
    
    [self.profilePic.layer setCornerRadius:4];
    [self.profilePic setClipsToBounds:true];

    
    [self.replyPic setUserInteractionEnabled:true];
    [self.favoritedPic setUserInteractionEnabled:true];
    [self.retweetedPic setUserInteractionEnabled:true];
    [self.profilePic setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *singleReplyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyTap)];
    UITapGestureRecognizer *singleRetweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetTap)];
    UITapGestureRecognizer *singleFavoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteTap)];
    UITapGestureRecognizer *singleProfileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfilePicPressed)];
    
    [self.replyPic addGestureRecognizer:singleReplyTap];
    [self.favoritedPic addGestureRecognizer:singleFavoriteTap];
    [self.retweetedPic addGestureRecognizer:singleRetweetTap];
    [self.profilePic addGestureRecognizer:singleProfileTap];

    self.replyMsg.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onProfilePicPressed {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = self.tweet.user;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self presentViewController:nvc animated:true completion:nil];
}

- (void)onBackPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTweetPressed:(id)sender {
    [self.tweet didReply:self.replyMsg.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)replyTap {
    NewTweetUIViewController *nvc = [[NewTweetUIViewController alloc] init];
    
    [nvc setTweet:self.tweet];
    [self presentViewController:nvc animated:true completion:nil];
}

- (void)retweetTap {
    [self.tweet didRetweet];
    
    if (self.tweet.userRetweeted) {
        [self.retweetedPic setImage:[UIImage imageNamed:@"retweet_on.png"]];
    }
    [self.retweetCnt setText:[NSString stringWithFormat:@"%lu RETWEETS",self.tweet.retweeted]];
}

- (void)favoriteTap {
    [self.tweet didFavoritedUser];
    
    if (self.tweet.userFavorited) {
        [self.favoritedPic setImage:[UIImage imageNamed:@"favorite_on.png"]];
    } else {
        [self.favoritedPic setImage:[UIImage imageNamed:@"favorite.png"]];
    }
    [self.favoriteCnt setText:[NSString stringWithFormat:@"%lu FAVORITES",self.tweet.favorited]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 140 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];
}
@end
