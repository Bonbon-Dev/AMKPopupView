#
# Be sure to run `pod lib lint AMKPopupView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMKPopupView'
  s.version          = '0.1.0'
  s.summary          = 'Summary of AMKPopupView.'
  s.description      = <<-DESC
                        A description of AMKPopupView.
                       DESC
  s.homepage         = 'https://github.com/AndyM129/AMKPopupView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andy__M' => 'andy_m129@baidu.com' }
  s.source           = { :git => 'https://github.com/AndyM129/AMKPopupView.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.jianshu.com/u/28d89b68984b'
  s.frameworks = 'UIKit'
  s.ios.deployment_target = '8.0'
  s.default_subspec = 'AMKPopupViewPriority'
  
  # 弹窗优先级相关扩展
  s.subspec 'AMKPopupViewPriority' do |priority|
      priority.source_files = 'AMKPopupView/Classes/PopupViewPriority/*.{h,m}'
      priority.dependency 'AMKPopupView/AMKPopupView'
      priority.dependency 'Aspects'
  end

  # 弹窗主类
  s.subspec 'AMKPopupView' do |popupView|
      popupView.source_files = 'AMKPopupView/Classes/PopupView/*.{h,m}'
      popupView.dependency 'Masonry'
  end
end