//
//  TweetTableViewCell.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/30/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "TweetTableViewCell.h"

@implementation TweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor whiteColor]]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];

}

@end
