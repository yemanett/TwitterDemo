//
//  NewTweetViewController.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/3/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "NewTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCollectionViewCell.h"
#import "TweetListViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface NewTweetViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) User  *user;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) UITextView *textLabel;
@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"TweetCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"TweetCollectionViewCell"];
    [self fetchUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCollectionViewCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.user.name;
    cell.handleLabel.text = self.user.screenName;
    [cell.profileImageView setImageWithURL: self.user.profileImageUrl];
    self.textLabel = cell.tweetText;
    
    return cell;
}

- (void)onSubmit {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.textLabel.text, @"status", nil];
    [[TwitterClient sharedInstance] POST:@"1.1/statuses/update.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id  responseObject){
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, id  responseObject) {
        NSLog(@"%@", responseObject);
    }];
}

- (void)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
