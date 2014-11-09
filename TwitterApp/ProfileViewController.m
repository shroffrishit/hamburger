//
//  ProfileViewController.m
//  TwitterApp
//
//  Created by Rishit Shroff on 11/7/14.
//  Copyright (c) 2014 Rishit Shroff. All rights reserved.
//

#import "ProfileViewController.h"
#import "InfoCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *infoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.user == nil) {
        self.user = [User currentUser];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackPressed)];
    
    [backButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    long rgbValue = 0x55ACEE;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.headerView setBackgroundColor:[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]];

    UIImageView *bg = [[UIImageView alloc] init];
    bg.frame = self.headerView.bounds;
    [bg setContentMode:UIViewContentModeScaleToFill];
    [self.headerView addSubview:bg];
    [bg setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundURL]];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profilePicURL]];
    
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImage.layer.borderWidth = 3;
    
    [self.headerView addSubview:self.profileImage];
    [self.profileImage.layer setCornerRadius:4];
    [self.profileImage setClipsToBounds:true];
    
    [self.infoCollectionView registerNib:[UINib nibWithNibName:@"InfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"InfoCollectionViewCell"];
    
    self.infoCollectionView.dataSource = self;
    self.infoCollectionView.delegate = self;

    
    [self.userName setText:self.user.name];
    [self.screenName setText:[NSString stringWithFormat:@"@%@", self.user.screenName]];
    
    
}

- (NSString *)convertCountToString:(long)count {
    if (count > 1000000) {
        return [NSString stringWithFormat:@"%.1fM", (count * 1.0f)/1000000];
    } else if (count > 1000){
        return [NSString stringWithFormat:@"%.1fK", (count * 1.0f)/1000];
    } else {
        return [NSString stringWithFormat:@"%.1ld", count];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(105, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackPressed {
    [self dismissViewControllerAnimated:true completion:false];
};

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InfoCollectionViewCell *cell = [self.infoCollectionView dequeueReusableCellWithReuseIdentifier:@"InfoCollectionViewCell" forIndexPath:indexPath];
    UILabel *info = [[UILabel alloc] init];
    
    NSString *value, *text;
    if (indexPath.row == 0) {
        value = [self convertCountToString:self.user.statusesCount];
        text = [NSString stringWithFormat:@"%@\n TWEETS", value];
    } else if (indexPath.row == 1) {
        value = [self convertCountToString:self.user.followingCount];
        text = [NSString stringWithFormat:@"%@\n FOLLOWING", value];
    } else if (indexPath.row == 2) {
        value = [self convertCountToString:self.user.followerCount];
        text = [NSString stringWithFormat:@"%@\n FOLLOWERS", value];
    }
    
    const NSRange range = NSMakeRange(0, value.length);
    const CGFloat fontSize = 12;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIColor *foregroundColor = [UIColor grayColor];
    
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           foregroundColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              boldFont, NSFontAttributeName, nil];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    // Set it in our UILabel and we are done!
    [info setAttributedText:attributedText];
    
    [info setTextAlignment:NSTextAlignmentCenter];
    [info setNumberOfLines:2];
    
    info.frame = cell.bounds;
    
    [cell addSubview:info];
    return cell;
}

@end
