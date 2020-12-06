# frozen_string_literal: true

source "https://rubygems.org"

gemspec

eval_gemfile "Gemfile.devtools"

group :test do
  gem "codeclimate-test-reporter", require: false
  gem "inflecto"
  gem "jdbc-sqlite3", platforms: :jruby
  gem "rspec", "~> 3.5"
  gem "sqlite3", platforms: %i[mri rbx]
end

group :tools do
  gem "byebug", platforms: [:mri]
end
