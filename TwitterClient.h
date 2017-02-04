//
//  TwitterClient.h
//  TwitterDemo
//
//  Created by Yemane Tekleab on 1/31/17.
//  Copyright © 2017 Yemane Tekleab. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)sharedInstance;

@end
