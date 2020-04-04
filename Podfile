source 'https://github.com/cocoapods/specs.git'

plugin 'cocoapods-keys', project: 'HockeyPlayoffs',
                         keys: [
                           'HockeyAPIPath'
                         ]

platform :ios, '8.0'
inhibit_all_warnings!
use_frameworks!

target 'HockeyPlayoffs' do
  pod 'CocoaLumberjack', '~> 3.4'
  pod 'FMDB', '~> 2.7'
  pod 'AFNetworking', '~> 3.2'
  pod 'LSWeekView', '~> 1.0'
  pod 'CRToast', git: 'https://github.com/petester42/CRToast.git', branch: 'feature/allow-duplicates'
  pod 'SimulatorStatusMagic', '~> 2.4', configurations: ['Debug']
  pod 'Reveal-SDK', configurations: ['Debug']

  target 'HockeyPlayoffsTests' do
    inherit! :search_paths
  end
end
