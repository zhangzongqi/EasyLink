//
//  GroupDetailViewController.h
//  EasyLink
//
//  Created by 琦琦 on 17/2/8.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>

// html内部加载完成方法
- (void)loadData;

@end

@interface GroupDetailViewController : UIViewController<UIWebViewDelegate,TestJSExport>

@property (nonatomic, copy) NSString *strStatus;   // 1 拼团中

@property (nonatomic, copy) NSString *goodsId; // 数据id

@property (nonatomic, copy) NSString *pingjiaId; // 用于获取评价数据的id

@property (strong, nonatomic) JSContext *context;

@end
