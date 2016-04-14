Pod::Spec.new do |s|
s.name             = "worklib"
s.version          = "2.3.2"
s.summary          = "reusable component made by carusd. contain a bunch of tool"

s.description      = <<-DESC
this is a common work tool group.
DESC

s.homepage         = "https://github.com/carusd/worklib"
s.license          = 'MIT'
s.author           = { "carusd" => "carusd@gmail.com" }
s.source           = { :git => "https://github.com/carusd/worklib.git", :tag => s.version.to_s }
s.platform     = :ios, '7.0'
s.requires_arc = true
s.resources = ['worklib/lib/Controller/*.{xib}']
s.source_files = 'worklib/lib/**/*.{h,m,mm}'

s.dependency  'ReactiveCocoa', '2.5'

end