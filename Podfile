project 'ART.xcodeproj'

# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

def shared_pods
    pod 'Firebase/Auth'
    pod 'Firebase/Firestore'
    pod 'Firebase/Storage'
    pod 'IQKeyboardManagerSwift'
    pod 'CodableFirebase'
    pod 'Kingfisher', '~> 4.0'
end

target 'ART' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ART
  shared_pods
  pod 'Stripe'
end

target 'ARTAdmin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ARTAdmin
  shared_pods
end
