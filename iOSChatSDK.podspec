#
# Be sure to run `pod lib lint iOSChatSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSChatSDK'
  s.version          = '0.0.22'
  s.summary          = 'iOSChatSDK >> Custom Chat Integration with Sqrcle with multiple features.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
:iOSChatSDK >> Custom Chat Integration with Sqrcle with multiple features..
                       DESC

  s.homepage         = 'https://github.com/ashwanidynasas/iOSChatSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ashwani Sharma' => 's.ashwani@dynasas.com' }
  s.source           = { :git => 'https://github.com/ashwanidynasas/iOSChatSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
#  s.source_files = 'iOSChatSDK/**/*'
  s.source_files = 'iOSChatSDK/Classes/**/*'

  s.resource_bundles = {
      'iOSChatSDK' => ['iOSChatSDK/Classes/Resources/**/*.{storyboard,xib,xcassets}','iOSChatSDK/Assets/Classes/**/*','iOSChatSDK/Classes/Resources/Assets/*']
  }
  
#   s.resource_bundles = {
#     'iOSChatSDK' => ['iOSChatSDK/Assets/**/*']
#   }

#   s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
   # Add dependencies here
   #s.dependency 'CollectionViewPagingLayout'
   #s.dependency 'JGProgressHUD'
   s.dependency 'SDWebImage'
   #s.dependency 'SDWebImageSVGCoder'
   #s.dependency 'SnapKit'
   #s.dependency 'CircleMenu'
 #  s.dependency 'IQKeyboardManager'

#     s.dependency 'MatrixSDK'
#    s.dependency 'OLMKit'
# s.pod_target_xcconfig = {
#    'OTHER_CFLAGS' => '-w'
#  }
     
end
