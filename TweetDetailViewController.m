//
//  TweetDetailViewController.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/1/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TweetDetailCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileCollectionViewCell.h"
#import "TwitterClient.h"
#import "User.h"

@interface TweetDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) User *user;

@end

@implementation TweetDetailViewController
@synthesize tweet;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"ArialMT" size:17.0], NSFontAttributeName,nil]];
    
    if([self.viewType isEqualToString: @"profile"]) {
        self.navigationController.navigationBar.topItem.title = @"Profile";
        UINib *nib = [UINib nibWithNibName:@"ProfileCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ProfileCollectionViewCell"];
    } else {
        self.navigationController.navigationBar.topItem.title = @"Tweet";
        UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];
        [replyButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = replyButton;
        UINib *nib = [UINib nibWithNibName:@"TweetDetailCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"TweetDetailCollectionViewCell"];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int offset = [self.viewType isEqualToString:@"profile"] ? 4 : 2;
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height/offset);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.viewType isEqualToString: @"profile"]) {
    
        ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCollectionViewCell" forIndexPath:indexPath];
        [self profileDetail:cell];
        return cell;
    } else {
        TweetDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetDetailCollectionViewCell" forIndexPath:indexPath];
        [self tweetDetail:cell];
        return cell;
    }
}

- (void)profileDetail:(ProfileCollectionViewCell *)cell {
    cell.nameLabel.text = self.user.name;
    cell.handleLabel.text = self.user.screenName;
    [cell.profileImageView setImageWithURL: self.user.profileImageUrl];
    cell.followersCountLabel.text = [NSString stringWithFormat:@"%d FOLLOWERS", self.user.followersCount];
    cell.followingCountLabel.text = [NSString stringWithFormat:@"%d FOLLOWING", self.user.following];
    cell.statusesCount.text = [NSString stringWithFormat:@"%d TWEETS", self.user.statusesCount];
}

- (void)tweetDetail:(TweetDetailCollectionViewCell *)cell {
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

    cell.nameLabel.text = tweet.user.name;
    cell.handleLabel.text = tweet.user.screenName;
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS", tweet.retweetCount];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d FAVORITES", tweet.favoriteCount];
    
    [cell.profileImageView setImageWithURL: tweet.user.profileImageUrl];
    cell.contentLabel.text = tweet.text;
    [cell.contentLabel sizeToFit];
    
    UIImage *btnImage = [[UIImage imageNamed:@"reply-icon@2x.png"]
                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [cell.replyButton setImage:btnImage forState:UIControlStateNormal];
    btnImage = [[UIImage imageNamed:@"retweet-icon@2x.png"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.retweetButton setImage:btnImage forState:UIControlStateNormal];
    btnImage = [[UIImage imageNamed:@"favor-icon@2x.png"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell.favoriteButton setImage:btnImage forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy HH:mm a"];
    cell.timestampLabel.text = [dateFormatter stringFromDate:tweet.timestamp];
    cell.selectedBackgroundView.backgroundColor=[UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.viewType isEqualToString: @"profile"]) {
        [self fetchUserInfo];
        [self.collectionView reloadData];
    }
}

-(void) fetchUserInfo {
    [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        //NSLog(@"%@", responseObject);
        self.user = [[User alloc]initWithDictionary:responseObject];
        
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}
@end
