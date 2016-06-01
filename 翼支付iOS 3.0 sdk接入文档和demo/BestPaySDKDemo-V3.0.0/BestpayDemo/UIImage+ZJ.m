//
//  UIImage+ZJ.m
//  Bestpay
//
//  Created by jackzhou on 15/4/25.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

#import "UIImage+ZJ.h"

@implementation UIImage (ZJ)
+ (UIImage *)imageWithName:(NSString *)name
{
    
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
