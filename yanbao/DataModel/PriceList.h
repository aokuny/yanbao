//
//  PriceList.h
//  yanbao
//
//  Created by aokuny on 14/12/25.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "JSONModel.h"

@protocol PriceModel
@end

@interface PriceModel:JSONModel

@property (nonatomic,strong) NSString <Optional> *vc2proId;
@property (nonatomic,strong) NSString <Optional> *proPrice;
@property (nonatomic,strong) NSString <Optional> *price;
@property (nonatomic,strong) NSString <Optional> *vc2proName;

@end

@interface PriceList : JSONModel

@property (nonatomic,strong) NSArray<PriceModel>* respBody;

@end
