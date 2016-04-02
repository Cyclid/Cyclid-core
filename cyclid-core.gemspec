Gem::Specification.new do |s|
  s.name        = 'cyclid-core'
  s.version     = '0.1.0'
  s.license     = 'Apache-2.0'
  s.summary     = 'Core files for Cyclid'
  s.description = 'Core files (shared between the Client & Server) for Cyclid'
  s.authors     = ['Kristian Van Der Vliet']
  s.email       = 'vanders@liqwyd.com'
  s.files       = Dir.glob('lib/**/*') + %w(LICENSE README.md)

  s.add_runtime_dependency('rack', '~> 1.6.0')
end
