#
# Be sure to run `pod lib lint FormBuilderUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FormBuilderUI'
  s.version          = '0.5.0'
  s.summary          = 'FormBuilderUI is a SwiftUI version of FormBuilder for UIKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
FormBuilderUI is a swift user interface library that allows developers
to declaratively create data entry forms for use with SwiftUI.  It includes
form validation and styling using style sheets.  It also provides the ability
for developers to preview their work as they modify their form.
                       DESC

  s.homepage         = 'https://github.com/n8glenn/FormBuilderUI-CocoaPod'
  s.screenshots     = 'https://i.ibb.co/n0PPShp/Screenshot1.png', 'https://i.ibb.co/j5dd3w1/Screenshot2.png', 'https://i.ibb.co/fNSc33w/Screenshot3.png', 'https://i.ibb.co/6nxQVGM/Screenshot4.png', 'https://i.ibb.co/gdGxXXr/Screenshot5.png', 'https://i.ibb.co/ZLgg5TN/Screenshot6.png', 'https://i.ibb.co/cvSQLmv/Screenshot7.png', 'https://i.ibb.co/1nYSFRS/Screenshot8.png', 'https://i.ibb.co/Cs2K8J5/Screenshot9.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'n8glenn' => 'n8glenn@gmail.com' }
  s.source           = { :git => 'https://github.com/n8glenn/FormBuilderUI-CocoaPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '17.6'
  s.swift_version = '4.0'
  
  s.source_files = 'Classes/**/*'
  
  s.resource_bundles = {
    'FormBuilderUI' => ['Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
