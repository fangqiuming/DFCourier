Pod::Spec.new do |s|  
  s.name         = "DFCourier"
  s.version      = "1.0.0"
  s.summary      = "A message sending proxy switcher."
  s.homepage     = "https://bitbucket.org/fangqiuming/dfcourier"
  s.license      = { :type => "MIT", :file => 'LICENSE.md' }
  s.author       = { "fangqiuming" => "fangqiuming@outlook.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://bitbucket.org/fangqiuming/dfcourier.git", :tag => s.version}
  s.frameworks   = 'Foundation'
  s.source_files = "DFCourier/**/*.{h,m}"
  s.requires_arc = true
end  