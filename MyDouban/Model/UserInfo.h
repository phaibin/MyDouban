//
//  UserInfo.h
//  MyDouban
//
//  Created by Leon on 13-8-14.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSDate *joinedIn;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *desciption;

- (id)initWithDict:(NSDictionary *)dict;

@end
