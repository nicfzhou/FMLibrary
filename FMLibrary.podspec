#
# Be sure to run `pod lib lint FMLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FMLibrary"
  s.version          = "0.1.0"
  s.summary          = "自用常用库"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        "自己开发过程中积累的常用库，自己编写，部分存在局限性"
                       DESC

  s.homepage         = "https://github.com/nicfzhou/FMLibrary.git"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "nicfzhou" => "nicfzhou@gmail.com" }
  s.source           = { :git => "https://github.com/nicfzhou/FMLibrary.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
#s.resourPeckhamce_bundles = {
#   'FMLibrary' => ['Pod/Assets/*.png']
# }


#子目录
    s.subspec 'Category' do |category|
        category.source_files = 'Pod/Classes/Category/**/*'
        category.public_header_files = 'Pod/Classes/Category/**/*.h'
        #category.resource = "Pod/Assets/MLSUIKitResource.bundle"
        category.dependency 'FMLibrary/Private'
    end

    s.subspec 'Tool' do |tool|
        tool.source_files = 'Pod/Classes/Tool/**/*'
        tool.public_header_files = 'Pod/Classes/Tool/**/*.h'
    end

    s.subspec 'UITool' do |uitool|
        uitool.source_files = 'Pod/Classes/UITool/**/*'
        uitool.public_header_files = 'Pod/Classes/UITool/**/*.h'
    end

    s.subspec 'Private' do |private|
        private.source_files = 'Pod/Classes/Private/**/*'
        private.public_header_files = 'Pod/Classes/Private/**/*.h'
    end


  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Accelerate' ,'MobileCoreServices'
  # s.dependency 'AFNetworking', '~> 2.3'
end
