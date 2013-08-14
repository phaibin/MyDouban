//
//  Constants.h
//  MyDouban
//
//  Created by Leon on 13-7-31.
//  Copyright (c) 2013年 Leon. All rights reserved.
//


#define APP_KEY         @"004e785a8cb2933300eb690fa617b999"
#define APP_SECRET      @"9e4a5e1aa3a136df"
#define URL_AUTHORIZE   @"https://www.douban.com/service/auth2/auth"
#define URL_TOKEN       @"https://www.douban.com/service/auth2/token"
#define URL_REDIRECT    @"http://www.phaibin.tk"

#define USER_DEFAULTS_ACCESSTOKEN   @"USER_DEFAULTS_ACCESSTOKEN"
#define USER_DEFAULTS_REFRESHTOKEN  @"USER_DEFAULTS_REFRESHTOKEN"
#define USER_DEFAULTS_USERID        @"USER_DEFAULTS_USERID"

#define THE_APPDELEGATE ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define URL_USER_INFO           @"https://api.douban.com/v2/book/user/%@"
#define URL_BOOK_COLLECTIONS    @"https://api.douban.com/v2/book/user/%@/collections"
#define URL_BOOK_COLLECTION     @"https://api.douban.com/v2/book/%@/collection"
#define URL_BOOK_SEARCH         @"https://api.douban.com/v2/book/search"
#define URL_MOVIE_SEARCH        @"https://api.douban.com/v2/movie/search"

#define NOTIFICATION_CAHNGE_STATUS  @"NOTIFICATION_CAHNGE_STATUS"
#define NOTIFICATION_LOGIN          @"NOTIFICATION_LOGIN"
#define NOTIFICATION_LOGOUT         @"NOTIFICATION_LOGOUT"

#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]