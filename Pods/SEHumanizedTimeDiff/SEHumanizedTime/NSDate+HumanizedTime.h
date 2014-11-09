//
//  NSDate+HumanizedTime.h
//  HumanizedTimeDemo
//
//  Created by Sarp Erdag on 2/29/12.
//  Copyright (c) 2012 Sarp Erdag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HumanizedTime)

typedef NS_ENUM(NSInteger, NSDateHumanizedType)
{
    NSDateHumanizedSuffixNone = 0,
    NSDateHumanizedSuffixLeft,
    NSDateHumanizedSuffixAgo
};

- (NSString *) stringWithHumanizedTimeDifference ;

@end
