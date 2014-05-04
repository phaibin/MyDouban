//
//  Constants.h
//  MyDouban
//
//  Created by Leon on 13-7-31.
//  Copyright (c) 2013年 Leon. All rights reserved.
//

#define IOS7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define APP_KEY         @"004e785a8cb2933300eb690fa617b999"
#define APP_SECRET      @"9e4a5e1aa3a136df"
#define URL_AUTHORIZE   @"https://www.douban.com/service/auth2/auth"
#define URL_TOKEN       @"https://www.douban.com/service/auth2/token"
#define URL_REDIRECT    @"http://www.phaibin.tk"

#define USER_DEFAULTS_ACCESSTOKEN   @"USER_DEFAULTS_ACCESSTOKEN"
#define USER_DEFAULTS_REFRESHTOKEN  @"USER_DEFAULTS_REFRESHTOKEN"
#define USER_DEFAULTS_USERID        @"USER_DEFAULTS_USERID"

#define THE_APPDELEGATE ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define URL_USER_INFO           @"https://api.douban.com/v2/user/%@"
#define URL_BOOK_COLLECTIONS    @"https://api.douban.com/v2/book/user/%@/collections"
#define URL_BOOK_COLLECTION     @"https://api.douban.com/v2/book/%@/collection"
#define URL_BOOK_SEARCH         @"https://api.douban.com/v2/book/search"
#define URL_MOVIE_SEARCH        @"https://api.douban.com/v2/movie/search"

#define NOTIFICATION_CAHNGE_STATUS  @"NOTIFICATION_CAHNGE_STATUS"
#define NOTIFICATION_LOGIN          @"NOTIFICATION_LOGIN"
#define NOTIFICATION_LOGOUT         @"NOTIFICATION_LOGOUT"

// Color
#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kTextColor                      RGBCOLOR(51, 51, 51)
#define kLightTextColor                 RGBCOLOR(102, 102, 102)
#define kButtonBackgroundColor          RGBCOLOR(72, 178, 239)


#define kCellSelectionColor     RGBCOLOR(237, 237, 237)
#define kOrangeColor            RGBCOLOR(244, 153, 37)
#define kOrangeShadowColor      RGBCOLOR(153, 108, 23)
#define kOrderSelectedColor     RGBACOLOR(163, 202, 233, 0.5)
#define kGrayColor2                  RGBACOLOR(99, 99, 99)
#define kBlueColor1                  RGBACOLOR(17, 84, 190)
#define kBlackBarColor          RGBACOLOR(0, 0, 0, 0.8)
#define kWhiteBarColor          RGBACOLOR(255, 255, 255, 0.8)

#define kDefaultTextColor      RGBCOLOR(124, 135, 165)
#define kDefaultBlueColor      RGBCOLOR(106, 119, 157)

#define kDefaultBarColor      RGBCOLOR(51, 51, 51)


#define UIColorWithHex(hexValue) [UIColor colorWithHex:hexValue]
