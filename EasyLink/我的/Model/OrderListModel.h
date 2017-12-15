//
//  OrderListModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/27.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface OrderListModel : JSONModel


@property (nonatomic, copy) NSString *order_sn; // 订单编号
@property (nonatomic, copy) NSString *show_status; // 订单显示状态标识，相见文档“显示订单状态标识及对应状态说明”
@property (nonatomic, copy) NSString *show_status_title; // 订单状态显示标题
@property (nonatomic, copy) NSString *order_status; // 订单状态
@property (nonatomic, copy) NSString *pay_status; // 支付状态
@property (nonatomic, copy) NSString *ship_status; // 发货状态
@property (nonatomic, copy) NSString *money_order; // 订单价格
@property (nonatomic, copy) NSString *money_pay; // 付款金额（实付金额）
@property (nonatomic, copy) NSString *goupbuy_low_sale_num_limit; // 团购类-最低销售数量
@property (nonatomic, copy) NSString *goupbuy_sale_num; // 团购类-实际销售数量
@property (nonatomic, copy) NSString *groupbuy_start_datetime; // 团购类-开始时间
@property (nonatomic, copy) NSString *groubuy_end_datetime; // 团购类-结束时间
@property (nonatomic, copy) NSString *sub_order_low_sale_num_limit; // 小拼购-最低购买数量
@property (nonatomic, copy) NSString *sub_order_sale_num; // 小拼购-实际销售数量
@property (nonatomic, copy) NSArray *order_goods; // 商品相关信息


@end
