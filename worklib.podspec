

Pod::Spec.new do |s|
s.name             = "worklib"
s.version          = "2.3"
s.summary          = "reusable component made by carusd. contain a bunch of tool"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
s.description      = <<-DESC
this is a common work tool group.
DESC

s.homepage         = "https://github.com/carusd/worklib"
s.license          = 'MIT'
s.author           = { "carusd" => "carusd@gmail.com" }
s.source           = { :git => "https://github.com/carusd/worklib.git", :tag => s.version.to_s }

s.platform     = :ios, '7.0'
s.requires_arc = true

s.source_files = 'lib/**/*.{h,m,mm}'
# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
