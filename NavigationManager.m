//
//  NavigationManager.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/2/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "NavigationManager.h"
#import "LoggedOutViewController.h"
#import "TwitterClient.h"
#import "TweetListViewController.h"
#import "NewTweetViewController.h"
#import "TweetDetailViewController.h"

@interface NavigationManager ()

// root dont alter
@property (nonatomic, strong) UINavigationController *navigationController;

// Tweet list tab nav controller
@property (nonatomic, weak) UINavigationController *tweetListNavigationController;
@property (nonatomic, weak) UINavigationController *tweetDetailNavigationController;
@property (weak, nonatomic) NewTweetViewController *tweetVC;

@end

@implementation NavigationManager

+(instancetype)shared {
    static NavigationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NavigationManager alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.isLoggedIn = [TwitterClient sharedInstance].isAuthorized ? YES : NO;
        UIViewController *root = self.isLoggedIn ? [self loggedInVC] : [self loggedOutVC];
        
        self.navigationController = [[UINavigationController alloc] init];
        self.navigationController.viewControllers = @[root];
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}


- (UIViewController *)rootViewController {
    return self.navigationController;
}


- (UIViewController *)loggedInVC {
    // Create root VC for the tab's navigation controller
    TweetListViewController *tweetListVC = [[TweetListViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    
     // create navigation controller
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:tweetListVC];
    [navController1.navigationBar setBarTintColor:[UIColor blueColor]];
    [navController1.navigationBar setTintColor:[UIColor whiteColor]];
    self.tweetListNavigationController = navController1;
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut:)];
    [signOutButton setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(createTweetView:)];
    [newButton setTintColor:[UIColor whiteColor]];
    
    tweetListVC.navigationController.navigationBar.topItem.title = @"Home";
    [tweetListVC.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"ArialMT" size:17.0], NSFontAttributeName,nil]];
    tweetListVC.navigationItem.leftBarButtonItem = signOutButton;
    tweetListVC.navigationItem.rightBarButtonItem = newButton;
  
    
    TweetDetailViewController *tweetDetailVC = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:tweetDetailVC];
    tweetDetailVC.viewType = @"profile";
    self.tweetDetailNavigationController = navController2;
    
    navController1.title = @"HOME";
    navController2.title = @"PROFILE";
    
    // create tab bar view controller
    UITabBarController *tabController = [[UITabBarController alloc] init];
    // Add navigation controller to tab bar controller
    tabController.viewControllers = @[navController1, navController2];
    
    return tabController;
}

-(void)signOut:(id)sender{
    [[NavigationManager shared] logOut];
}


-(void)createTweetView:(id)sender{
    NewTweetViewController *vc = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancle:)];
    [cancelButton setTintColor:[UIColor whiteColor]];
    
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
    self.tweetVC = vc;
    [tweetButton setTintColor:[UIColor whiteColor]];
  

    vc.navigationItem.leftBarButtonItem = cancelButton;
    vc.navigationItem.rightBarButtonItem = tweetButton;
       
    [self.tweetListNavigationController pushViewController:vc animated: YES];
}

- (void) onClick:(id)sender {
    [self.tweetVC onSubmit];
}

-(void)onCancle:(id)sender {
    [self.tweetVC onCancel];
}

- (UIViewController *)loggedOutVC {
    LoggedOutViewController *vc = [[LoggedOutViewController alloc] initWithNibName:@"LoggedOutViewController" bundle:nil];
    
    return vc;
}


- (void)logIn {
    self.isLoggedIn = YES;
    
    NSArray *vcs = @[[self loggedInVC]];
    [self.navigationController setViewControllers:vcs];
}


- (void)logOut {
    self.isLoggedIn = NO;
    self.navigationController.viewControllers = @[[self loggedOutVC]];
}

@end
