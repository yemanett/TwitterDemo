//
//  LoggedOutViewController.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/2/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "LoggedOutViewController.h"
#import "TwitterClient.h"

@interface LoggedOutViewController ()

@end

@implementation LoggedOutViewController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance].requestSerializer
     removeAccessToken];
    [[TwitterClient sharedInstance] fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got request token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token ]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error){
        NSLog(@"Failed to get the token");
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
