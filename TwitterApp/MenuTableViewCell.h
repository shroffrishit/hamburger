//
//  MenuTableViewCell.h
//  TwitterApp
//
//  Created by Rishit Shroff on 11/8/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuTableViewCell;

@protocol MenuTableViewCellDelegate <NSObject>

- (void) MenuTableViewCell:(MenuTableViewCell *)cell
                didSelectOption:(NSString *)text;

@end

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (weak, nonatomic) id<MenuTableViewCellDelegate> delegate;

@end
