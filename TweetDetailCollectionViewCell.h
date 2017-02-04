//
//  TweetDetailCollectionViewCell.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/1/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetDesc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeightConstraint;

@end
