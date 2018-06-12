#
# Be sure to run `pod lib lint DLCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DLCache'
  s.version          = '1.0.0'
  s.summary          = 'Get JSON APIs responses and cached on UserDefaults for use on offline situations.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Get JSON APIs responses and cached them on UserDefaults using a Hash system for the Url and POST data. You can used the cached data on offline situations in a transparent way.
                       DESC

  s.homepage         = 'https://github.com/daniel-lahoz/DLCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Lahoz' => 'daniel.lahoz@gmail.com' }
  s.source           = { :git => 'https://github.com/daniel-lahoz/DLCache.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.1'

  s.source_files = 'DLCache/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DLCache' => ['DLCache/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'SwiftHash'
end
