#
# Be sure to run `pod lib lint SwiftRunOnce.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftRunOnce'
  s.version          = '0.1.0'
  s.summary          = 'A declarative "one-time" code utility in Swift'
  s.swift_versions   = '5'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SwiftRunOnce allows a developer to declaratively mark a block of logic as "one-time" code – code that will execute at
most once over the lifetime of another object, no matter how many times that block of logic gets invoked.  It is both
thread and reentrancy safe.
                       DESC

  s.homepage         = 'https://github.com/thumbtack/SwiftRunOnce'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'dwroth' => 'droth@thumbtack.com' }
  s.source           = { :git => 'https://github.com/thumbtack/SwiftRunOnce.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftRunOnce/Classes/**/*'
end
