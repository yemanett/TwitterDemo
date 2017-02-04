//
//  User.m
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/31/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
        self.profileImageUrl = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.tagline = dictionary[@"decription"];
        self.favouritesCount = [dictionary[@"favourites_count"] integerValue];
        self.following = [dictionary[@"following"] integerValue];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
        self.statusesCount = [dictionary[@"statuses_count"] integerValue];
    }
    return self;
}
@end
