# Package::Audit

A useful tool for patch management and prioritization, `package-audit` produces a list of dependencies that are outdated, deprecated or have security vulnerabilities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'package-audit', require: false
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install package-audit
```

If you are using this gem in a script, you need to require it manually:

```ruby
require 'package-audit'
```

## Usage


* To produce a report of vulnerable, deprecated and outdated packages run:

    ```bash
    bundle exec package-audit
    ```

* To show how risk is calculated for the above report run:

    ```bash
    bundle exec package-audit risk
    ```

* To produce the same report in a CSV format run:

    ```bash
    bundle exec package-audit --csv
    ```

* For a list of other commands and their options run:

    ```bash
    bundle exec package-audit --help
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tactica/package-audit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/package-audit/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Package::Audit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/package-audit/blob/main/CODE_OF_CONDUCT.md).
