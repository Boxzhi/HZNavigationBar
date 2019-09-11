Pod::Spec.new do |s|

  s.name = 'HZNavigationBar'
  s.version = '1.1.9'
  s.summary = 'A very simple to use, can be completely customized navigation bar'
  s.homepage = 'https://github.com/Boxzhi/HZNavigationBar'
  s.author = { 'HeZhizhi' => 'coderhzz@163.com' }
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.social_media_url = 'https://www.jianshu.com/u/9767e7dda727'
  s.source = { :git => "https://github.com/Boxzhi/HZNavigationBar.git", :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.source_files = 'HZNavigationBar/*.swift'
  s.framework = 'UIKit'
  s.swift_version = '5.0'

end