#
# Be sure to run `pod lib lint SKSpriteButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SKSpriteButton'
  s.version          = '0.4.0'
  s.summary          = 'Button implemented using SpriteKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This framework implements the Button widget which is very common but
missing from SpriteKit.
                       DESC

  s.homepage         = 'https://github.com/hanjoes/SKSpriteButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hanjoes' => 'hanzhou87@gmail.com' }
  s.source           = { :git => 'https://github.com/hanjoes/SKSpriteButton.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SKSpriteButton/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SKSpriteButton' => ['SKSpriteButton/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'SpriteKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
