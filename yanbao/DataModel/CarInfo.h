//
//  CarInfo.h
//  CheleNet
//
//  Created by aokuny on 14/12/17.
//
//

#import <Foundation/Foundation.h>
#import "RespModel.h"
@interface CarInfo : JSONModel
// 品牌
@property (nonatomic,strong) NSString *brandName;
// 引擎类型
@property (nonatomic,strong) NSString *vc2engineType;
// 排量
@property (nonatomic,strong) NSString *vc2engineOutput;
// 变速箱类型
@property (nonatomic,strong) NSString *vc2gearboxType;
@end
