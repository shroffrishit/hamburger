//
//  Tweet.m
//  TwitterApp
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "Tweet.h"
#import "UserMentions.h"
#import "TwitterClient.h"

@implementation Tweet

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {

        self.text = dictionary[@"text"];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        
        self.tweetId = [dictionary[@"id"] longLongValue];
        self.retweeted = [dictionary[@"retweet_count"] longValue];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.favorited = [dictionary[@"favorite_count"] longValue];
        self.userMentions = [UserMentions userMentionsWithArray:dictionary[@"user_mentions"]];
        
        self.userRetweeted = [dictionary[@"retweeted"] boolValue];
        self.userFavorited = [dictionary[@"favorited"] boolValue];
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
    }
    return tweets;
}

- (void) didReply:(NSString *)reply {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:reply forKey:@"status"];
    [dict setObject:self forKey:@"tweet"];
    [[TwitterClient sharedInstance] replyTweet:dict callback:nil];
}

- (void) didRetweet {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithLongLong:self.tweetId] forKey:@"id"];
    
    [[TwitterClient sharedInstance] reTweet:dict callback:nil];
    
    if (!self.userRetweeted) {
        self.userRetweeted = true;
        self.retweeted +=1;
    }

}

- (void) didFavoritedUser {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithLongLong:self.tweetId] forKey:@"id"];
    
    if (!self.userFavorited) {
        [[TwitterClient sharedInstance] favoriteTweet:dict callback:nil];
        self.favorited += 1;
    } else {
        [[TwitterClient sharedInstance] destroyFavoriteTweet:dict callback:nil];
        self.favorited -= 1;
    }
    self.userFavorited = !self.userFavorited;
}

@end
