

Pod::Spec.new do |s|

  s.name         = "FFToolModule"
  s.version      = "0.0.8"
  s.summary      = " This is some summary for FFToolModule"

s.description  = <<-DESC 
                          FFToolModule 是一个用于保存一些常用工具,控件类,各类类别类的工具
                   DESC

  s.homepage     = "https://github.com/FelixZhengFei/FFToolModule"

  s.license      = "MIT"

  s.author    = "郑强飞"
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/FelixZhengFei/FFToolModule.git", :tag => "0.0.8" }
  s.source_files = "FFToolModule/FFToolModule/Files/*.{h,m,swift}"
  s.requires_arc = true

end
