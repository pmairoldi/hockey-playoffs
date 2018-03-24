source "https://github.com/CocoaPods/Specs.git"

plugin "cocoapods-keys", {
  :project => "HockeyPlayoffs",
  :keys => [
    "HockeyAPIPath"
  ]
}

platform :ios, "8.0"
inhibit_all_warnings!
use_frameworks!

target "HockeyPlayoffs" do
  pod "CocoaLumberjack", "~> 2.0"
  pod "FMDB", "~> 2.5"
  pod "AFNetworking", "~> 2.6"
  pod "LSWeekView", "~> 1.0"
  pod "SimulatorStatusMagic", "~> 1.7", :configurations => ["Debug"]

  target "HockeyPlayoffsTests" do
    inherit! :search_paths
  end
end
