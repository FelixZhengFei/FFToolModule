                                      	FFToolModule 使用指南
安装:

    pod 'FFToolModule’, '~> 0.0.9’ 找到最新版本
    pod ‘FFToolModule’


1,xib协议
    
    专门用来加载xib 的通用协议 FFLoadXibProtocol 
    使用：
    遵守 ‘FFLoadXibProtocol’协议
    如：
  	 class HomePageInLoginBottomView: UIView,FFLoadXibProtocol {
 	  }
    
 	  let view = HomePageInLoginBottomView.ff_LoadXib()

2,本地通知

    FFLocalNotification_Plugin
    使用：
    FFLocalNotification_PluginaddNotification(“测试")

3,错误弹框

     showWrongActivity
     使用：
     self.showWrongActivity("错误", isHide: true)

4,类别 

    
     UISearchBar 
     UIScreen 如UIScreen.cz_screenWidth()
     UILabel
     UIImage(添加文字水印,比率缩放,生成二维码图片,不透明图象,圆角)
     UIColor  如UIColor.rgb(1,1,1)
     UIButton
     UIBarButtonItem
     String  (手机号码验证,邮编号码的验证,邮箱验证,计算文本的汉字数,计数文本所需的高度,追加文档路径)
     CGFloat,Int,Double(金额格式化,大数字格式化)
     Dictionary(字典转换字符串)
     Date
5,FFAlert弹框

     oc版
       Alert 使用方法
          [FFAlert alert].cofing.XXXXX.XXXXX.FFShow();
      ActionSheet 使用方法
         [FFAlert actionSheet].cofing.XXXXX.XXXXX.FFShow();
         
    swift版
                let tempview:OpenPushView = OpenPushView(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
                tempview.closeBlock = {
                 FFAlert.close(completionBlock: nil)
               }

                _ =  FFAlert.alert().config
                     .ffCustomView(tempview)?
                     .ffHeaderInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))?
                     .ffShow()

6，后续功能
