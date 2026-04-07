Pod::Spec.new do |spec|
  spec.name = 'XYChart'
  spec.version = '1.0.0'
  spec.summary = 'Objective-C line and bar charts with configurable range, layout, and tap interaction.'
  spec.description = <<-DESC
    XYChart is a lightweight Objective-C chart library for line and bar charts.
    It supports multi-series comparison, configurable visible ranges and levels,
    fixed or auto row widths, tap callbacks with UIMenuController, and replayable
    entry animations driven by each chart item's duration.
  DESC

  spec.homepage = 'https://github.com/ZhipingYang/XYChart'
  spec.documentation_url = 'https://github.com/ZhipingYang/XYChart#readme'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'XcodeYang' => 'xcodeyang@gmail.com' }
  spec.source = {
    :git => 'https://github.com/ZhipingYang/XYChart.git',
    :tag => spec.version.to_s
  }

  spec.ios.deployment_target = '12.0'
  spec.requires_arc = true
  spec.frameworks = 'UIKit', 'QuartzCore'
  spec.source_files = 'XYChart/**/*.{h,m}'
  spec.public_header_files = 'XYChart/**/*.h'
  spec.header_mappings_dir = 'XYChart'
  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
end
