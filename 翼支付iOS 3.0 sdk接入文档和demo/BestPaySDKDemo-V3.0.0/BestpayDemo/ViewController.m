//
//  ViewController.m
//  BestpayDemo
//
//  Created by jackzhou on 15/7/13.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

//#import <H5ContainerFramework/H5ContainerFramework.h>
//#import <H5ContainerFramework/BestpaySDK.h>
//#import <H5ContainerFramework/NativeModel.h>


#import "BestpaySDK.h"
#import "BestpayNativeModel.h"
#import "ViewController.h"
#import "payResultViewController.h"

#import "TypeOfPayButton.h"
#import "UIImage+ZJ.h"
#import <Security/Security.h>
#import "MD5.h"

//流程测试商户
//#define KEYSTR @"D384FF6A1EA86E3FC6463B59A0257D41CB217449331BCE78"
//#define MERID @"02320103012904000"
//#define PSWD @"881522"

#define KEYSTR @"A52E53D3B6FE39EF33326C297BB05AA9305E8C7042E2DD62"
#define MERID @"01520109014125000"
#define PSWD @"137293"

//#define KEYSTR @"DC9BD97DD776B77E2AC7927431B4C5CB3D86597B89316CDD"
//#define MERID @"02110103035118000"
//#define PSWD @"750319"

//#define KEYSTR @"344C4FB521F5A52EA28FB7FC79AEA889478D4343E4548C02"
//#define MERID @"043101180050000"
//#define PSWD @"534231"

//#define KEYSTR @"7589C427B91D03B60C8ABC3476D3257472008CB2DA79518F"
//#define MERID @"03310101101078000"
//#define PSWD @"538419"

//#define KEYSTR @"E96912EC781748F1BD4F701003A061C65E95CE2F2A0FB1FA"
//#define MERID @"0231010303492/Users/RuiYou/Pictures/SDK源文件带密码控件 old9000"
//#define PSWD @"791408"


@interface ViewController ()<NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *noOfMerchant;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet TypeOfPayButton *typeOfPayBtn;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (weak, nonatomic) IBOutlet UITextField *ipAddress;
- (IBAction)submitBtn:(id)sender;
@property (nonatomic, assign) BOOL isClickedOfType;
@property (nonatomic,strong) UIView *typeOfPayView;
@property (nonatomic,strong) UIView *shadeView;
@property (nonatomic,strong) UIButton *typeOneBtn;
@property (nonatomic,strong) UIButton *typeTwoBtn;
@property (nonatomic,strong) UILabel *lineLabel;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic,strong) UITapGestureRecognizer *bgTap;

@property (nonatomic, copy)   NSString *encodeOrderStr;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
    
    
    NSLog(@"%@",[[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] firstObject]);
    
    
    
    self.isClickedOfType = NO;
    // Do any additional setup after loading the view, typically from a nib.
    [self.typeOfPayBtn setImage:[UIImage imageNamed:@"down_dark"] forState:UIControlStateNormal];
    [self.typeOfPayBtn.imageView setContentMode:UIViewContentModeScaleToFill];
    [self.typeOfPayBtn addTarget:self action:@selector(typeOfPaySelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    
    [self.view addGestureRecognizer:bgTap];
    self.bgTap = bgTap;

}

/**
 *  测试服务器选择功能
 *
 *  @param btn 点击后弹出下拉框
 */
- (void)typeOfPaySelected:(TypeOfPayButton *)btn
{
    // 测试服务器选择
    if (!self.isClickedOfType) {
        // 添加遮罩view
        UIView *shadeView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        shadeView.tag = 1000;
        shadeView.backgroundColor = [UIColor grayColor];
        shadeView.alpha = 0.6f;
        [self.view addSubview:shadeView];
        self.shadeView = shadeView;
        
        UIView *typeOfPayView = [[UIView alloc] initWithFrame:CGRectMake(self.typeOfPayBtn.frame.origin.x, self.typeOfPayBtn.frame.origin.y +  self.typeOfPayBtn.bounds.size.height, self.typeOfPayBtn.bounds.size.width, self.typeOfPayBtn.bounds.size.height * 2 + 1)];
        typeOfPayView.backgroundColor = [UIColor whiteColor];
        self.typeOfPayView = typeOfPayView;
        
        
        UIButton *typeOneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.typeOfPayBtn.bounds.size.width, self.typeOfPayBtn.bounds.size.height)];
        typeOneBtn.backgroundColor = [UIColor orangeColor];
        [typeOneBtn setTitle:@"1. 服务器IP" forState:UIControlStateNormal];
        typeOneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        typeOneBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [typeOneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeOneBtn addTarget:self action:@selector(typeOneSelected:) forControlEvents:UIControlEventTouchUpInside];
        self.typeOneBtn = typeOneBtn;
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.typeOfPayBtn.bounds.size.height, self.typeOfPayBtn.bounds.size.width, 1)];
        lineLabel.backgroundColor = [UIColor blackColor];
        self.lineLabel = lineLabel;
        [typeOfPayView addSubview:lineLabel];
        
        UIButton *typeTwoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.typeOfPayBtn.bounds.size.height + 1, self.typeOfPayBtn.bounds.size.width, self.typeOfPayBtn.bounds.size.height)];
        typeTwoBtn.backgroundColor = [UIColor orangeColor];
        [typeTwoBtn setTitle:@"2. 私网IP" forState:UIControlStateNormal];
        typeTwoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        typeTwoBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [typeTwoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeTwoBtn addTarget:self action:@selector(typeTwoSelected:) forControlEvents:UIControlEventTouchUpInside];
        self.typeTwoBtn = typeTwoBtn;
        [typeOfPayView addSubview:typeOneBtn];
        [typeOfPayView addSubview:typeTwoBtn];
        
        CGRect rect = self.typeOfPayView.frame;
        CGRect rectTemp = self.typeOfPayView.frame;
        rectTemp.size.height = 0;
        self.typeOfPayView.frame = rectTemp;
        [self.view addSubview:typeOfPayView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.typeOfPayBtn.imageView.transform = CGAffineTransformRotate(self.typeOfPayBtn.imageView.transform, M_PI);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.typeOfPayView.alpha = 0.2f;
            self.typeOneBtn.alpha = 0.2f;
            self.typeTwoBtn.alpha = 0.2f;
            self.lineLabel.alpha = 0.2f;
            
            self.typeOfPayView.alpha = 1.0f;
            self.typeOneBtn.alpha = 1.0f;
            self.typeTwoBtn.alpha = 1.0f;
            self.lineLabel.alpha = 1.0f;
            self.typeOfPayView.frame = rect;
            NSLog(@"%f",self.typeOfPayView.frame.size.height);
            //            self.typeOneBtn.frame = rect;
            //            self.typeTwoBtn.frame = rect;
            //            self.lineLabel.frame = rect;
            
        }completion:^(BOOL finished) {
            UITapGestureRecognizer *btnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
            [self.shadeView addGestureRecognizer:btnTap];
            
            self.isClickedOfType = YES;
        }];
        
    }
    else{
        
        [self hiddenTypeOfPayView];
    }
}

/**
 *  隐藏下拉框
 */
- (void)hiddenTypeOfPayView
{
    if (self.isClickedOfType != NO) {
        self.isClickedOfType = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.typeOfPayBtn.imageView.transform = CGAffineTransformRotate(self.typeOfPayBtn.imageView.transform, M_PI);
    }];
    
    CGRect rect = self.typeOfPayView.frame;
    rect.size.height = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.typeOfPayView.alpha = 1.0f;
        self.typeOneBtn.alpha = 1.0f;
        self.typeTwoBtn.alpha = 1.0f;
        self.lineLabel.alpha = 1.0f;
        
        self.typeOfPayView.alpha = 0.2f;
        self.typeOneBtn.alpha = 0.2f;
        self.typeTwoBtn.alpha = 0.2f;
        self.lineLabel.alpha = 0.2f;
        
        self.typeOfPayView.frame = rect;
        NSLog(@"%f",self.typeOfPayView.frame.size.height);
        //                    self.typeOneBtn.frame = rect;
        //                    self.typeTwoBtn.frame = rect;
        //                    self.lineLabel.frame = rect;
        
    }completion:^(BOOL finished) {
        [self.typeOneBtn removeFromSuperview];
        [self.typeTwoBtn removeFromSuperview];
        [self.lineLabel removeFromSuperview];
        [self.typeOfPayView removeFromSuperview];
        
        [self.shadeView removeGestureRecognizer:self.bgTap];
        [self.shadeView removeFromSuperview];
        
        
    }];
}

/**
 *  选择按钮点击后的处理事件
 *
 */
- (void)typeOneSelected:(TypeOfPayButton *)typeOneBtn
{
    [self.typeOfPayBtn setTitle:@"1. 服务器IP" forState:UIControlStateNormal];
    self.typeOfPayBtn.tag = 1;
    [self hiddenTypeOfPayView];
}
- (void)typeTwoSelected:(TypeOfPayButton *)typeTwoBtn
{
    [self.typeOfPayBtn setTitle:@"2. 私网IP" forState:UIControlStateNormal];
    
    self.typeOfPayBtn.tag = 2;
    [self hiddenTypeOfPayView];
    
}



//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//    if (buttonIndex == 1) {//ok
//
//    }
//
//}

/**
 *  手势处理
 */
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    if (self.isClickedOfType == YES) {
        [self hiddenTypeOfPayView];
        
        [self.shadeView removeGestureRecognizer:tap];
    }
    [self.view endEditing:YES];
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//noOfMerchant;
//code;
//money;
//typeOfPayBtn;
//phoneNumber;
- (IBAction)submitBtn:(id)sender {
    
    
    
//    //获取订单信息
//    NSString *orderStr = @"SERVICE=mobile.securitypay.pay&MERCHANTID=01520109014125000&MERCHANTPWD=137293&SUBMERCHANTID=&BACKMERCHANTURL=http://127.0.0.1:8040/wapBgNotice.action&ORDERSEQ=2016041820564901&ORDERREQTRANSEQ=20160418205649010004&ORDERTIME=20160418155153&ORDERVALIDITYTIME=&CURTYPE=RMB&ORDERAMOUNT=0.01&SUBJECT=纯支付&PRODUCTID=04&PRODUCTDESC=联想手机&CUSTOMERID=gehudedengluzhanghao&SWTICHACC=&SIGN=6B6BF707190EE2D757C035AD95F10072&PRODUCTAMOUNT=0.01&ATTACHAMOUNT=0.00&ATTACH=88888&ACCOUNTID=&USERIP=228.112.116.118&BUSITYPE=09&EXTERNTOKEN=NO&SIGNTYPE=MD5";
//    
//
//    
//    
//    
//    /////////////////////////////////
//    NSLog(@"跳转支付页面带入信息：%@", orderStr);
//    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
//    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
//    
//    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
//    order.orderInfo = orderStr;
//    order.launchType = launchTypePay1;
//    order.scheme = [[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] firstObject];
//    
//    [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
//        NSLog(@"result == %@", resultDic);
//        payResultViewController *payResultVC = [[payResultViewController alloc] initWithNibName:@"payResultViewController" bundle:nil];
//        payResultVC.resultDic = resultDic;
//        [self.navigationController pushViewController:payResultVC animated:YES];
//    }];

    
    
    
    [self submitOrder];
}
//获取当前时间戳
- (NSString *)getOrderTrSeq{
    NSDate *senddate=[NSDate date];
    NSString *locationString = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    return locationString;
}

//获取当前时间毫秒级
- (NSString *)getOrderTimeMS{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmssSS"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

//获取当前时间分钟级
- (NSString *)getOrderTime{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

//订单处理
- (void)doOrder{
    
    //获取订单信息
    NSString *orderStr = [self orderInfos];

    /////////////////////////////////
    NSLog(@"跳转支付页面带入信息：%@", orderStr);
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = orderStr;
    order.launchType = launchTypePay1;
    order.scheme = [[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] firstObject];
    
    [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
        NSLog(@"result == %@", resultDic);
        payResultViewController *payResultVC = [[payResultViewController alloc] initWithNibName:@"payResultViewController" bundle:nil];
        payResultVC.resultDic = resultDic;
        [self.navigationController pushViewController:payResultVC animated:YES];
    }];
    
}

#pragma mark -
#pragma mark  Private Methods
- (NSString *)orderInfos{
    
    NSMutableString * orderDes = [NSMutableString string];
    
    // 签名参数
    //1. 接口名称
    NSString *service = @"mobile.securitypay.pay";
    [orderDes appendFormat:@"SERVICE=%@", service];
    //2. 商户号
    [orderDes appendFormat:@"&MERCHANTID=%@", MERID];
    //3. 商户密码 由翼支付网关平台统一分配给各接入商户
    [orderDes appendFormat:@"&MERCHANTPWD=%@", PSWD];
    //4. 子商户号
    [orderDes appendFormat:@"&SUBMERCHANTID=%@", @""];
    //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
    [orderDes appendFormat:@"&BACKMERCHANTURL=%@", @"http://127.0.0.1:8040/wapBgNotice.action"];
    //    [orderDes appendFormat:@"&NOTIFYURL=%@", @"http://127.0.0.1:8040/wapBgNotice.action"];
    //6. 订单号
    [orderDes appendFormat:@"&ORDERSEQ=%@", [_params objectForKey:@"ORDERSEQ"]];
    //7. 订单请求流水号，唯一
    [orderDes appendFormat:@"&ORDERREQTRANSEQ=%@", [_params objectForKey:@"ORDERREQTRNSEQ"]];
    //8. 订单请求时间 格式：yyyyMMddHHmmss
    [orderDes appendFormat:@"&ORDERTIME=%@", [_params objectForKey:@"ORDERREQTIME"]];
    //9. 订单有效截至日期
    [orderDes appendFormat:@"&ORDERVALIDITYTIME=%@", @""];
    //10. 币种, 默认RMB
    [orderDes appendFormat:@"&CURTYPE=%@", @"RMB"];
    //11. 订单金额/积分扣减
    [orderDes appendFormat:@"&ORDERAMOUNT=%@", self.money.text];
    //    [orderDes appendFormat:@"&ORDERAMT=%@", self.money.text];
    //12.商品简称
    [orderDes appendFormat:@"&SUBJECT=%@", @"纯支付"];
    //13. 业务标识 optional
    [orderDes appendFormat:@"&PRODUCTID=%@", @"04"];
    //14. 产品描述 optional
    [orderDes appendFormat:@"&PRODUCTDESC=%@", @"联想手机"];
    //15. 客户标识 在商户系统的登录名 optional
    [orderDes appendFormat:@"&CUSTOMERID=%@", @"gehudedengluzhanghao"];
    //16.切换账号标识
    [orderDes appendFormat:@"&SWTICHACC=%@", @""];
    NSString *SignStr =[NSString stringWithFormat:@"%@&KEY=%@",orderDes,KEYSTR];
    //17. 签名信息 采用MD5加密
    NSString *signStr = [MD5 MD5:SignStr];
    [orderDes appendFormat:@"&SIGN=%@", signStr];
    
    
    //18. 产品金额
    [orderDes appendFormat:@"&PRODUCTAMOUNT=%@", self.money.text];
    //19. 附加金额 单位元，小数点后2位
    [orderDes appendFormat:@"&ATTACHAMOUNT=%@",@"0.00"];
    //20. 附加信息 optional
    [orderDes appendFormat:@"&ATTACH=%@", @"88888"];
    //21. 分账描述 optional
    //    [orderDes appendFormat:@"&DIVDETAILS=%@", @""];
    //22. 翼支付账户号
    [orderDes appendFormat:@"&ACCOUNTID=%@", @""];
    
    //23. 用户IP 主要作为风控参数 optional
    [orderDes appendFormat:@"&USERIP=%@", @"228.112.116.118"];
    //24. 业务类型标识
    [orderDes appendFormat:@"&BUSITYPE=%@", @"09"];
    
    //25.授权令牌
    [orderDes appendFormat:@"&EXTERNTOKEN=%@", @"NO"];
//    //27.客户端号
//    [orderDes appendFormat:@"&APPID=%@", @""];
//    //28.客户端来源
//    [orderDes appendFormat:@"&APPENV=%@", @"112233"];
    //27. 签名方式
    [orderDes appendFormat:@"&SIGNTYPE=%@", @"MD5"];
    
//    // 7个基本参数
//    //1. 接口名称
//    NSString *service = @"mobile.security.pay";
//    [orderDes appendFormat:@"SERVICE=%@", service];
//    //2. 商户号
//    [orderDes appendFormat:@"&MERCHANTID=%@", MERID];
//    //3. 商户密码 由翼支付网关平台统一分配给各接入商户
//    [orderDes appendFormat:@"&MERCHANTPWD=%@", PSWD];
//    //4. 子商户号
//    [orderDes appendFormat:@"&SUBMERCHANTID=%@", @""];
//    //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
//    [orderDes appendFormat:@"&BACKMERCHANTURL=%@", @"http://127.0.0.1:8040/wapBgNotice.action"];
//    //6. 签名方式
//    [orderDes appendFormat:@"&SIGNTYPE=%@", @"MD5"];
//    //7. 证信息 采用MD5加密
//    NSString *encodeOrderStr = [NSString stringWithFormat:@"MERCHANTID=%@&ORDERSEQ=%@&ORDERREQTRNSEQ=%@&ORDERTIME=%@&KEY=%@", MERID, [_params objectForKey:@"ORDERSEQ"], [_params objectForKey:@"ORDERREQTRNSEQ"] , [_params objectForKey:@"ORDERREQTIME"] , KEYSTR];
//    NSString *signStr = [MD5 MD5:encodeOrderStr];
//    NSLog(@"加密原串%@-----加密串%@",encodeOrderStr,signStr);
//    [orderDes appendFormat:@"&MAC=%@", signStr];
//    
//    // 16个业务参数
//    //1. 订单号
//    [orderDes appendFormat:@"&ORDERSEQ=%@", [_params objectForKey:@"ORDERSEQ"]];
//    //2. 订单请求流水号，唯一
//    [orderDes appendFormat:@"&ORDERREQTRNSEQ=%@", [_params objectForKey:@"ORDERREQTRNSEQ"]];
//    //3. 订单请求时间 格式：yyyyMMddHHmmss
//    [orderDes appendFormat:@"&ORDERTIME=%@", [_params objectForKey:@"ORDERREQTIME"]];
//    //4. 订单有效截至日期
//    [orderDes appendFormat:@"&ORDERVALIDITYTIME=%@", @""];
//    //5. 订单金额/积分扣减
//    [orderDes appendFormat:@"&ORDERAMOUNT=%@", self.money.text];
//    //6. 币种, 默认RMB
//    [orderDes appendFormat:@"&CURTYPE=%@", @"RMB"];
//    //7. 业务标识 optional
//    [orderDes appendFormat:@"&PRODUCTID=%@", @"04"];
//    //8. 产品描述 optional
//    [orderDes appendFormat:@"&PRODUCTDESC=%@", @"联想手机"];
//    //9. 产品金额
//    [orderDes appendFormat:@"&PRODUCTAMOUNT=%@", self.money.text];
//    //10. 附加金额 单位元，小数点后2位
//    [orderDes appendFormat:@"&ATTACHAMOUNT=%@",@"0.00"];
//    //11. 附加信息 optional
//    [orderDes appendFormat:@"&ATTACH=%@", @"88888"];
//    //12. 分账描述 optional
//    [orderDes appendFormat:@"&DIVDETAILS=%@", @""];
//    //13. 翼支付账户号
//    [orderDes appendFormat:@"&ACCOUNTID=%@", @""];
//    //14. 客户标识 在商户系统的登录名 optional
//    [orderDes appendFormat:@"&CUSTOMERID=%@", @"gehudedengluzhanghao"];
//    //15. 用户IP 主要作为风控参数 optional
//    [orderDes appendFormat:@"&USERIP=%@", @"228.112.116.118"];
//    //16. 业务类型标识
//    [orderDes appendFormat:@"&BUSITYPE=%@", @"04"];
    return orderDes;
    
}


//***********************************  订单处理  ***************************************//

// 生产
#define releaseURL @"https://webpaywg.bestpay.com.cn/order.action"
// 准生产
#define debugURL @"http://wapchargewg.bestpay.com.cn/order.action"

// 下单处理
- (void)submitOrder
{
    NSString *orderSeq = [self getOrderTimeMS];
    NSString *orderReqTrnSeq = [NSString stringWithFormat:@"%@0001",orderSeq];
    NSString *orderTime = [self getOrderTime];
    
    
    self.receiveData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:releaseURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString* signOrigStr = [NSString stringWithFormat:@"MERCHANTID=%@&ORDERSEQ=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&KEY=%@", MERID,orderSeq,orderReqTrnSeq,orderTime, KEYSTR];
    
    
    NSLog(@"下单签名源串 singOrigStr = %@", signOrigStr);
    
    NSString *signMac = [MD5 MD5:signOrigStr];
    
    NSLog(@"下单签名 singOrigStr = %@", signMac);
    
    NSString *str = [NSString stringWithFormat:@"MERCHANTID=%@&SUBMERCHANTID=%@&ORDERSEQ=%@&ORDERAMT=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&MAC=%@&TRANSCODE=%@",
                     MERID,
                     @"",
                     orderSeq,
                     [NSString stringWithFormat:@"%.0f",[self.money.text floatValue]*100.0f],
                     orderReqTrnSeq,
                     orderTime,
                     signMac,
                     @"01"];
    NSLog(@"下单签名 str = %@", str);

    
    
    _params = [[NSMutableDictionary alloc] init];
    
    [_params setObject:orderSeq             forKey:@"ORDERSEQ"];
    [_params setObject:orderReqTrnSeq       forKey:@"ORDERREQTRNSEQ"];
    [_params setObject:orderTime            forKey:@"ORDERREQTIME"];
    
    NSLog(@"下单接口信息：%@",str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //self.receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    if([[receiveStr substringToIndex:2] isEqualToString:@"00"])
    {
        [self doOrder];
    }
    else
    {
        NSLog(@"下单失败：%@", receiveStr);
        
        [self showAlert:@"下单失败，请稍后再试！"];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求失败%@",[error localizedDescription]);
    [self showAlert:@"请求失败，请稍后再试！"];
}

- (void)showAlert:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}




@end
