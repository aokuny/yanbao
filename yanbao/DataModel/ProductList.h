//
//  ProductList.h
//  yanbao
//
//  Created by aokuny on 14/12/25.
//  Copyright (c) 2014年 ihandy. All rights reserved.
//

#import "JSONModel.h"
@protocol ProductModel
@end

@interface ProductModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*weight;
@property (nonatomic, strong) NSString <Optional>*fristPrice;
@property (nonatomic, strong) NSString <Optional>*vc2proId;
@property (nonatomic, strong) NSString <Optional>*vc2proYears;
@property (nonatomic, strong) NSString <Optional>*price;
@property (nonatomic, strong) NSString <Optional>*vc2proKm;
@property (nonatomic, strong) NSString <Optional>*strategysId;
@property (nonatomic, strong) NSString <Optional>*vc2proDescribe;
@property (nonatomic, strong) NSString <Optional>*vc2proName;
@property (nonatomic, strong) NSString <Optional>*vc2proImgpath;
@end

@interface ProductList : JSONModel
@property (nonatomic,strong) NSArray<ProductModel> *respBody;
@end
