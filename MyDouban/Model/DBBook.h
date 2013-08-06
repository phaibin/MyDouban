//
//  DBBook.h
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBBook : NSObject

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, copy) NSString *coverImageUrl;

- (id)initWithDic:(NSDictionary *)dict;

@end
