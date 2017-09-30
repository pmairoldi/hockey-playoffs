# xcodebuild often ends with error code 65 and needs to be restarted.
# This function will re-run a command up to three times if it yeilds a 65 exit code.
def safe_sh(command)
  attempt_count = 0
  loop do
    begin
      attempt_count += 1
      sh command # Attempt command
      break      # If command was successful, break out of the loop.
    rescue => exception
      puts "Received non-zero exit code: #{Regexp.last_match(1)}"
      raise exception unless attempt_count < 2 # Ignore exit code 65
    end
  end
end

def project
  'HockeyPlayoffs.xcodeproj'
end

def configuration
  'Debug'
end

def targets
  %i[
    ios
  ]
end

def schemes
  {
    ios: 'HockeyPlayoffs-CI'
  }
end

def sdks
  {
    ios: 'iphonesimulator',
    macos: 'macosx',
    tvos: 'appletvsimulator'
  }
end

def devices
  {
    ios: "OS=#{device_os[:ios]},name=#{device_names[:ios]}",
    macos: 'arch=x86_64',
    tvos: "OS=#{device_os[:tvos]},name=#{device_names[:tvos]}"
  }
end

def device_names
  {
    ios: 'iPhone X',
    tvos: 'Apple TV 4K (at 1080p)'
  }
end

def device_os
  {
    ios: '11.0',
    tvos: '11.0'
  }
end

def open_simulator_and_sleep(platform)
  return if platform == :macos # Don't need a sleep on macOS because it runs first.
  sh "xcrun instruments -w '#{device_names[platform]} (#{device_os[platform]})' || sleep 15"
end

def xcodebuild(tasks, platform, xcprety_args: '', skip_simulator: false)
  sdk = sdks[platform]
  scheme = schemes[platform]
  destination = devices[platform]

  open_simulator_and_sleep(platform) unless skip_simulator
  safe_sh "set -o pipefail && xcodebuild -project '#{project}' -scheme '#{scheme}' -configuration '#{configuration}' -sdk #{sdk} -destination '#{destination}' #{tasks} | bundle exec xcpretty -c #{xcprety_args}"
end

desc 'Generate environment file.'
task :env, [:host] do |_, args|
  script = ['Scripts/generate-env-swift.sh', 'Env.swift']
  script.push(args[:host]) if args.key?(:host)

  safe_sh script.join(' ')
end

desc 'Build App.'
task :build do
  targets.map do |platform|
    puts "Cleaning on #{platform}."
    xcodebuild 'build', platform, skip_simulator: true
  end
end

desc 'Clean build directory.'
task :clean do
  targets.map do |platform|
    puts "Cleaning on #{platform}."
    xcodebuild 'clean', platform, skip_simulator: true
  end
end

desc 'Build, then run all tests.'
task :test do
  targets.map do |platform|
    puts "Testing on #{platform}."
    xcodebuild 'build test', platform, xcprety_args: '--test'
    next unless platform == :mac
    sh 'killall Simulator'
  end
end

desc 'Individual test tasks.'
namespace :test do
  desc 'Test on iOS.'
  task :ios do
    puts 'Testing on iOS.'
    xcodebuild 'build test', :ios, xcprety_args: '--test'
    sh 'killall Simulator'
  end

  desc 'Test on macOS.'
  task :macos do
    puts 'Testing on macOS.'
    xcodebuild 'build test', :macos, xcprety_args: '--test'
  end

  desc 'Test on tvOS.'
  task :tvos do
    puts 'Testing on tvOS.'
    xcodebuild 'build test', :tvos, xcprety_args: '--test'
    sh 'killall Simulator'
  end
end
