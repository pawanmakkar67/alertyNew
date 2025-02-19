source 'https://github.com/CocoaPods/Specs'

use_frameworks!
platform :ios, '14.0'
inhibit_all_warnings!

target 'Alerty' do

  pod 'Alamofire'
  pod 'CocoaLumberjack'
  pod 'TwilioVideo'
  pod 'TwilioVoice'
  pod 'ProximiioMapbox'
  pod 'TwilioAudioProcessors'
  #  pod 'OpenCombine'
#  pod 'OpenCombineDispatch'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/DynamicLinks'
  pod 'DarwinNotificationCenter'
  pod 'Switches'
  
end

target "Opus" do
  pod 'Alamofire'
  pod 'CocoaLumberjack'
  pod 'TwilioVideo'
  pod 'TwilioVoice'
  pod 'ProximiioMapbox'
#  pod 'OpenCombine'
#  pod 'OpenCombineDispatch'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/DynamicLinks'
end

target "Sakerhetsappen" do
    pod 'Alamofire'
    pod 'CocoaLumberjack'
    pod 'TwilioVideo'
    pod 'TwilioVoice'
    pod 'ProximiioMapbox'
#    pod 'OpenCombine'
#    pod 'OpenCombineDispatch'
    pod 'Firebase/Core'
    pod 'Firebase/Crashlytics'
    pod 'Firebase/DynamicLinks'
end

post_install do |installer|
  
  installer.aggregate_targets.each do |target|
      target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
  end
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
#      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
#      config.build_settings['ENABLE_BITCODE'] = 'YES'
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
config.build_settings['SWIFT_VERSION'] = '5.3'
config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
    xcconfig_path = config.base_configuration_reference.real_path
    IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
end

    end
  end
end


