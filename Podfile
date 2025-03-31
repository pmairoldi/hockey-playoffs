source 'https://github.com/cocoapods/specs.git'

plugin 'cocoapods-keys', project: 'HockeyPlayoffs',
                         keys: [
                           'HockeyAPIPath'
                         ]

platform :ios, '15.5'
inhibit_all_warnings!
use_frameworks!

target 'HockeyPlayoffs' do
  pod 'CocoaLumberjack', '~> 3.6'
  pod 'FMDB', '~> 2.7'
  pod 'AFNetworking', '~> 3.2'

  target 'HockeyPlayoffsTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.5'
          config.build_settings['CODE_SIGN_IDENTITY'] = ''
      end
  end
end
