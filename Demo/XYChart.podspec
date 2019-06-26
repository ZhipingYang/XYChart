Pod::Spec.new do |s|
s.name         = 'XYChart'
s.summary      = 'The line and bar of chart'
s.description      = <<-DESC
XYChart is designed by Line and Bar. You can mark the range of values you want, and show the max or min values in linechart.
                       DESC
s.version      = '0.0.1'
s.homepage     = "https://github.com/ZhipingYang/XYChart"
s.license      = 'MIT'
s.authors      = { 'ZhipingYang' => 'XcodeYang@gmail.com' }
s.platform     = :ios, '8.0'
s.ios.deployment_target = '8.0'
s.source       = { :git => 'https://github.com/ZhipingYang/XYChart.git', :tag => s.version.to_s }

s.requires_arc = true

s.source_files = [
"XYChart/**/*.{h,m}",
]

s.frameworks = 'UIKit'

end
