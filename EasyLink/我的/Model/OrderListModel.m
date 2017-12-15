//
//  OrderListModel.m
//  EasyLink
//
//  Created by 琦琦 on 2017/5/27.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

// 属性是否可选
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

// 重写此方法 解决借口名字和系统名字冲突问题
+(JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"id1"}];
}

@end
