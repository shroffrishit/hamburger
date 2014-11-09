//
//  TwitterClient.h
//  TwitterApp
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completionCallback;

- (BOOL)openURL:(NSURL *)url;

- (void)getTweets:(long long)maxId callback:(void (^)(NSArray *tweets, NSError *error))completionCallback;

- (void)getMentions:(long long)maxId callback:(void (^)(NSArray *tweets, NSError *error))completionCallback;


- (void)postTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback;

- (void)favoriteTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback;

- (void)destroyFavoriteTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback;

- (void)reTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback;

- (void)replyTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback;

@end
