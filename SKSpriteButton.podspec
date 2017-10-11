Pod::Spec.new do |s|
  s.name             = 'SKSpriteButton'
  s.version          = '1.0.1'
  s.summary          = 'Button implemented using SpriteKit.'

  s.description      = <<-DESC
This framework implements the obvious but missing button widget from Apple's SpriteKit.
This button widget is supposed to be easy to use, direct to the point. 
Please refer to the github page for a more detailed discription.
                       DESC

  s.homepage         = 'https://github.com/hanjoes/SKSpriteButton'
  s.screenshots      = 'https://raw.githubusercontent.com/hanjoes/SKSpriteButton/master/ios_demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hanjoes' => 'hanzhou87@gmail.com' }
  s.source           = { :git => 'https://github.com/hanjoes/SKSpriteButton.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/charshi_08'

  s.ios.deployment_target = '8.3'

  s.source_files = 'SKSpriteButton/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SKSpriteButton' => ['SKSpriteButton/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'SpriteKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
