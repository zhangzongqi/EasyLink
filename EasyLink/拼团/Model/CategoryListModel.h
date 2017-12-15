//
//  CategoryListModel.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/21.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import "JSONModel.h"

@interface CategoryListModel : JSONModel

@property (nonatomic, copy) NSString *id1; // 编号
@property (nonatomic, copy) NSString *pid; // 上级的编号
@property (nonatomic, copy) NSString *path; // 路径
@property (nonatomic, copy) NSString *title; // 苹果
@property (nonatomic, copy) NSArray *subList; // 下级分类

@end
