//
//  PingJiaModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/17.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "JSONModel.h"

@interface PingJiaModel : JSONModel

@property (nonatomic, copy) NSString *user_nickname; // 用户昵称
@property (nonatomic, copy) NSString *user_id; // 数据编号
@property (nonatomic, copy) NSString *user_icon;  // 用户头像
@property (nonatomic, copy) NSString *star;  // 评价星级
@property (nonatomic, copy) NSArray *img_show; // 评价图片
@property (nonatomic, copy) NSString *summary; // 评价详情
@property (nonatomic, copy) NSString *create_time; // 评价时间

@end
