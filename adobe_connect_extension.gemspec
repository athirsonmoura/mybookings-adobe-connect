$:.push File.expand_path('../lib', __FILE__)

require 'adobe_connect_extension/version'

Gem::Specification.new do |s|
  s.name        = 'adobe_connect_extension'
  s.version     = ResourceTypesExtensions::AdobeConnectExtension::VERSION
  s.authors     = ['TODO: Your name']
  s.email       = ['TODO: Your email']
  s.homepage    = 'TODO'
  s.summary     = 'TODO: Summary of AdobeConnectExtension.'
  s.description = 'TODO: Description of AdobeConnectExtension.'
  s.license     = 'TODO'

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile"]

  s.add_dependency 'rails', '~> 4.1.4'
  s.add_dependency 'adobe_connect'
end
