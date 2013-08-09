//
//  Constants.h
//  MyDouban
//
//  Created by Leon on 13-7-31.
//  Copyright (c) 2013年 Leon. All rights reserved.
//


#define APP_KEY         @"0887d5416ed4655b19977fc44c7d3011"
#define APP_SECRET      @"c76f3580056ded04"
#define URL_AUTHORIZE   @"https://www.douban.com/service/auth2/auth"
#define URL_TOKEN       @"https://www.douban.com/service/auth2/token"
#define URL_REDIRECT    @"http://www.phaibin.tk"

#define USER_DEFAULTS_ACCESSTOKEN   @"USER_DEFAULTS_ACCESSTOKEN"
#define USER_DEFAULTS_REFRESHTOKEN  @"USER_DEFAULTS_REFRESHTOKEN"
#define USER_DEFAULTS_USERID        @"USER_DEFAULTS_USERID"
#define USER_DEFAULTS_USERNAME      @"USER_DEFAULTS_USERNAME"

#define THE_APPDELEGATE ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define URL_BOOK_COLLECTIONS    @"https://api.douban.com/v2/book/user/%@/collections"
#define URL_BOOK_COLLECTION     @"https://api.douban.com/v2/book/%@/collection"
#define URL_BOOK_SEARCH         @"https://api.douban.com/v2/book/search"
#define URL_MOVIE_SEARCH        @"https://api.douban.com/v2/movie/search"
