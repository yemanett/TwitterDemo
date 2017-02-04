//
//  Tweet.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/31/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)tweetWithArray:(NSArray *)array;

@end
