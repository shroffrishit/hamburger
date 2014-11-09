//
//  UserMentions.m
//  TwitterApp
//
//  Created by Rishit Shroff on 10/30/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "UserMentions.h"

@implementation UserMentions

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.userId = [dictionary[@"id"] longLongValue];
        self.startIndex = [dictionary[@"indices"][0] integerValue];
        self.length = [dictionary[@"indices"][1] integerValue] - self.startIndex;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
    }
    
    return self;
}

+ (NSArray *)userMentionsWithArray:(NSArray *)array {
    NSMutableArray *mentions = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [mentions addObject:[[UserMentions alloc] initWithDictionary:dict]];
    }
    return mentions;
}
@end
