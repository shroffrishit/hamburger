//
//  UserMentions.h
//  TwitterApp
//
//  Created by Rishit Shroff on 10/30/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMentions : NSObject

@property(nonatomic, assign) long long userId;
@property(nonatomic, assign) long startIndex;
@property(nonatomic, assign) long length;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *screenName;

-(id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)userMentionsWithArray:(NSArray *)array;

@end
