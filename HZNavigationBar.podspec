#
#  Be sure to run `pod spec lint HZNavigationBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name = 'HZNavigationBar'
  s.version = '1.0.6'
  s.license = 'MIT'
  s.summary = 'A very simple to use, can be completely customized navigation bar'
  s.homepage = 'https://github.com/CoderZZHe/HZNavigationBar'
  s.author = { 'HeZhizhi' => 'coderhzz@163.com' }
  s.social_media_url = 'https://www.jianshu.com/u/9767e7dda727'
  s.source = { :git => "https://github.com/CoderZZHe/HZNavigationBar", :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.source_files = 'HZNavigationBar_Example/HZNavigationBar/*.swift'
  s.framework = 'UIKit'
  s.swift_version = '4.2'

end