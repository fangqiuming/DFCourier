Pod::Spec.new do |s|  
  s.name         = "DFCourier"
  s.version      = "2.0.0"
  s.summary      = "Subclass of NSProxy that forwards messages complies with rule tables."
  s.description  = <<-DESC
                    DFCourier controls message forwarding by customized rule tables, and make it easy to compose rules by supporting method chaining and bulk editing.
                   DESC
  s.homepage     = "https://github.com/fangqiuming/DFCourier"
  s.license      = { :type => "MIT", :file => 'LICENSE.md' }
  s.author       = { "fangqiuming" => "fangqiuming@outlook.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/fangqiuming/DFCourier.git", :tag => s.version}
  s.frameworks   = 'Foundation'
  s.source_files = "DFCourier/**/*.{h,m}"
  s.requires_arc = true
end  