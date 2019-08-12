Pod::Spec.new do |s|
	s.name         	= 'XYChart'
	s.summary      	= 'The line and bar of chart'
	s.description	= <<-DESC
	XYChart is designed for line & bar of charts which can compare mutiple datas in form styles, and limited the range of values to show, and so on.
	                       DESC
	s.version      	= '0.0.2'
	s.homepage     	= "https://github.com/ZhipingYang/XYChart"
	s.license      	= 'MIT'
	s.authors      	= { 'ZhipingYang' => 'XcodeYang@gmail.com' }
	s.platform     	= :ios, '8.0'
	s.source       	= { :git => 'https://github.com/ZhipingYang/XYChart.git', :tag => s.version.to_s }
	s.requires_arc 	= true
	s.frameworks	= 'UIKit'

	s.source_files 	= [
		"XYChart/**/*.{h,m}",
	]
	
end
