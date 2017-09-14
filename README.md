
# 安装:
    pod ‘FFToolModule’
    
    或者找到最新版本
    
    pod 'FFToolModule’, '~> 1.0.9’ 


# 1 xib协议
    
    ## 专门用来加载xib 的通用协议 FFLoadXibProtocol 
  
  	 class HomePageInLoginBottomView: UIView,FFLoadXibProtocol {
 	  }
    
 	  let view = HomePageInLoginBottomView.ff_LoadXib()

# 2 本地通知FFLocalNotification_Plugin

      FFLocalNotification_PluginaddNotification(“测试")

# 3 错误弹框 showWrongActivity

     self.showWrongActivity("错误", isHide: true)
     
# 4 类别 
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
# 5 FFAlert弹框 模仿LEEAlert
     ## oc版

       Alert 使用方法

          [FFAlert alert].cofing.XXXXX.XXXXX.FFShow();

      ActionSheet 使用方法

         [FFAlert actionSheet].cofing.XXXXX.XXXXX.FFShow();
         

   ##  swift版

                let tempview:OpenPushView = OpenPushView(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
                tempview.closeBlock = {
                 FFAlert.close(completionBlock: nil)
                }
                _ =  FFAlert.alert().config
                     .ffCustomView(tempview)?
                     .ffHeaderInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))?
                     .ffOpenAnimationStyle(FFAnimationStyle.orientationTop)?
                     .ffShow()


# 6 TextView（placeHolder limitCount限制输入数）
      
            textView.ff_placeHolder = "我就是传说中的placehouder"
            textView.ff_limitCount = 200
            
# 7 FFSliderView 
      
        let one = TestVC()
        let two = TestVC()
        addChildViewController(one)
        addChildViewController(two)
        
        let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        let titles = ["今天", "天气", "不错"]
        let contentViews: [UIView] = [one.view, two.view]
        
        let sliderView: FFSliderView = FFSliderView(frame: frame, titles: titles, contentViews: contentViews)
        sliderView.viewChangeClosure = { index in
            print("视图切换，下标---", index)
        }
        sliderView.selectedIndex = 1 // 默认选中第2个
        view.addSubview(sliderView)
        
        ``
# 8，密码存储


        FFPassWordTool
# 9，验证码倒计时


        FFCountDownButton
        
# 10，后续功能
