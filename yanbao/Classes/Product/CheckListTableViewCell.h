//
//  CheckListTableViewCell.h
//  yanbao
//
//  Created by aokuny on 15/3/20.
//  Copyright (c) 2015年 ihandy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInModel.h"
@interface CheckListTableViewCell : UITableViewCell
-(void) setCellDataForModel:(CheckInModel *)chkModel;
@end
