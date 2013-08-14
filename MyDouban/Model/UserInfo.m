//
//  UserInfo.m
//  MyDouban
//
//  Created by Leon on 13-8-14.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "UserInfo.h"
#import "NSDate+Convenience.h"

@implementation UserInfo

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.nickName = dict[@"name"];
        self.userName = dict[@"uid"];
        self.joinedIn = [NSDate dateFromString:dict[@"created"] format:@"yyyy-MM-dd HH:mm:ss"];
        self.avatarUrl = dict[@"avatar"];
        self.desciption = dict[@"desc"];
    }
    return self;
}

@end
