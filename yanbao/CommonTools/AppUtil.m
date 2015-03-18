//
//  CLAppUtil.m
//  CheleNetClinet
//
//  Created by Marin on 14-9-16.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "AppUtil.h"
NSString *const shareSdkAppKey = @"31e158d89d0c";
NSString *const shareSdkAppSecret = @"08bcb290e9968e56744f0625c92e6f77";
NSString *const loadingHintStr = nil;
NSString *const kServiceErrStr = @"后台报错，请联系开发人员";
NSString *const kValidateErrStr = @"请确认您输入的信息是否正确，请重新输入。";
NSString *const kNeedLoginErrStr = @"您还未登陆,请您先登陆后在操作";
void showAlertTitleMsg(NSString *title,NSString *message) {
    UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

void showAlertMessage(NSString *message) {
    showAlertTitleMsg(@"温馨提示", message);
}

void showAlertError(NSError *err) {
    showAlertTitleMsg(@"出错了", err.localizedDescription );
}

float topNavBarMargin() {
    if (!CLSystemVersionGreaterOrEqualThan(7.0)) {
        return 44.f;
    } else {
        return 64.f;
    }
}

@implementation AppUtil

+ (NSString *)validateMobile:(NSString *)string {
    NSString *err = nil;
    NSString *regex = @"^1[0,1,2,3,4,5,6,7,8,9]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	if (![predicate evaluateWithObject:string] )
	{
        err= @"手机号码必须为1开头的11位数字。";
	}
    return err;

}

+ (NSString *)validateEmail:(NSString *)string {
    NSString *err = nil;
    NSString *regex = @"^[a-zA-Z0-9]{1}([a-zA-Z0-9_\\.-])+@(([a-zA-Z0-9-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	if (![predicate evaluateWithObject:string] )
	{
		err = @"电子邮件格式不合法。";
	}
    return err;
}

+(NSString* )validateIdentityNo :(NSString *)identityStr{
    NSString *err = nil;
    NSString *regex = @"(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:identityStr] )
	{
		err = @"请填写合法身份证号码";
        return err;
	}
    //18位身份证校验码验证
    if (identityStr.length == 18) {
        int numberArray[17] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
        char checkbit[11] = {'1','0', 'X','9', '8', '7', '6', '5', '4', '3', '2'};
        int result  = 0;
        for (int i = 0; i < 17; i ++) {
            result += numberArray[i] * [[identityStr substringWithRange:NSMakeRange(i, 1)]intValue];
        }
        result = result%11;
        char lastCharacter = [identityStr characterAtIndex:17];
        JMLog(@"末尾数字是%c，正确的校验码%c",lastCharacter,checkbit[result]);
        if (checkbit[result]!=lastCharacter) {
            err = @"请填写合法身份证号码";
            return err;
        }
    }
    /*//年龄18周岁校验
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDate *startDate = nil;
    if (identityStr.length == 15) {
        [dateFormatter setDateFormat:@"yyMMdd"];
        startDate = [dateFormatter dateFromString:[identityStr substringWithRange:NSMakeRange(6, 6)]];
    } else if(identityStr.length == 18) {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        startDate = [dateFormatter dateFromString:[identityStr substringWithRange:NSMakeRange(6, 8)]];
    }
    if (startDate == nil) {
        return @"请填写合法身份证号码";
    }
    NSDate *endDate= [NSDate date];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    JMLog(@"year %d,months %d, days %d",[comps year], [comps month], [comps day]);
    if ([comps year]<18) {
        NSString *Str = @"未满18周岁";
        return Str;
    }*/
    return err;
}

+(NSString* )validateQQNumber :(NSString *)numberString{
    
    NSString *regex = @"[1-9][0-9]\\d{2,}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	if (![predicate evaluateWithObject:numberString] )
	{
		NSString *Str = @"qq格式错误。";
		return Str;
	}
    return nil;
}

//判断0100 00.2
+(BOOL)checkNumberStr:(NSString *)numberStr
{
    NSArray * array = [numberStr componentsSeparatedByString:@"."];
    NSString * newStr = [array objectAtIndex:0];
    
    if ([newStr length] >= 2) {
        NSRange range;
        range.location = 0;
        range.length = 1;
        if ([[newStr substringWithRange:range] intValue] == 0) {
            return YES;
        }
    }
    return NO;
}


+(BOOL)validateDecimalStr:(NSString *)numberStr {
    long int len = [numberStr length];
	if (len == 0)
	{
        return NO;
	}
    if([self checkNumberStr:numberStr])
    {
        return NO;
    }
    
	NSString *regex = @"^[+-]?((\\d+(\\.\\d*)?)|(\\.\\d+))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [predicate evaluateWithObject:numberStr];
}

//yyyy-MM-dd HH:mm:ss
//20140424转化为2014-04-24
+(NSString *)getTheDateStr:(NSString *)dateStr fromTimeType:(NSString *)fromTimeTypeStr toTimeType:(NSString *)toTimeTypeStr {
    if (!dateStr) return @"";
    if ([dateStr isKindOfClass:[NSNull class]]) return @"";
    if (dateStr.length != fromTimeTypeStr.length) {
        return dateStr;
    }
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:fromTimeTypeStr];
    NSDate *date= [dateFormater dateFromString:dateStr];
    [dateFormater setDateFormat:toTimeTypeStr];
    return [dateFormater stringFromDate:date];
}

+(NSString *)decimalStyleNumber:(NSNumber *)valueNum {
    return  [self decimalStyleNumber:valueNum withDigits:2];
    
}

+(NSString *)decimalStyleNumber:(NSNumber *)valueNum withDigits:(NSUInteger )minimumFractionDigits {
    /*NSLog(@"%@", [valueNum stringValue] );*/
    NSString *decimalStyleStr = @"";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [formatter setMinimumFractionDigits:minimumFractionDigits];
    [formatter setMaximumFractionDigits:minimumFractionDigits];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    decimalStyleStr = [formatter stringFromNumber:valueNum];
    
    return decimalStyleStr;
}


+(NSString *)decimalStyleString:(NSString *)valueStr {
    return  [self decimalStyleString:valueStr withDigits:2];
}

+(NSString *)decimalStyleString:(NSString *)valueStr withDigits:(NSUInteger )minimumFractionDigits {
    NSString *decimalStyleStr = @"";
    NSNumber *numberVal = [NSNumber numberWithDouble:[ valueStr doubleValue]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [formatter setMinimumFractionDigits:minimumFractionDigits];
    [formatter setMaximumFractionDigits:minimumFractionDigits];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    decimalStyleStr = [formatter stringFromNumber:numberVal];
    
    return decimalStyleStr;
}
#pragma mark 风格字典，根据key获取值
+(NSString *) getProjectStyleValueWithKey:(NSString *)styleKey{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"projectStyle" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (styleKey!=nil&&styleKey.length>0) {
        return [data objectForKey:styleKey];
    }
    return @"";
}



+(CGFloat)getHeight:(NSString *)text font:(UIFont *)font  size:(CGSize )size{
    CGFloat height = 0.0f;
    NSArray *stringArray =[text componentsSeparatedByString:@"\n"];
    for (NSUInteger count=0; count<stringArray.count; count++) {
        NSString *oneString=(NSString *)[stringArray objectAtIndex:count];
        height+=[self getHeightWithoutbBackspace:oneString font:(UIFont *)font size:size];
    }
    return height;
}

+(CGFloat)getHeightWithoutbBackspace:(NSString *)text font:(UIFont *)font  size:(CGSize )size{
    CGFloat height = 0.0f;
    
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:font}];
    height = [attrString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    return height;
}

+(id)loadObjFromFile:(NSString *)fileName {
    NSString *file = [fileName stringByDeletingPathExtension];
    NSString *extension = [fileName pathExtension];
    NSURL *url = [[NSBundle mainBundle]URLForResource:file withExtension:extension];
    NSError *err = nil;
    NSString *jsonStr = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    if (err) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return obj;
}

+(NSString *)objToJsonStr:(id)obj {
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return err.localizedDescription;
    }
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
+(NSString *) timerToDate:(NSString *) timeStr{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeInterval timeInterval = [timeStr doubleValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [formatter stringFromDate:date2];
//    NSDate* date = [formatter dateFromString:timeStr];
//    return [formatter stringFromDate:date];
//    NSString *timeStrS = [NSString stringWithString:timeStr];
//    
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStrS doubleValue]];
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//
//    return  confromTimespStr;
    return timeStr;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
@end
