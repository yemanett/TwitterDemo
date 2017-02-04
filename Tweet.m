//
//  Tweet.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/31/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEEE MMM d HH:mm:ss Z y"];
        self.timestamp = [df dateFromString: dictionary[@"created_at"]];
    }
    return self;
}

+ (NSArray *)tweetWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
