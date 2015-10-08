kor-input-json
===

[![Build Status](https://travis-ci.org/ksss/kor-input-json.svg)](https://travis-ci.org/ksss/kor-input-json)

JSON input plugin for [kor](https://github.com/ksss/kor).

# Usage

```
$ cat table.json
{"foo": 100, "bar": 200}
{"bar": 500, "baz": 600}

$ kor json csv < table.json
foo,bar,baz
100,200,
,500,600

$cat table-single.json
[{"foo":100,"bar":200},{"bar":500,"baz":600}]

$ kor json --single markdown < table-single.json
| foo | bar | baz |
| --- | --- | --- |
| 100 | 200 |  |
|  | 500 | 600 |
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kor-input-json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kor-input-json

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ksss/kor-input-json. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Refs

- https://github.com/ksss/kor
