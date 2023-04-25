# Package::Audit

[![Gem Version](https://badge.fury.io/rb/package-audit.svg)](https://rubygems.org/gems/package-audit)
[![Test Status](https://github.com/tactica/package-audit/actions/workflows/test.yml/badge.svg)](https://github.com/tactica/package-audit/actions)

A useful tool for patch management and prioritization, `package-audit` produces a list of dependencies that are outdated, deprecated or have security vulnerabilities.

Here's an example of such a report:

```
========================================================================================================================
Package                  Version  Latest   Latest Date  Vulnerabilities                Risk    Risk Explanation         
========================================================================================================================
actionpack               6.0.0    7.0.4.3  2023-03-13   high(6) medium(6) unknown(2)   high    security vulnerability   
actionview               6.0.0    7.0.4.3  2023-03-13   medium(4)                      medium  security vulnerability   
activerecord             6.0.0    7.0.4.3  2023-03-13   medium(1) critical(1) high(2)  high    security vulnerability   
activestorage            6.0.0    7.0.4.3  2023-03-13   high(1) critical(1)            high    security vulnerability   
activesupport            6.0.0    7.0.4.3  2023-03-13   critical(1) unknown(2)         high    security vulnerability   
bootsnap                 1.11.1   1.16.0   2023-01-25                                  low     not at latest version    
capybara                 3.37.1   3.39.0   2023-04-03                                  low     not at latest version    
client_side_validations  20.0.2   21.0.0   2022-09-18                                  medium  behind by a major version
google-cloud-storage     1.36.2   1.44.0   2022-11-03                                  low     not at latest version    
haml-rails               2.0.1    2.1.0    2022-09-24                                  low     not at latest version    
haml_lint                0.40.0   0.45.0   2023-01-28                                  low     not at latest version    
license_finder           7.0.1    7.1.0    2022-11-28                                  low     not at latest version    
listen                   3.7.1    3.8.0    2023-01-09                                  low     not at latest version    
mysql2                   0.5.4    0.5.5    2023-01-22                                  low     not at latest version    
omniauth                 1.9.1    2.1.1    2023-01-20   high(1) critical(1)            high    security vulnerability   
omniauth-google-oauth2   0.8.2    1.1.1    2022-09-05                                  medium  behind by a major version
paper_trail              12.3.0   14.0.0   2022-11-26                                  medium  behind by a major version
postmark-rails           0.22.0   0.22.1   2022-06-29                                  low     not at latest version    
premailer-rails          1.11.1   1.12.0   2022-11-10                                  low     not at latest version    
rails                    6.0.0    7.0.4.3  2023-03-13                                  medium  behind by a major version
redis                    4.6.0    5.0.6    2023-02-10                                  medium  behind by a major version
rollbar                  3.3.0    3.4.0    2023-01-06                                  low     not at latest version    
scss_lint                0.59.0   0.60.0   2023-01-27                                  low     not at latest version    
spring                   2.1.1    4.1.1    2023-01-09                                  medium  behind by a major version
spring-watcher-listen    2.0.1    2.1.0    2022-09-23                                  low     not at latest version    
stripe                   6.0.0    8.5.0    2023-03-30                                  medium  behind by a major version

Found a total of 26 gems.
```

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

* For a list of other useful commands and their options run:

    ```bash
    bundle exec package-audit help
    ```
  
    OR

    ```bash
    bundle exec package-audit help [COMMAND]
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
