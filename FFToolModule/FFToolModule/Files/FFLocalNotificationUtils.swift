//
//  FFLocalNotificationUtils.swift
//  FFToolModule
//
//  Created by 郑强飞 on 16/11/17.
//  Copyright © 2016年 郑强飞. All rights reserved.
//


import UIKit

class FFLocalNotificationUtils: NSObject {
    /** 添加创建并添加本地通知 */
   public static func addNotification(messageString:String) {
        // 初始化一个通知
        let localNoti = UILocalNotification()
        
        // 通知的触发时间，例如即刻起15分钟后
        let fireDate = NSDate().addingTimeInterval(1)
        localNoti.fireDate = fireDate as Date
        // 设置时区
        localNoti.timeZone = NSTimeZone.default
        // 通知上显示的主题内容 "你有一条新消息"
        localNoti.alertBody = messageString
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //待机界面的滑动动作提示
        localNoti.alertAction = "打开应用"
        // 应用程序图标右上角显示的消息数
//        localNoti.applicationIconBadgeNumber = 0
        // 通知上绑定的其他信息，为键值对
        localNoti.userInfo = ["locationNotificationID": "1234"]
        
        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
}
