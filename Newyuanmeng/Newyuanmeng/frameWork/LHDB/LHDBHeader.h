//
//  LHDBHeader.h
//  LHDBDemo
//
//  Created by 李浩 on 16/1/9.
//  Copyright © 2016年 李浩. All rights reserved.
//

#ifndef LHDBHeader_h
#define LHDBHeader_h


/*LHDB使用很方便    只需要导入LHDBQueue头文件就行。在demo中有详细使用教程。
 网上比较流行的FMDB方法很多   但在我们实际开发中根本不需要用到这么多方法，
 LHDB只有3个方法    所有写操作只需要调用write方法，读操作 也就是查询操作有两个方法
 一个返回的数组中是字典表示查询数据   一个返回的数组中是自定义model表示查询数据。
 
 LHDB总共有4个类
 
 LHDataBaseExecute 这个类主要是执行数据库操作  所有sql操作全部在这个类中
 LHDataBaseOperation   这个类是对前面那个类的封装，所有数据库操作作为block返回  方便LHDBQueue将block加入GCD队列
 LHDBQueue 这个类就是在串行队列中执行数据库操作，所有数据库操作都要将操作加入到queue中 ，所有LHDBQueue是线程安全的
 NSObject+LHModelOperation  这个类别是对model的一些操作    里面只有两个方法  一个是将字典转成model  一个是将model转成字典
 
 
*/
#endif /* LHDBHeader_h */
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com