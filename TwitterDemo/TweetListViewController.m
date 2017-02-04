//
//  TweetListViewController.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/30/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "TweetListViewController.h"
#import "TweetTableViewCell.h"
#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import <MBProgressHUD.h>

@interface TweetListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Tweet *> *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshTableViewControl;

@end

@implementation TweetListViewController
@synthesize viewType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TweetTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
    
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated: YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath: indexPath];
    Tweet *tweet = self.tweets[indexPath.row];

    cell.tag = indexPath.row;
    
    if (tweet.retweetCount > 0) {
        cell.retweetContainerHeightConstraint.constant = 24;
        UIImage *retweeIcon = [[UIImage imageNamed:@"retweet-icon@1x.png"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cell.retweetDesc.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.screenName];
        [cell.retweetImage setImage: retweeIcon];
    } else {
        cell.retweetContainerHeightConstraint.constant = 2;
    }
    [cell setNeedsUpdateConstraints];
    cell.contentLabel.text = tweet.text;
    cell.nameLabel.text = tweet.user.name;
    cell.handleLabel.text = tweet.user.screenName;

    [cell.profileImageView setImageWithURL: tweet.user.profileImageUrl];
    
    UIImage *btnImage = [[UIImage imageNamed:@"reply-icon@2x.png"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.replyButton setImage:btnImage forState:UIControlStateNormal];
    btnImage = [[UIImage imageNamed:@"retweet-icon@2x.png"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.retweetButton setImage:btnImage forState:UIControlStateNormal];
    btnImage = [[UIImage imageNamed:@"favor-icon@2x.png"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.favoriteButton setImage:btnImage forState:UIControlStateNormal];
    
    cell.selectedBackgroundView.backgroundColor=[UIColor blackColor];

    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    formatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSString *timestamp = [formatter stringFromDate:tweet.timestamp toDate:[NSDate date]];
    NSString *pattern = @"^(\\d+) (\\w).*";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    cell.timestampLabel.text = [regex stringByReplacingMatchesInString:timestamp options:0 range:NSMakeRange(0, [timestamp length]) withTemplate:@"$1$2"];
    
    [self onTapGesture:cell];
    return cell;
}


- (void)fetchTweet {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        //NSLog(@"%@", responseObject);
        NSArray *tweets = [Tweet tweetWithArray:responseObject];
        self.tweets = tweets;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSelectorOnMainThread:@selector(reloadTweetData) withObject:(nil) waitUntilDone:(NO)];
        sleep(1);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void) setupRefresh {
    UIRefreshControl *refreshTableViewControl = [[UIRefreshControl alloc] init];
    [refreshTableViewControl addTarget:self action:@selector(refreshTableViewControlAction) forControlEvents:UIControlEventValueChanged];
    self.refreshTableViewControl = refreshTableViewControl;
    [self.tableView addSubview:refreshTableViewControl];
}

- (void) refreshTableViewControlAction {
    [self refreshControlAction];
    [self.refreshTableViewControl endRefreshing];
}

- (void) refreshControlAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchTweet];
    });
}

- (void) reloadTweetData {
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchTweet];
    [self setupRefresh];
}


- (void) onTapGesture:(TweetTableViewCell *) cell {
   cell.profileImageView.userInteractionEnabled = YES;
   UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageWithGesture:)];
    
   [cell.profileImageView addGestureRecognizer:tapGesture];
    //[tapGesture release];
}

- (void)didTapImageWithGesture:(UITapGestureRecognizer *)tapGesture {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];

    vc.tweet = self.tweets[tapGesture.view.tag];
    vc.viewType = @"profile";
    [self.navigationController pushViewController:vc animated: YES];
    NSLog(@"Image Tapped");
}


@end
