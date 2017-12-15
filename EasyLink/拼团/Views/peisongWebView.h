//
//  peisongWebView.h
//  EasyLink
//
//  Created by 琦琦 on 2017/5/21.
//  Copyright © 2017年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface peisongWebView : UIView<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) UIView *topView; // 顶部视图

// 创建frame
- (id) initWithFrame:(CGRect)frame WithWebUrl:(NSString *)urlStr;

@end
