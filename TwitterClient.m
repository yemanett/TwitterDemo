//
//  TwitterClient.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/31/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "TwitterClient.h"


NSString *const keyTwitterConsumerKey = @"x1xiRwOopLo0pZZIxHaP0VtCW";
NSString *const keyTwitterConsumerSecret = @"KqXTZVL7aP3uJQ4U1y9QQ70CwwQ0lwH8Eyd4v5KLxEUd7SxzhP";
NSString *const keyTwitterBaseUrl = @"https://api.twitter.com";

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:keyTwitterBaseUrl] consumerKey:keyTwitterConsumerKey consumerSecret:keyTwitterConsumerSecret];
        }
    });
    return instance;
}
@end
