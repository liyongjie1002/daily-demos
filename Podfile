install! 'cocoapods', disable_input_output_paths: true, generate_multiple_pod_projects: true
use_frameworks!
use_modular_headers!
platform :ios, '12.0'

workspace 'SwiftDemo1.xcworkspace'

abstract_target 'SwiftDemo1' do
  
  pod 'CocoaDebug',:configurations => ['Debug']
  pod 'TTTAttributedLabel'

#  pod 'FCUUID'
  
  pod 'Booming'
  pod 'HandyJSON'
  
  pod 'SnapKit'
  
  # DEBUG
  pod 'CocoaDebug', :configurations => ['Debug']
  
  target 'SwiftDemo1' do
    project 'SwiftDemo1.xcodeproj'
  end
  
  target 'SwiftDemoKeyboard' do
    
  end
  
  
end
