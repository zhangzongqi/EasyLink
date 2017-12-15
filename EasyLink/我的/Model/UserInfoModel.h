//
//  UserInfoModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/16.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfoModel : JSONModel

@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *sex; // 性别
@property (nonatomic, copy) NSString *birth_day; // 生日
@property (nonatomic, copy) NSString *province;  // 省份
@property (nonatomic, copy) NSString *city;  // 城市
@property (nonatomic, copy) NSString *icon; // 头像

@end
