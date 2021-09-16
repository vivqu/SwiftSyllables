#
# Be sure to run `pod lib lint SwiftSyllables.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftSyllables'
  s.version          = '0.1.9'
  s.summary          = 'A lightweight syllable counter written in Swift.'

  s.description      = <<-DESC
Simple syllable counter written in Swift using a combination of dictionary lookups and heuristic solution. Uses the CMU Pronunciation Dictionary which contains pronounciation transcriptions for over 100,000 words. If the word is found within the pronunciation dictionary, the first valid pronunciation is used to find the number of syllables. If the word is not found within the pronunciation dictionary, SwiftSyllables defaults to a heuristic solution. We used a straightforward implementation of Emre Aydin's heuristic syllable counting algorithm (http://eayd.in/?p=232).
                       DESC

  s.homepage         = 'https://github.com/vivqu/SwiftSyllables'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vivian Qu' => 'elizabeth.v.qu@gmail.com' }
  s.source           = { :git => 'https://github.com/vivqu/SwiftSyllables.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/vivqu'

  s.ios.deployment_target = '8.3'

  s.source_files = 'Sources/SwiftSyllables/Classes/**/*'

  s.resource_bundles = { 'CMUDict' => ['Sources/SwiftSyllables/Assets/**/cmudict'] }
  s.swift_versions = ['5.2']

end
