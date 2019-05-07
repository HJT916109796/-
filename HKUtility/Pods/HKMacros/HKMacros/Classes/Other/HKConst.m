//
//  HKConst.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKConst.h"

//网络状态监控地址
NSString *const kURL_Reachability__Address = @"www.baidu.com";

// 友盟
NSString *const HKUMConfigInstanceAppKey = @"58aa7d20e88bad08c1001dcd";

NSString *const HKUMConfigInstanceChannelId = @"App Store";

NSString *const HKUMSocialAppkey = @"58aa7d20e88bad08c1001dcd";

NSString *const HKUMessageStartWithAppkey = @"58aa7d20e88bad08c1001dcd";

NSString *const HKUMessageAppMasterSecret = @"ntljqfii29nachyuqpbmwl5u5yofkyk6";


// UM 微信登录
NSString *const HKWeChatAppKey = @"wxdc1e388c3822c80b";

NSString *const HKWeChatAppSecret = @"3baf1193c85774b3fd9d18447d76cab0";

NSString *const HKWeChatRedirectURL = @"http://mobile.umeng.com/social";

// UMQQ
NSString *const HKQQAppKey = @"1105821097";

NSString *const HKQQAppSecret = @"ublD75ttNYKh0zXx";

NSString *const HKQQRedirectURL = @"http://mobile.umeng.com/social";

//播放详情
NSString *const HKVIDEORESOURCE_NONE = @"来晚了哦，视频已经不见啦~";

//键盘相关
NSString *const PLACEHOLDER_PHONENUM = @"请输入11位有效手机号码";
NSString *const PLACEHOLDER_VERIFYCODE = @"验证码";
NSString *const PLACEHOLDER_INVITECODE = @"邀请码（选填）";
NSString *const PLACEHOLDER_PASSWORD = @"请输入6-16位字母或数字";
NSString *const PLACEHOLDER_RESETPASSWORD = @"重置密码";
NSString *const PLACEHOLDER_USERNICKNAME = @"填写家长昵称";
NSString *const PLACEHOLDER_BABYNICKNAME = @"填写宝宝昵称";


NSInteger const PHONENUM_TEXTFIELD_TAG      = 10001;
NSInteger const PASSWORD_TEXTFIELD_TAG      = 10002;
NSInteger const VERIFYCODE_TEXTFIELD_TAG    = 10003;
NSInteger const USERNICKNAME_TEXTFIELD_TAG  = 10004;
NSInteger const BABYNICKNAME_TEXTFIELD_TAG  = 10005;
NSInteger const REPLACE_OLDTEXTFIELD_TAG    = 10006;
NSInteger const REPLACE_NEWTEXTFIELD_TAG    = 10007;
NSInteger const INVITECODE_TEXTFIELD_TAG    = 10008;

NSInteger const kMAXPHONENUMLIMIT           = 11;
NSInteger const kMAXPASSWORDLIMIT           = 16;
NSInteger const kMAXVERIFYCODELIMIT         = 6;
NSInteger const kMAXINVITECODELIMIT         = 6;
NSInteger const kMAXUSERNICKNAMECOUNTLIMIT  = 16;
NSInteger const kMAXBABYNICKNAMECOUNTLIMIT  = 16;
