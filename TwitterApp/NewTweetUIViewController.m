//
//  NewTweetUIViewController.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/1/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "NewTweetUIViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface NewTweetUIViewController ()
- (IBAction)onCancelPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *charLeft;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UITextView *statusView;
- (IBAction)onTweetPressed:(id)sender;

@end

@implementation NewTweetUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    User *currentUser = [User currentUser];
    
    [self.profilePic setImageWithURL:[NSURL URLWithString:currentUser.profilePicURL]];
    [self.username setText:currentUser.name];
    [self.screenName setText:currentUser.screenName];
    
    // Its a reply
    if (self.tweet != nil) {
        [self.statusView setText:[NSString stringWithFormat:@"@%@ ",self.tweet.user.screenName]];
    }
    
    int charLeft = 140 - self.statusView.text.length;
    [self.charLeft setText:[NSString stringWithFormat:@"%d", charLeft]];

    self.statusView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
}

- (IBAction)onCancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    int charLeft = 140 - textView.text.length;
    [self.charLeft setText:[NSString stringWithFormat:@"%d", charLeft]];

    if (charLeft <=0 && range.length == 0) {
        return NO; // return NO to not change text
    }
    else {
        return YES;
    }
}

- (IBAction)onTweetPressed:(id)sender {
    
    if (self.tweet != nil) {
        [self.tweet didReply:self.statusView.text];
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.statusView.text forKey:@"status"];
        [[TwitterClient sharedInstance] postTweet:dict callback:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
