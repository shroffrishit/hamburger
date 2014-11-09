//
//  User.m
//  TwitterApp
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "User.h"

NSString *const UserDidLogInNotification = @"UserDidLogInNotification";
NSString *const UserDidLogOutNotification = @"UserDidLogOutNotification";

@interface User()

@property(nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

-(id)initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.userId = [dictionary[@"id"] longLongValue];
        self.followerCount = [dictionary[@"followers_count"] longValue];
        self.followingCount = [dictionary[@"friends_count"] longValue];
        self.statusesCount = [dictionary[@"statuses_count"] longValue];
        self.profilePicURL = dictionary[@"profile_image_url"];
        self.profileBackgroundURL = dictionary[@"profile_background_image_url"];
    }
    return self;
}

# pragma static methods

static User *_currentUser = nil;
NSString *const kCurrentUserKey = @"kCurrentUserKey";

+(User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _currentUser = [[User alloc] initWithDictionary:dict];
        }
    }
    return _currentUser ;
}

+(void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogInNotification object:currentUser];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogOutNotification object:nil];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
