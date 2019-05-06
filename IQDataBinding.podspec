#
#  Be sure to run `pod spec lint IQDataBinding.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "IQDataBinding"
  spec.version      = "0.0.1"
  spec.summary      = "iOS端View和ViewModel数据绑定框架。基于KVO监听所绑定ViewModel的属性，支持链式调用。"
  spec.description  = <<-DESC
A solution for decoupling modules in iOS platform.
                   DESC
  spec.homepage     = "https://github.com/Lobster-King/IQDataBinding"
  spec.license      = "MIT"
  spec.author             = { "Lobster-King" => "zhiwei.geek@gmail.com" }
  spec.ios.deployment_target = '7.0'
  spec.source       = { :git => "https://github.com/Lobster-King/IQDataBinding.git", :tag => "#{spec.version}" }
  spec.source_files  = "IQDataBinding", "IQDataBinding/**/*.{h,m}"
  spec.exclude_files = "IQDataBinding/Exclude"

end
