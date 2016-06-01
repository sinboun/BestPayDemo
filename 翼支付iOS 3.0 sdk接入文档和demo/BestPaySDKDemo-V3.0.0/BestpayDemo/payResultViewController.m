//
//  payResultViewController.m
//  BestpayDemo
//
//  Created by jackzhou on 15/8/3.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

#import "payResultViewController.h"

#define bestpayDemo @"bestpayDemo"

@interface payResultViewController ()


@property (strong, nonatomic) IBOutlet UILabel *payResult;
@property (strong, nonatomic) IBOutlet UILabel *orderSeq;
@property (strong, nonatomic) IBOutlet UILabel *orderAmount;

- (IBAction)callbackBtn:(id)sender;

@end

@implementation payResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSDictionary *dic = [[self class] paramsFromString:self.payResultUrl];
    
    
    self.payResult.text = [NSString stringWithFormat:@"支付结果：支付%@",[self.resultDic objectForKey:@"result"]];
    self.orderSeq.text = [NSString stringWithFormat:@"订单号：%@",[self.resultDic objectForKey:@"ORDERSEQ"]];
    self.orderAmount.text = [NSString stringWithFormat:@"订单金额：%@ 元",[self.resultDic objectForKey:@"ORDERAMOUNT"]];
    
    
}

+ (NSDictionary *)paramsFromString:(NSString *)urlStr
{
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (urlStr == nil || [urlStr isEqualToString:@""] || ![urlStr hasPrefix:bestpayDemo])
    {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *str = [urlStr stringByReplacingOccurrencesOfString:bestpayDemo withString:@""];
    
    if ([str isEqualToString:@""])
    {
        return nil;
    }
    
    NSArray *array = [str componentsSeparatedByString:@"&"];
    
    

    //此处针对2.0.0版本及后续版本的数据处理
    if ([array count])
    {
        NSDictionary *tmpDic = [[self class] paramsFromKeyValueStr:str];
        [dic setDictionary:tmpDic];
    }
    
    return dic;
}

+ (NSDictionary *)paramsFromKeyValueStr:(NSString *)str
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *array = [str componentsSeparatedByString:@"&"];
    
    if ([array count]) {
        for (int i = 0; i < [array count]; i ++) {
            NSString *pStr = [array objectAtIndex:i];
            NSArray *kvArray = [pStr componentsSeparatedByString:@"="];
            if ([kvArray count] != 2) {
                continue;
            }
            NSString *key = [kvArray objectAtIndex:0];
            key = [key stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            NSString *value = [kvArray objectAtIndex:1];
            value = [value stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            
            [dic setObject:value forKey:key];
        }
    }
    
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callbackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
