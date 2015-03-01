source 'https://rubygems.org'

gemspec

group :test do
  gem 'rom', github: 'rom-rb/rom', branch: 'master'
  gem 'inflecto'
  gem 'rspec', '~> 3.1'
  gem 'codeclimate-test-reporter', require: false
  gem 'sqlite3', platforms: [:mri, :rbx]
  gem 'jdbc-sqlite3', platforms: :jruby
end

group :tools do
  gem 'guard'
  gem 'byebug', platforms: [:mri]
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop', '~> 0.28'
end
