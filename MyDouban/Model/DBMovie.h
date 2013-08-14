//
//  DBMovie.h
//  MyDouban
//
//  Created by Leon on 13-8-9.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DBMovieStatusNone = -1,
    DBMovieStatusWantWatch = 0,
    DBMovieStatusHasWatched,
} DBMovieStatus;

@interface DBMovie : NSObject

@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *coverImageUrl;
@property (nonatomic, assign) DBMovieStatus status;
@property (nonatomic, copy) NSString *statusString;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithSearchDict:(NSDictionary *)dict;

- (void)changeStatus:(DBMovieStatus)status success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSString *)statusStringForStatus:(DBMovieStatus)status;

@end
