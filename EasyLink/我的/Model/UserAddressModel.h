//
//  UserAddressModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/28.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "JSONModel.h"

@interface UserAddressModel : JSONModel

@property (nonatomic, copy) NSString *id1; // 编号
@property (nonatomic, copy) NSString *consignee; // 收货人
@property (nonatomic, copy) NSString *phone; // 手机号
@property (nonatomic, copy) NSString *province; // 省
@property (nonatomic, copy) NSString *city; // 市
@property (nonatomic, copy) NSString *district; // 区
@property (nonatomic, copy) NSString *town; // 街道
@property (nonatomic, copy) NSString *last_region_id; // 最后一项区域编号
@property (nonatomic, copy) NSString *address; // 详细地址

@end
