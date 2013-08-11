//
//  DBBook.h
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DBBookStatusNone = -1,
    DBBookStatusWantRead = 0,
    DBBookStatusReading,
    DBBookStatusHasRead,
} DBBookStatus;

@interface DBBook : NSObject

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, copy) NSString *coverImageUrl;
@property (nonatomic, assign) DBBookStatus status;
@property (nonatomic, copy) NSString *statusString;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithSearchDict:(NSDictionary *)dict;

- (void)changeStatus:(DBBookStatus)status success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSString *)statusStringForStatus:(DBBookStatus)status;

@end
