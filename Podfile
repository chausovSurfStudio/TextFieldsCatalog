platform :ios, '10.0'

inhibit_all_warnings!

def utils
    pod 'SwiftGen', '5.2.1'
    pod 'SwiftLint', '0.29.4'
end

def common_pods
    utils
    pod 'InputMask', '4.0.2'
end

target 'TextFieldsCatalog' do
  use_frameworks!
  common_pods

  target 'TextFieldsCatalogTests' do
    inherit! :search_paths
    common_pods
  end

end
