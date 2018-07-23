
Pod::Spec.new do |s|
  s.name             = "NetworkInterceptor"
  s.version          = "0.0.1"
  s.summary          = "Logging all outgoing Network Requests"
  s.description      = <<-DESC
Features
1. View all outgoing Network Requests
2. Ability to view request even if certificate pinning is enabled
DESC
  s.homepage         = "https://github.com/depoon/NetworkInterceptor"
  s.license          = 'MIT'
  s.author           = { "depoon" => "de_poon@hotmail.com" }
  s.source           = { :git => "https://github.com/depoon/NetworkInterceptor.git", :tag => s.version.to_s }

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'NetworkInterceptor/Source/**/*'
end
