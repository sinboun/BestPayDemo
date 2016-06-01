//
//  ViewController.swift
//  翼支付
//
//  Created by wenrui on 16/5/26.
//  Copyright © 2016年 wenrui. All rights reserved.
//

import UIKit


// 生产
let releaseURL="https://webpaywg.bestpay.com.cn/order.action"

// 准生产
let debugURL="http://wapchargewg.bestpay.com.cn/order.action"


let KEYSTR="A52E53D3B6FE39EF33326C297BB05AA9305E8C7042E2DD62"
let MERID="01520109014125000"
let PSWD="137293"





class ViewController: UIViewController,NSURLConnectionDataDelegate {
    
    
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func doOrder() {
        
        let orderStr:String = self.orderInfos() as String
        
        print("跳转支付页面带入信息:\(orderStr)")
        
        let order:BestpayNativeModel=BestpayNativeModel()
        order.orderInfo = orderStr
        order.launchType = .launchTypePay1;

        order.scheme="test"
        
        
        BestpaySDK.payWithOrder(order, fromViewController: self) { (resultDic) in

            print("result=\(resultDic)")
        }
        
    }
    
    func orderInfos()->NSString  {
        let orderDes:NSMutableString=NSMutableString()
        // 签名参数
        //1. 接口名称
        let service:NSString  = "mobile.securitypay.pay";
        orderDes.appendFormat("SERVICE=%@", service)
        //2. 商户号
        orderDes.appendFormat("&MERCHANTID=%@", MERID)
        //3. 商户密码 由翼支付网关平台统一分配给各接入商户
        orderDes.appendFormat("&MERCHANTPWD=%@", PSWD)
        //4. 子商户号
        orderDes.appendFormat("&SUBMERCHANTID=%@", "")
        //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
        orderDes.appendFormat("&BACKMERCHANTURL=%@", "http://127.0.0.1:8040/wapBgNotice.action")
        //6. 订单号
        orderDes.appendFormat("&ORDERSEQ=%@", params.objectForKey("ORDERSEQ") as! String)
        //7. 订单请求流水号，唯一
        orderDes.appendFormat("&ORDERREQTRANSEQ=%@", params.objectForKey("ORDERREQTRNSEQ") as! String)
        //8. 订单请求时间 格式：yyyyMMddHHmmss
        orderDes.appendFormat("&ORDERTIME=%@", params.objectForKey("ORDERREQTIME") as! String)
        //9. 订单有效截至日期
        orderDes.appendFormat("&ORDERVALIDITYTIME=%@", "")
        //10. 币种, 默认RMB
        orderDes.appendFormat("&CURTYPE=%@", "RMB")
        //11. 订单金额/积分扣减
        orderDes.appendFormat("&ORDERAMOUNT=%@", self.priceTextField.text!)
        //12.商品简称
        orderDes.appendFormat("&SUBJECT=%@", "测试")
        //13. 业务标识 optional
        orderDes.appendFormat("&PRODUCTID=%@", "04")
        //14. 产品描述 optional
        orderDes.appendFormat("&PRODUCTDESC=%@", "测试的商品数据描述")
        //15. 客户标识 在商户系统的登录名 optional
        orderDes.appendFormat("&CUSTOMERID=%@", "gehudedengluzhanghao")
        //16.切换账号标识
        orderDes.appendFormat("&SWTICHACC=%@", "")
        
        let SignStr:NSString=NSString(format: "%@&KEY=%@",orderDes,KEYSTR)
        
        //17. 签名信息 采用MD5加密
        let signStr:NSString=MD5.MD5(SignStr as String)
        
        orderDes.appendFormat("&SIGN=%@", signStr)
        
        
        
         //18. 产品金额
        orderDes.appendFormat("&PRODUCTAMOUNT=%@", self.priceTextField.text!)
        //19. 附加金额 单位元，小数点后2位
        orderDes.appendFormat("&ATTACHAMOUNT=%@","0.00")
        //20. 附加信息 optional
        orderDes.appendFormat("&ATTACH=%@", "88888")
        
         //22. 翼支付账户号
        orderDes.appendFormat("&ACCOUNTID=%@", "")
        //23. 用户IP 主要作为风控参数 optional
        orderDes.appendFormat("&USERIP=%@", "228.112.116.118")
        //24. 业务类型标识
        orderDes.appendFormat("&BUSITYPE=%@", "09")
        //25.授权令牌
        orderDes.appendFormat("&EXTERNTOKEN=%@", "NO")
        //27. 签名方式
        orderDes.appendFormat("&SIGNTYPE=%@", "MD5")
       
        
        return orderDes
        
    }
    
    
    @IBAction func payAction(sender: AnyObject) {
        
        var price:Double=0
        if let priceStr:String = priceTextField.text{
            price=NSString(string: priceStr).doubleValue
        }
        if(price<=0){
            print("===================请输入正确的价格==============");
            return
        }
        self.submitOrder(price)
        
        
    }
    
    
    
    var receiveData:NSMutableData!
    var params:NSMutableDictionary!
    
    //下单操作（这一步上线时应放在服务器端操作，服务器返回下单的数据由客服端调起翼支付支付）
    private func submitOrder(price:Double){
        
        let orderSeq:String  = String.getOrderTimeMS()
        let orderReqTrnSeq:String="\(orderSeq)0001"
        let orderTime:String=String.getOrderTime()
        
        receiveData=NSMutableData()
        
        let request:NSMutableURLRequest=NSMutableURLRequest(URL: NSURL(string: releaseURL)!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        request.HTTPMethod="POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let signOrigStr:NSString = NSString(format: "MERCHANTID=%@&ORDERSEQ=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&KEY=%@",  MERID,orderSeq,orderReqTrnSeq,orderTime, KEYSTR)
        
        print("下单签名源串 singOrigStr =\(signOrigStr)")
        
        let signMac:NSString = MD5.MD5(signOrigStr as String)
        
        print("下单签名 singOrigStr =\(signMac)")
        
        
        let str:NSString=NSString(format: "MERCHANTID=%@&SUBMERCHANTID=%@&ORDERSEQ=%@&ORDERAMT=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&MAC=%@&TRANSCODE=%@", MERID,
                                  "",
                                  orderSeq,
                                  NSString(format: "%.0f", price*100.0),
                                  orderReqTrnSeq,
                                  orderTime,
                                  signMac,
                                  "01")
         print("下单签名 str =\(str)")
        
        params=NSMutableDictionary()
        params.setObject(orderSeq, forKey: "ORDERSEQ")
        params.setObject(orderReqTrnSeq, forKey: "ORDERREQTRNSEQ")
        params.setObject(orderTime, forKey: "ORDERREQTIME")
        
        let data:NSData  = str.dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPBody=data;
        _=NSURLConnection(request: request, delegate: self)
        
        
        
    }
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
        return protectionSpace.authenticationMethod==NSURLAuthenticationMethodServerTrust
    }
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        if challenge.protectionSpace.authenticationMethod==NSURLAuthenticationMethodServerTrust {
            challenge.sender?.useCredential(NSURLCredential.init(forTrust: challenge.protectionSpace.serverTrust!), forAuthenticationChallenge: challenge)
            challenge.sender?.continueWithoutCredentialForAuthenticationChallenge(challenge)
            
        }
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.receiveData.appendData(data)
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        let receiveStr:NSString?=NSString(data: self.receiveData, encoding: NSUTF8StringEncoding)
        if receiveStr?.substringToIndex(2)=="00" {
            
            print("下单成功:\(receiveStr)")
            self.doOrder()
            
        }else{
        
            print("下单失败:\(receiveStr)")
        }
        
    }
    
    
}













extension String{
    
    //获取当前时间戳
    static func getOrderTrSeq() -> String {
        let senddate:NSDate = NSDate()
        let locationString:String=String(senddate.timeIntervalSince1970)
        return locationString
    }
    //获取当前时间毫秒级
    static func getOrderTimeMS() -> String {
        return self.dateFromFormat("YYYYMMddHHmmssSS");
    }
    
    //获取当前时间分钟级
    static func getOrderTime() -> String {
        return self.dateFromFormat("yyyyMMddHHmmss");
    }
    
    //把当前时间格式化
    static func dateFromFormat(format:String) -> String {
        let senddate:NSDate = NSDate()
        let dateformatter:NSDateFormatter=NSDateFormatter()
        dateformatter.dateFormat=format
        return dateformatter.stringFromDate(senddate)
    }
}
