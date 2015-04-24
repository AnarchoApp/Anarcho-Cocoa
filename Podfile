source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

use_frameworks!

inhibit_all_warnings!

pod 'Alamofire', '~> 1.2'
pod 'JsonSwiftson'
pod 'PromiseKit/Swift'

post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
