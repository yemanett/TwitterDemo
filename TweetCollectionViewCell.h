//
//  TweetCollectionViewCell.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/3/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end
