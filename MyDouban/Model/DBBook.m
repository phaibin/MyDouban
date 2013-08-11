//
//  DBBook.m
//  MyDouban
//
//  Created by Leon on 13-8-1.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import "DBBook.h"

@implementation DBBook

+ (NSString *)statusStringForStatus:(DBBookStatus)status
{
    switch (status) {
        case DBBookStatusNone:
            return @"none";
            break;
        case DBBookStatusWantRead:
            return @"wish";
            break;
        case DBBookStatusReading:
            return @"reading";
            break;
        case DBBookStatusHasRead:
            return @"read";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)statusString
{
    return [[self class] statusStringForStatus:self.status];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.bookId = dict[@"book_id"];
        self.name = dict[@"book"][@"title"];
        self.authors = dict[@"book"][@"author"];
        self.coverImageUrl = dict[@"book"][@"images"][@"medium"];
        NSString *status = dict[@"status"];
        if ([status isEqualToString:@"wish"])
            self.status = DBBookStatusWantRead;
        else if ([status isEqualToString:@"reading"])
            self.status = DBBookStatusReading;
        else if ([status isEqualToString:@"read"])
            self.status = DBBookStatusHasRead;
    }
    return self;
}

- (id)initWithSearchDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.bookId = dict[@"id"];
        self.name = dict[@"title"];
        self.authors = dict[@"author"];
        self.coverImageUrl = dict[@"images"][@"medium"];
        self.status = DBBookStatusNone;
    }
    return self;
}

- (void)changeStatus:(DBBookStatus)status success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    if (status == DBBookStatusNone) {
        NSString *url = [NSString stringWithFormat:URL_BOOK_COLLECTION, self.bookId];
        [SVProgressHUD show];
        [[AFAppDotNetAPIClient sharedClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", THE_APPDELEGATE.accessToken]];
        [[AFAppDotNetAPIClient sharedClient] deletePath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if (success) {
                success();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            if (failure) {
                failure(operation, error);
            }
        }];
    } else {
        NSString *url = [NSString stringWithFormat:URL_BOOK_COLLECTION, self.bookId];
        NSDictionary *parameters = @{@"status":[[self class] statusStringForStatus:status]};
        [SVProgressHUD show];
        if (self.status == DBBookStatusNone) {
            [[AFAppDotNetAPIClient sharedClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", THE_APPDELEGATE.accessToken]];
            [[AFAppDotNetAPIClient sharedClient] postPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                self.status = status;
                if (success) {
                    success();
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                if (failure) {
                    failure(operation, error);
                }
            }];
        } else {
            [[AFAppDotNetAPIClient sharedClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", THE_APPDELEGATE.accessToken]];
            [[AFAppDotNetAPIClient sharedClient] putPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                self.status = status;
                if (success) {
                    success();
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                if (failure) {
                    failure(operation, error);
                }
            }];
        }
    }
}

@end
