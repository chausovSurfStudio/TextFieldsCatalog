platform :ios, '10.0'

inhibit_all_warnings!

def utils
    pod 'SwiftLint', '~> 0.29.1'
end

def common_pods
    utils
    pod 'InputMask'
end

target 'TextFieldsCatalog' do
  use_frameworks!
  common_pods

  target 'TextFieldsCatalogTests' do
    inherit! :search_paths
  end

end
