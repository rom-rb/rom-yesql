[gem]: https://rubygems.org/gems/rom-yesql
[travis]: https://travis-ci.org/rom-rb/rom-yesql
[gemnasium]: https://gemnasium.com/rom-rb/rom-yesql
[codeclimate]: https://codeclimate.com/github/rom-rb/rom-yesql
[inchpages]: http://inch-ci.org/github/rom-rb/rom-yesql

# ROM::Yesql

[![Gem Version](https://badge.fury.io/rb/rom-yesql.svg)][gem]
[![Build Status](https://travis-ci.org/rom-rb/rom-yesql.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/rom-rb/rom-yesql.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/rom-rb/rom-yesql/badges/gpa.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/rom-rb/rom-yesql/badges/coverage.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/rom-rb/rom-yesql.svg?branch=master)][inchpages]


Yesql-like adapter for [Ruby Object Mapper](https://github.com/rom-rb/rom).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rom-yesql'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rom-yesql

## Synopsis

``` ruby
# given sql/users.sql includes "SELECT * FROM users"

ROM.setup(:yesql, ['sqlite://path/to/your/db', path: './sql'])

class MyQueries < ROM::Relation[:yesql]
end

rom = ROM.finalize

my_queries = rom.relations[:my_queries]
my_queries.users.to_a # => gets the users
```

## License

See `LICENSE` file.
