source 'https://rubygems.org'

gemspec

group :test do
  gem 'rom', github: 'rom-rb/rom', branch: 'master'
  gem 'rom-sql', github: 'rom-rb/rom-sql', branch: 'master'
  gem 'rspec', '~> 3.1'
  gem 'codeclimate-test-reporter', require: false
  gem 'sqlite3', platforms: [:mri, :rbx]
end

group :tools do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop', '~> 0.28'
end
