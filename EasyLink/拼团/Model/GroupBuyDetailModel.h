//
//  GroupBuyDetailModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/18.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "JSONModel.h"

@interface GroupBuyDetailModel : JSONModel

@property (nonatomic, copy) NSString *id1; // 数据编号
@property (nonatomic, copy) NSString *title; // 商品名称
@property (nonatomic, copy) NSString *low_price;  // 最低价
@property (nonatomic, copy) NSString *high_price;  // 最高价
@property (nonatomic, copy) NSArray *start_datetime; // 开始时间
@property (nonatomic, copy) NSString *end_datetime; // 结束时间
@property (nonatomic, copy) NSString *low_sale_num_limit; // 最低成团人数
@property (nonatomic, copy) NSString *sale_num; // 已售出件数
@property (nonatomic, copy) NSString *virtual_sale_num; //
@property (nonatomic, copy) NSDictionary *img_multi; //  图片数组
@property (nonatomic, copy) NSArray *img_show; // 橱窗图片
@property (nonatomic, copy) NSArray *specList; // 分类数组
@property (nonatomic, copy) NSArray *specItemPriceList; // 所有组合数组
@property (nonatomic, copy) NSString *good_id; // 商品id

@end
