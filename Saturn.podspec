
Pod::Spec.new do |s|
s.name             = 'Saturn'
s.version          = '0.1.0'
s.summary          = 'Saturn provides a mechanism for time synchronization.'

s.description      = <<-DESC
Saturn is a library with convenient API which provides a mechanism of time and date sinchronization in your app with some remote server. With Saturn its possible to get real time and date even if user will change them on his device.
DESC

s.homepage         = 'https://github.com/iaagg/Saturn'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Aleksey Getman' => 'getmanag@gmail.com' }
s.source           = { :git => 'https://github.com/iaagg/Saturn.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'Saturn/Classes/**/*'

end
