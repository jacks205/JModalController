#
# Be sure to run `pod lib lint JModalController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JModalController"
  s.version          = "0.0.5"
  s.summary          = "An easy way to create custom sliding modals."
  s.description      = "Easily create custom modals that allow for a customizability and personal design. Don't be confined to using UIAlertController."
  s.homepage         = "https://github.com/jacks205/JModalController"
s.screenshots        = "https://raw.githubusercontent.com/jacks205/JModalController/master/images/jmodalcontroller.gif"
  s.license          = 'MIT'
  s.author           = { "Mark Jackson" => "jacks205@mail.chapman.edu" }
  s.source           = { :git => "https://github.com/jacks205/JModalController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mjacks205'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'JModalController' => ['Pod/Assets/*.png']
  }
end
