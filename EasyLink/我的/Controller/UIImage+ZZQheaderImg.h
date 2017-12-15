//
//  UIImage+ZZQheaderImg.h
//  EasyLink
//
//  Created by 琦琦 on 16/10/28.
// 截取圆形的头像 / 做边框
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(ZZQheaderImg)

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

@end
