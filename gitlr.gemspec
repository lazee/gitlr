# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','gitlr','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'gitlr'
  s.version = Gitlr::VERSION
  s.author = 'Jakob Vad Nielsen'
  s.email = 'jakobvadnielsen@gmail.com'
  s.homepage = 'http://www.jakobnielsen.net'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A Command Line Interface for managing and analyzing GitHub repositories within an organization.'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','gitlr.rdoc']
  s.rdoc_options << '--title' << 'gitlr' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'gitlr'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('webmock')
  s.add_runtime_dependency('gli','~> 2.12.2')
  s.add_runtime_dependency('octokit','~> 3.7.0')
  s.add_runtime_dependency('netrc','~> 0.8.0')
  s.add_runtime_dependency('term-ansicolor')
  s.add_runtime_dependency('terminal-table')
end
