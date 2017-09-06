

Pod::Spec.new do |s|

  s.name         = "FFToolModule"
  s.version      = "1.0.6"
  s.summary      = " This is some summary for FFToolModule"

s.description  = <<-DESC 
                          FFToolModule 是一个用于保存一些常用工具,控件类,各类类别类的工具
                   DESC

  s.homepage     = "https://github.com/FelixZhengFei/FFToolModule"

  s.license      = "MIT"

  s.author    = "郑强飞"
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/FelixZhengFei/FFToolModule.git", :tag => "1.0.6" }
  s.source_files = "FFToolModule/FFToolModule/HeaderFile/*.{h,m,swift}"

  s.subspec 'FF_Alert' do |ss|
    ss.source_files = "FFToolModule/FFToolModule/FF_Alert/*.{h,m,swift}"
  end

 s.subspec 'FF_OC_Category' do |ss|
    ss.source_files = "FFToolModule/FFToolModule/FF_OC_Category/*.{h,m,swift}"
  end

   s.subspec 'FF_Swfit_Extension' do |ss|
    ss.source_files = "FFToolModule/FFToolModule/FF_Swfit_Extension/*.{h,m,swift}"
  end

   s.subspec 'FF_Wrong_Alert' do |ss|
    ss.source_files = "FFToolModule/FFToolModule/FF_Wrong_Alert/*.{h,m,swift}"
  end
  
  s.requires_arc = true

end
