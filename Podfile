# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'yourEditorial' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for yourEditorial
  pod 'TPKeyboardAvoiding'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  pod 'Firebase/Analytics'

  # crashLytics用
  pod 'Firebase/Crashlytics'
  #script_phase  :name=> 'FirebaseCrashlytics',
  #              :script=> '"${PODS_ROOT}/FirebaseCrashlytics/run"',
  #              :input_files=> ['$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)']

  pod 'Google-Mobile-Ads-SDK'
  pod 'RealmSwift' , '~> 3.19.0'
  pod 'PKHUD', '~> 5.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if target.name.include?('Realm')
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        end
      end
    end
  end
  

  target 'yourEditorialTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'yourEditorialUITests' do
    # Pods for testing
  end

end
