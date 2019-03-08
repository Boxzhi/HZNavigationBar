#
#  Be sure to run `pod spec lint HZNavigationBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HZNavigationBar"
  s.version      = "1.0.0"
  s.summary      = "A Library for iOS to use for HZNavigationBar."
  s.description  = <<-DESC
       一个可高度自定义的NavigationBar的swift库，自定义程度高
                   DESC
  s.homepage     = "https://github.com/CoderZZHe/HZNavigationBar"
  s.license      = "MIT"
  s.author       = { "hezhizhi" => "coderhzz@163.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/CoderZZHe/HZNavigationBar", :tag => s.version }
  # s.public_header_files = "./*.h"
  s.source_files = "HZNavigationBar_Example/HZNavigationBar/*.swift"
  s.framework    = "UIKit"
  s.requires_arc = true

end
