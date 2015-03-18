//
//  UIView+Addtions.m
//  CheleNetClinet
//
//  Created by aokuny on 14/10/20.
//  Copyright (c) 2014年 aokuny. All rights reserved.//

#import "UIView+Addtions.h"

@implementation UIView (Addtions)
-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}

-(UITableView *)listTableView
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UITableView class]]) {
            
            return (UITableView *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}

-(UITableViewCell *)listTableViewCell {
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UITableViewCell class]]) {
            
            return (UITableViewCell *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}
@end
