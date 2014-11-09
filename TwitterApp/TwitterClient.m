//
//  TwitterClient.m
//  TwitterApp
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"849YZNLAl8GhvVs4BX9WiYcDI";
NSString * const kTwitterConsumerSecret = @"3TfhGA1NPey4n5iNlDrUJE4E6Q7OIVUQ5QMv1FKt8mGAkmSGa8";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        };
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completionCallback {
    
    self.loginCompletion = completionCallback;
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get Access token");
        self.loginCompletion(nil, error);
    }];
}

- (BOOL)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {

        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        self.loginCompletion(nil, error);
    }];
    return YES;
}

- (void)postTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback {
    [self POST:@"1.1/statuses/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback(true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in postTweet %@", error);

        if (completionCallback != nil) {
            completionCallback(false, error);
        }
    }];
}

- (void)getTweets:(long long)maxID callback:(void (^)(NSArray *tweets, NSError *error))completionCallback {
    NSMutableDictionary *dict = nil;
    if (maxID != -1) {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithLongLong:maxID] forKey:@"max_id"];
    }
    
    [self GET:@"1.1/statuses/home_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback([Tweet tweetsWithArray:(NSArray *)responseObject], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in getTweets %@", error);
        if (completionCallback != nil) {
            completionCallback(nil, false);
        }
    }];
}

- (void)getMentions:(long long)maxId callback:(void (^)(NSArray *tweets, NSError *error))completionCallback {
    NSMutableDictionary *dict = nil;
    
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback([Tweet tweetsWithArray:(NSArray *)responseObject], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in getTweets %@", error);
        if (completionCallback != nil) {
            completionCallback(nil, false);
        }
    }];
}

- (void)favoriteTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback {
    NSLog(@"Favorite called");
    [self POST:@"1.1/favorites/create.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback(true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in favoriteTweet %@", error);

        if (completionCallback != nil) {
            completionCallback(false, error);
        }
    }];
}

- (void)destroyFavoriteTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback {
    NSLog(@"Destroy Favorite Called");
    [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback(true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in favoriteTweet %@", error);
        
        if (completionCallback != nil) {
            completionCallback(false, error);
        }
    }];
}

- (void)reTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback {
    
    NSString *retweetString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", parameters[@"id"]];
    
    [self POST:retweetString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback(true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in retweet %@", error);

        if (completionCallback != nil) {
            completionCallback(false, error);
        }
    }];
}

- (void)replyTweet:(NSDictionary *)parameters callback:(void (^)(bool success, NSError *error))completionCallback {
    
    NSMutableDictionary *dict = [parameters mutableCopy];
    Tweet *sourceTweet = parameters[@"tweet"];
    [dict setObject:[NSNumber numberWithLongLong:sourceTweet.tweetId] forKey:@"in_reply_to_status_id"];
    
    [self POST:@"1.1/statuses/update.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionCallback != nil) {
            completionCallback(true, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error in replyTweet %@", error);

        if (completionCallback != nil) {
            completionCallback(false, error);
        }
    }];
}
@end
