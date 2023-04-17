source 'https://github.com/cocoapods/specs.git'

plugin 'cocoapods-keys', project: 'HockeyPlayoffs',
                         keys: [
                           'HockeyAPIPath'
                         ]

platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

target 'HockeyPlayoffs' do
  pod 'CocoaLumberjack', '~> 3.6'
  pod 'FMDB', '~> 2.7'
  pod 'AFNetworking', '~> 3.2'
  pod 'CRToast', git: 'https://github.com/petester42/CRToast.git', branch: 'feature/allow-duplicates'
  pod 'SimulatorStatusMagic', '~> 2.4', configurations: ['Debug']

  target 'HockeyPlayoffsTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
          config.build_settings['CODE_SIGN_IDENTITY'] = ''
      end
  end
  
  installer.pods_project.targets.each do |target|
      shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
      if File::exists?(shell_script_path)
        shell_script_input_lines = File.readlines(shell_script_path)
        shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
        File.open(shell_script_path, 'w') do |f|
          shell_script_output_lines.each do |line|
            f.write line
          end
        end
      end
    end
end
