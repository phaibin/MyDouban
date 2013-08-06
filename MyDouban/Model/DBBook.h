//
//  DBBook.h
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DBBookStatusWantRead = 0,
    DBBookStatusReading,
    DBBookStatusHasRead
} DBBookStatus;

@interface DBBook : NSObject

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, copy) NSString *coverImageUrl;
@property (nonatomic, assign) DBBookStatus status;

- (id)initWithDic:(NSDictionary *)dict;

@end
