//
//  JWTitleButton.m
//  JackWeibo
//
//  Created by jackzhou on 15/4/26.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "TypeOfPayButton.h"
#import "UIImage+ZJ.h"

@implementation TypeOfPayButton

+ (instancetype)titleButton
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮时不要自动调整图标
        self.adjustsImageWhenDisabled = NO;
        // 图标居中
        self.imageView.contentMode = UIViewContentModeBottomRight;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        // 图标
        [self.imageView setImage:[UIImage imageNamed:@"down_dark"]];
        // 文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}



- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = 30;
    CGFloat imageX = contentRect.size.width - imageW - 5;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 10;
    CGFloat titleW = contentRect.size.width - 20;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}



@end
