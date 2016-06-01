//
//  BestpaySDK.h
//  H5ContainerFramework
//
//  Created by jackzhou on 08/03/15.
//  Copyright (c) 2015 tydic. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BestpayNativeModel.h"

@interface BestpaySDK : NSObject
typedef void(^CompletionBlock)(NSDictionary *resultDic);


/**
 *  支付订单调用H5接口方法
 *
 *  @param order  订单请求所需的数据模型
 *  @param hostvc 源Controller
 */
+(void)payWithOrder:(BestpayNativeModel *)order fromViewController:(UIViewController *)hostvc callback:(CompletionBlock)completionBlock;

+(void)processOrderWithPaymentResult:(NSURL *)resultUrl
                     standbyCallback:(CompletionBlock)completionBlock;
@end
