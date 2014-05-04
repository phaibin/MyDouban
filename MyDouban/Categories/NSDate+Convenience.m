//
//  NSDate+Convenience.m
//  FiveStar
//
//  Created by Leon on 13-1-14.
//
//

#import "NSDate+Convenience.h"

@implementation NSDate (Convenience)

-(NSInteger)year {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}


-(NSInteger)month {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

-(NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

-(NSInteger)hour {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}

-(NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

+(NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: date];
    return [gregorian dateFromComponents:components];
}

- (NSString*)weekString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:kCFCalendarUnitWeekday fromDate:self] ;
    switch (dateComponents.weekday)
    {
        case 1:
        {
            return NSLocalizedString(@"sunday", @"");
        }
            break;
            
        case 2:
        {
            return NSLocalizedString(@"monday", @"");
        }
            break;
            
        case 3:
        {
            return NSLocalizedString(@"tuesday", @"");
        }
            break;
            
        case 4:
        {
            return NSLocalizedString(@"wednesday", @"");
        }
            break;
            
        case 5:
        {
            return NSLocalizedString(@"thursday", @"");
        }
            break;
            
        case 6:
        {
            return NSLocalizedString(@"friday", @"");
        }
            break;
            
        case 7:
        {
            return NSLocalizedString(@"saturday", @"");
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}

+ (NSInteger)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    //    int months = [comps month];
    NSInteger days = [comps day];
    return days;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format
{
    if (!format)
        format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date =[dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    if (!format)
        format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end
