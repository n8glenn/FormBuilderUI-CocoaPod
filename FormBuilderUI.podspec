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
  s.screenshots     = 'https://drive.google.com/file/d/1JglUZvDeuHyYpNYDkYvcbLLssWj8qT42/view?usp=share_link', 'https://drive.google.com/file/d/1SPt3ZQgzMaOUi2j6xuOU51_21gxFMlYY/view?usp=share_link', 'https://drive.google.com/file/d/1tTkj00XB_da03rG7DSCD_GgWmGlRmQ9T/view?usp=share_link', 'https://drive.google.com/file/d/1sXpS3CALxxyiHvu-aI8w8hQzVrvMgukm/view?usp=share_link', 'https://drive.google.com/file/d/1t8Zc2i5WCjOJrEfPhHYbyZIkbKCmsFzw/view?usp=share_link', 'https://drive.google.com/file/d/1tXgitpf0_5hE2qcZuC8DlkistBX7fkCI/view?usp=share_link', 'https://drive.google.com/file/d/1gvG4jVHzdCqXJp2VekmdT-T2v7_ToFBE/view?usp=share_link', 'https://drive.google.com/file/d/1D54Ht4ULqqHurHQiuMyBbPjkyQHInCej/view?usp=share_link', 'https://drive.google.com/file/d/1hKFSAM833B2_N0XvpRS4Hi0VA6I1O6qr/view?usp=share_link'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'n8glenn' => 'n8glenn@gmail.com' }
  s.source           = { :git => 'https://github.com/n8glenn/FormBuilderUI-CocoaPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '17.6'

  s.source_files = 'FormBuilderUI/Classes/**/*'
  
  s.resource_bundles = {
    'FormBuilderUI' => ['FormBuilderUI/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
