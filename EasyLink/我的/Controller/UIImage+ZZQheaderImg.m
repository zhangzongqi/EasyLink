//
//  UIImage+ZZQheaderImg.m
//  EasyLink
//
//  Created by 琦琦 on 16/10/28.
//  Copyright © 2016年 fengdian. All rights reserved.
//

#import "UIImage+ZZQheaderImg.h"

@implementation UIImage (ZZQheaderImg)

/*
 这是方法的实现
 
 @param size        需要虚线边框视图的大小
 @param color       边框颜色
 @param borderWidth 边框粗细
 
 @return 返回一张带边框的图片
 */
+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [[UIColor clearColor] set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, borderWidth);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGFloat lengths[] = { 3, 1 };
        CGContextSetLineDash(context, 0, lengths, 1);
        CGContextMoveToPoint(context, 0.0, 0.0);
        CGContextAddLineToPoint(context, size.width, 0.0);
        CGContextAddLineToPoint(context, size.width, size.height);
        CGContextAddLineToPoint(context, 0, size.height);
        CGContextAddLineToPoint(context, 0.0, 0.0);
        CGContextStrokePath(context);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
}



 + (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 22 * borderWidth;
    CGFloat imageH = oldImage.size.height + 22 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
