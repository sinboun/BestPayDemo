//
//  BestpayNativeModel.h
//  H5ContainerFramework
//
//  Created by jackzhou on 08/03/15.
//  Copyright (c) 2015 tydic. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  接入商户需要传递给SDK的参数信息模型
 */
@interface BestpayNativeModel : NSObject

typedef NS_ENUM(NSUInteger, LaunchType1)
{
    launchTypePay1=0,          //支付跳转
    launchTypeRecharge1      //充值跳转
    
};

// 订单详细信息，具体参数和拼接规则请阅览《接口文档》及SDK使用文档
@property (nonatomic,strong)NSString * orderInfo;

// 支付类型
@property (nonatomic,assign)LaunchType1  launchType;

// 商户APP scheme, 以供回调所用
@property (nonatomic,strong)NSString * scheme;

@end
