//
//  UIImage+ZJ.h
//  Bestpay
//
//  Created by jackzhou on 15/4/25.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (JW)
/**
 *  加载图片
 *
 *  @param name 图片名
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 *
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

@end
