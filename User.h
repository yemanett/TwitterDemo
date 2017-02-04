//
//  User.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/31/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, assign) NSInteger favouritesCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger following;
@property (nonatomic, assign) NSInteger statusesCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
