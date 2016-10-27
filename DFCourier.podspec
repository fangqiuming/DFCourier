Pod::Spec.new do |s|  
  s.name         = "DFCourier"
  s.version      = "1.0.3"
  s.summary      = "A message sending proxy switcher."
  s.description  = <<-DESC
                    By implementing DFCourierDelegate protocol, there is an easy way to assign whose method signature will be used and which object the method will be forwarded to for each selector.
                    DFCourier will ask its delegate for proxy options after receiving a method call.
                   DESC
  s.homepage     = "https://bitbucket.org/fangqiuming/dfcourier"
  s.license      = { :type => "MIT", :file => 'LICENSE.md' }
  s.author       = { "fangqiuming" => "fangqiuming@outlook.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/fangqiuming/DFCourier.git", :tag => s.version}
  s.frameworks   = 'Foundation'
  s.source_files = "DFCourier/**/*.{h,m}"
  s.requires_arc = true
end  