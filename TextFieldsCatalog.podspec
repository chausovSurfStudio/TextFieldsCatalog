Pod::Spec.new do |s|

  s.name = "TextFieldsCatalog"
  s.version = "0.0.1"
  s.summary = "This is catalog of various input field with great opportunities for validation and formatting."
  s.homepage = "https://github.com/chausovSurfStudio/TextFieldsCatalog"
  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "Alexander Chausov" => "chausov@surfstudio.ru" }
  s.ios.deployment_target = "10.0"
  s.swift_version = '4.2'

  s.source = { :git => "https://github.com/chausovSurfStudio/TextFieldsCatalog.git", :tag => "#{s.version}" }
  s.source_files = 'TextFieldsCatalog/**/*.{swift,xib,xcassets,strings}'


  s.framework  = "UIKit"
  s.dependency "InputMask", '4.0.2'

end