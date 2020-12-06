source 'https://rubygems.org'

gemspec

eval_gemfile "Gemfile.devtools"

group :test do
  gem 'inflecto'
  gem 'rspec', '~> 3.5'
  gem 'codeclimate-test-reporter', require: false
  gem 'sqlite3', platforms: [:mri, :rbx]
  gem 'jdbc-sqlite3', platforms: :jruby
end

group :tools do
  gem 'byebug', platforms: [:mri]
end
