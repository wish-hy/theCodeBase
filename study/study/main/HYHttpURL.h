//
//  ZLHttpURL.h
//  ZhiLiao
//
//  Created by BaoWanPei on 2017/4/28.
//  Copyright © 2017年 XiaoHaiBao. All rights reserved.
//

#ifndef HYHttpURL_h
#define HYHttpURL_h



// 网络接口配置

// 测试接口     192.168.1.121    http://www.jialiaojy.com/app/index.php/
#define BaseUrl(url)  [NSString stringWithFormat:@"http://192.168.43.251:8080/hty/%@",(url)]

////正式接口
//#define BaseUrl(url)  [NSString stringWithFormat:@"http://192.168.43.251:8080/hty/%@",(url)]


// 登陆测试
#define userLogin @"user/loginUsers.do"

// 手机注册
#define register @"user/phoneReg.do"


// 修改用户信息
#define changeUserInfo @"user/updateUsers.do"

// 查看所有摄影集
#define photoLive @"picture/selectPic.do"

// 根据用户id查询所有图片
#define selectByid @"picture/getUserPic.do"

// 发表图片
#define addPic @"picture/addPic.do"

// 查看所有活动
#define allActivie @"activity/selectActivity.do"



// 图片服务器链接地址
#define imageHost @"http://p7mm0t0oh.bkt.clouddn.com"

#endif /* ZLHttpURL_h */


// 登陆
//{
//    "code": 0,
//    "msg": "success",
//    "user": {
//        "userAge": 0,
//        "userAttention": 8,
//        "userAuthentication": 0,
//        "userBirthday": "",
//        "userCollect": "",
//        "userCreateDate": "",
//        "userEmail": "",
//        "userFans": 4,
//        "userHeadimg": "224",
//        "userId": 33,
//        "userInfo": "",
//        "userIntegral": 0,
//        "userLocation": "",
//        "userName": "我是新来的",
//        "userNikename": "",
//        "userPassword": "123",
//        "userPhone": "456",
//        "userQq": "",
//        "userSex": 0,
//        "userWeixin": ""
//    }
//}


// 根据用户ID查询所有图片
//{
//    "code": 0,
//    "msg": "success",
//    "pictures": [
//                 {
//                     "activityId": 2,
//                     "pictureCheck": 0,
//                     "pictureCollect": 0,
//                     "pictureComment": 0,
//                     "pictureCreateDate": "2018-04-28 12:20:34",
//                     "pictureId": 11,
//                     "pictureInfo": "玉帝打王母",
//                     "pictureInform": 0,
//                     "pictureLikeCount": 0,
//                     "pictureName": "天王盖地虎",
//                     "picturePhoto": [
//                                      "p7mm0t0oh.bkt.clouddn.com/Fu17ZqqOhOwz90E8cmLSevu-XqWc",
//                                      "p7mm0t0oh.bkt.clouddn.com/Fv3ifoGNwdX3ZUI9Yk6sHDmE2tB6"
//                                      ],
//                     "pictureTranspond": 0,
//                     "userId": 51,
//                     "users": null
//                 }
//                 ]
//}

// 根据图片ID查询图片信息
//{
//    "Code": 0,
//    "msg": "success",
//    "pictures": {
//        "activityId": 0,
//        "pictureCheck": 0,
//        "pictureCollect": 0,
//        "pictureComment": 0,
//        "pictureCreateDate": "2018-05-11 22:34:25",
//        "pictureId": 34,
//        "pictureInfo": "12321",
//        "pictureInform": 0,
//        "pictureLikeCount": 0,
//        "pictureName": "biu",
//        "picturePhoto": [
//                         "dqw",
//                         "asddf"
//                         ],
//        "pictureTranspond": 0,
//        "userId": 51,
//        "users": null
//    }
//}



// 查询我的关注列表
//{
//    "Code": 0,
//    "msg": "success",
//    "fans": [
//             {
//                 "attentionId": 51,
//                 "faId": 24,
//                 "fansId": 33,
//                 "users": {
//                     "userAge": 0,
//                     "userAttention": 0,
//                     "userAuthentication": 0,
//                     "userBirthday": null,
//                     "userCollect": "",
//                     "userCreateDate": null,
//                     "userEmail": "",
//                     "userFans": 0,
//                     "userHeadimg": "224",
//                     "userId": 0,
//                     "userInfo": "",
//                     "userIntegral": 0,
//                     "userLocation": "",
//                     "userName": "我是新来的",
//                     "userNikename": "",
//                     "userPassword": "",
//                     "userPhone": "",
//                     "userQq": "",
//                     "userSex": 0,
//                     "userWeixin": ""
//                 }
//             },
//             {
//                 "attentionId": 51,
//                 "faId": 25,
//                 "fansId": 31,
//                 "users": {
//                     "userAge": 0,
//                     "userAttention": 0,
//                     "userAuthentication": 0,
//                     "userBirthday": null,
//                     "userCollect": "",
//                     "userCreateDate": null,
//                     "userEmail": "",
//                     "userFans": 0,
//                     "userHeadimg": "头像1",
//                     "userId": 0,
//                     "userInfo": "",
//                     "userIntegral": 0,
//                     "userLocation": "",
//                     "userName": "zs",
//                     "userNikename": "",
//                     "userPassword": "",
//                     "userPhone": "",
//                     "userQq": "",
//                     "userSex": 0,
//                     "userWeixin": ""
//                 }
//             }
//             ]
//}

// 查询我的粉丝
//{
//    "Code": 0,
//    "msg": "success",
//    "fans": [
//             {
//                 "attentionId": 11,
//                 "faId": 31,
//                 "fansId": 51,
//                 "users": null
//             },
//             {
//                 "attentionId": 24,
//                 "faId": 32,
//                 "fansId": 51,
//                 "users": null
//             },
//             {
//                 "attentionId": 66,
//                 "faId": 33,
//                 "fansId": 51,
//                 "users": null
//             }
//             ]
//}

// 查看评论
//{
//    "Code": 0,
//    "msg": "success",
//    "commentList": [
//                    {
//                        "commentCheck": 0,
//                        "commentContent": "自己评论自己",
//                        "commentCreateDate": "",
//                        "commentId": 11,
//                        "commentTargetId": 51,
//                        "pictureId": 35,
//                        "userId": 51,
//                        "users": {
//                            "userAge": 0,
//                            "userAttention": 0,
//                            "userAuthentication": 0,
//                            "userBirthday": "",
//                            "userCollect": "",
//                            "userCreateDate": "",
//                            "userEmail": "",
//                            "userFans": 0,
//                            "userHeadimg": "fqwdwqd",
//                            "userId": 51,
//                            "userInfo": "",
//                            "userIntegral": 0,
//                            "userLocation": "",
//                            "userName": "hahaha",
//                            "userNikename": "",
//                            "userPassword": "",
//                            "userPhone": "",
//                            "userQq": "",
//                            "userSex": 0,
//                            "userWeixin": ""
//                        }
//                    }
//                    ]
//}


// 查询活动中的图片数据
//{
//    "Code": 0,
//    "msg": "success",
//    "pictures": [
//                 {
//                     "activityId": 1,
//                     "pictureCheck": 1,
//                     "pictureCollect": 0,
//                     "pictureComment": 0,
//                     "pictureCreateDate": "2018-04-02 13:22:30",
//                     "pictureId": 2,
//                     "pictureInfo": "",
//                     "pictureInform": 0,
//                     "pictureLikeCount": 0,
//                     "pictureName": "412",
//                     "picturePhoto": "",
//                     "pictureTranspond": 0,
//                     "userId": 12,
//                     "users": null
//                 },
//                 {
//                     "activityId": 1,
//                     "pictureCheck": 0,
//                     "pictureCollect": 0,
//                     "pictureComment": 0,
//                     "pictureCreateDate": "2018-04-24 16:53:30",
//                     "pictureId": 13,
//                     "pictureInfo": "第一次添加的图片",
//                     "pictureInform": 0,
//                     "pictureLikeCount": 0,
//                     "pictureName": "新纪元",
//                     "picturePhoto": "",
//                     "pictureTranspond": 0,
//                     "userId": 24,
//                     "users": null
//                 }
//                 ]
//}

// 查询所有活动
//{
//    "activity": [
//                 {
//                     "activityAward": "",
//                     "activityCheck": 0,
//                     "activityEndDate": null,
//                     "activityId": 1,
//                     "activityInfo": "去岘山采风",
//                     "activityName": "最新活动",
//                     "activityPublictyDate": null,
//                     "activitySponsor": "",
//                     "activityStartDate": null
//                 },
//                 {
//                     "activityAward": "",
//                     "activityCheck": 0,
//                     "activityEndDate": null,
//                     "activityId": 2,
//                     "activityInfo": "校内风光摄影采集",
//                     "activityName": "第二次活动",
//                     "activityPublictyDate": null,
//                     "activitySponsor": "",
//                     "activityStartDate": null
//                 }
//                 ]
//}

