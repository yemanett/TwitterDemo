//
//  TweetDetailViewController.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/1/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) NSString *viewType;

@end
