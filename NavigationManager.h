//
//  NavigationManager.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 2/2/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationManager : NSObject

@property (nonatomic, assign) BOOL isLoggedIn;

+ (instancetype)shared;

- (UIViewController *)rootViewController;

- (void)logIn;
- (void)logOut;

@end
