# Kortype
[![Build
Status](https://travis-ci.org/arnkorty/kortype.svg?branch=master)](https://travis-ci.org/arnkorty/kortype)     [![Code Climate](https://codeclimate.com/github/arnkorty/kortype/badges/gpa.svg)](https://codeclimate.com/github/arnkorty/kortype) [![Dependency Status](https://gemnasium.com/arnkorty/kortype.svg)](https://gemnasium.com/arnkorty/kortype) [![Test Coverage](https://codeclimate.com/github/arnkorty/kortype/badges/coverage.svg)](https://codeclimate.com/github/arnkorty/kortype/coverage)

a simple ruby type force for class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kortype'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kortype

## Usage
```ruby
class A
  include Kortype
  kortype :foo, type: Time
  kortype :bar, type: String
  kortype :num1, :num2, type: Fixnum
end
a = A.new
a.foo = '2012-1-1'
p a.foo # 2012-01-01 00:00:00 +0800
a.foo = 'fsf' # will be raise a error
a.bar = 233 #  "233"
a.num1 = '232' # 232
a.num2 = 'fsd' # 0
```

```ruby
class B
  include Kortype
  kortype :bar, type: String, default: 'bar'
  kortype :foo, type: String, default:  ->{ Time.now.to_s }
  kortype :file, type: File, parse: ->(file) { File.new file }
end
b = B.new
b.bar # 'bar'
b.foo # Time.now.to_s
b.file = 'Gemfile' # = File.new 'Gemfile'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arnkorty/kortype. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://github.com/arnkorty/kortype/graphs/contributors) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
