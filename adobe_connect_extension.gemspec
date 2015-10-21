# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)

require 'adobe_connect_extension/version'

Gem::Specification.new do |s|
  s.name        = 'adobe_connect_extension'
  s.version     = ResourceTypesExtensions::AdobeConnectExtension::VERSION
  s.authors     = ['Jesús Manuel García Muñoz']
  s.email       = ['jesus@deliriumcoder.com']
  s.homepage    = 'http://www.deliriumcoder.com/'
  s.summary     = ''
  s.description = ''
  s.license     = ''

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile"]

  s.add_dependency 'rails', '~> 4.1.4'
  s.add_dependency 'adobe_connect'
end
