//
//  NSDate+Convenience.h
//  FiveStar
//
//  Created by Leon on 13-1-14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

-(NSInteger)year;
-(NSInteger)month;
-(NSInteger)day;
-(NSInteger)hour;
- (NSString*)weekString;
-(NSDate *)offsetDay:(int)numDays;
+(NSDate *)dateStartOfDay:(NSDate *)date;
+ (NSInteger)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

@end
