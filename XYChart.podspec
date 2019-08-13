Pod::Spec.new do |s|
	s.name = "XYChart"
	s.version = '0.0.1'

	s.source = { 
		:git => "https://github.com/ZhipingYang/#{s.name}.git", 
		:tag => s.version.to_s 
	}

	s.summary = 'The line and bar of chart'
	s.description = 'XYChart is designed for line & bar of charts which can compare mutiple datas in form styles, and limited the range of values to show, and so on.'
	s.homepage = "https://github.com/ZhipingYang/#{s.name}"
	s.license = 'MIT'
	s.authors = { 'ZhipingYang' => 'XcodeYang@gmail.com' }
	s.platform = :ios, '8.0'
	s.requires_arc = true
	s.frameworks = 'UIKit'

	s.source_files = [
		"XYChart/**/*.{h,m}",
	]
end
