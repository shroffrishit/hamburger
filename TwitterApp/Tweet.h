//
//  Tweet.h
//  TwitterApp
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, assign) long long tweetId;
@property(nonatomic, assign) long retweeted;
@property(nonatomic, strong) User *user;
@property(nonatomic, assign) long favorited;
@property(nonatomic, strong) NSArray *userMentions;
@property(nonatomic, assign) BOOL userRetweeted;
@property(nonatomic, assign) BOOL userFavorited;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (void) didReply:(NSString *)reply;
- (void) didRetweet;
- (void) didFavoritedUser;

+ (NSArray *)tweetsWithArray:(NSArray *)array;



@end
