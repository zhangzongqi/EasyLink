//
//  HomeDataModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/17.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "JSONModel.h"

@interface HomeDataModel : JSONModel


@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *id1; // 数据编号
@property (nonatomic, copy) NSString *summary; // 团购说明
@property (nonatomic, copy) NSString *low_price;  // 最低价格
@property (nonatomic, copy) NSString *high_price;  // 最高价格
@property (nonatomic, copy) NSString *start_datetime; // 开始时间
@property (nonatomic, copy) NSString *end_datetime; // 结束时间
@property (nonatomic, copy) NSString *low_sale_num_limit; // 最低成团量
@property (nonatomic, copy) NSString *sale_num; // 已售出数量
@property (nonatomic, copy) NSDictionary *img_multi; // 图片组
@property (nonatomic, copy) NSString *good_id; // 商品编号，用于获取商品评价数据


@end
