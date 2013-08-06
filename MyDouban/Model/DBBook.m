//
//  DBBook.m
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "DBBook.h"

@implementation DBBook

- (id)initWithDic:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.bookId = dict[@"book_id"];
        self.name = dict[@"book"][@"title"];
        self.authors = dict[@"book"][@"author"];
        self.coverImageUrl = dict[@"book"][@"images"][@"medium"];
        NSString *status = dict[@"book"][@"author"];
        if ([status isEqualToString:@"wish"])
            self.status = DBBookStatusWantRead;
        else if ([status isEqualToString:@"reading"])
            self.status = DBBookStatusReading;
        else if ([status isEqualToString:@"read"])
            self.status = DBBookStatusHasRead;
    }
    return self;
}

@end
