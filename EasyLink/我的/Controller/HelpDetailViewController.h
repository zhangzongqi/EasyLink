//
//  HelpDetailViewController.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/27.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>

// html内部加载完成方法
- (void)loadData;

@end

@interface HelpDetailViewController : UIViewController<UIWebViewDelegate,TestJSExport>

@property (nonatomic, copy) NSString *strId;

@property (strong, nonatomic) JSContext *context;

@end
