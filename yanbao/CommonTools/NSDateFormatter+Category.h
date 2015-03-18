//
//  NSDateFormatter+Category.h
//  CheleNetClinet
//
//  Created by aokuny on 14-11-3.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Category)

+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
