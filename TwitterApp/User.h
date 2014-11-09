//
//  User.h
//  TwitterApp
//
//  Created by Rishit Shroff on 10/29/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLogInNotification;
extern NSString *const UserDidLogOutNotification;

@interface User : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, assign) long long userId;
@property(nonatomic, assign) long followerCount;
@property(nonatomic, assign) long followingCount;
@property(nonatomic, assign) long statusesCount;
@property(nonatomic, strong) NSString *profilePicURL;
@property(nonatomic, strong) NSString *profileBackgroundURL;

-(id)initWithDictionary:(NSDictionary *)dictionary;

+(User *)currentUser;

+(void)setCurrentUser:(User *)currentUser;

@end
