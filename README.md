# Package::Audit

[![Gem Version](https://badge.fury.io/rb/package-audit.svg)](https://rubygems.org/gems/package-audit)
[![Lint Status](https://github.com/tactica/package-audit/actions/workflows/lint.yml/badge.svg)](https://github.com/tactica/package-audit/actions/workflows/lint.yml)
[![Test Status](https://github.com/tactica/package-audit/actions/workflows/test.yml/badge.svg)](https://github.com/tactica/package-audit/actions/workflows/test.yml)
[![RBS Status](https://github.com/tactica/package-audit/actions/workflows/rbs.yml/badge.svg)](https://github.com/tactica/package-audit/actions/workflows/rbs.yml)

A useful tool for patch management and prioritization, `package-audit` produces a list of dependencies that are outdated, deprecated or have security vulnerabilities.

`Package::Audit` will automatically detect the technologies used by the project and print out an appropriate report.

Here's an example of such a report:

```
===========================================================================================================================
Package                   Version  Latest   Latest Date  Vulnerabilities       Risk    Risk Explanation                    
===========================================================================================================================
actionpack                7.0.3.1  7.0.4.3  2023-03-13   unknown(2) medium(1)  high    security vulnerability              
activerecord              7.0.3.1  7.0.4.3  2023-03-13   high(2)               high    security vulnerability              
activesupport             7.0.3.1  7.0.4.3  2023-03-13   unknown(2)            high    security vulnerability              
byebug                    11.1.3   11.1.3   2020-04-23                         medium  no updates by author in over 2 years
devise-async              1.0.0    1.0.0    2017-09-20                         medium  no updates by author in over 2 years
foundation-rails          6.6.2.0  6.6.2.0  2020-03-30                         medium  no updates by author in over 2 years
puma                      6.2.1    6.2.2    1980-01-01                         medium  no updates by author in over 2 years
rails-controller-testing  1.0.5    1.0.5    2020-06-23                         medium  no updates by author in over 2 years
rails                     7.0.3.1  7.0.4.3  2023-03-13                         low     not at latest version               
rubocop-i18n              3.0.0    3.0.0    2020-12-14                         medium  no updates by author in over 2 years
sass-rails                6.0.0    6.0.0    2019-08-16                         medium  no updates by author in over 2 years
selenium-webdriver        4.8.6    4.9.0    2023-04-21                         low     not at latest version               
serviceworker-rails       0.6.0    0.6.0    2019-07-09                         medium  no updates by author in over 2 years
turbolinks                5.2.1    5.2.1    2019-09-18                         medium  no updates by author in over 2 years

Found a total of 14 ruby gems.
3 vulnerable (7 vulnerabilities), 6 outdated, 9 deprecated.

To get more information about the ruby gem vulnerabilities run:
 > bundle exec bundle-audit check --update

==========================================================================================================================
Package                   Version  Latest   Latest Date  Vulnerabilities      Risk    Risk Explanation                    
==========================================================================================================================
@sideway/formula          3.0.0    3.0.1    2022-12-16   moderate(1)          medium  security vulnerability              
ansi-regex                4.1.0    6.0.1    2021-09-10   high(5)              high    security vulnerability              
async                     2.6.3    3.2.4    2022-06-07   high(2)              high    security vulnerability              
babel-eslint              10.1.0   10.1.0   2020-02-26                        medium  no updates by author in over 2 years
decode-uri-component      0.2.0    0.4.1    2022-12-19   high(10)             high    security vulnerability              
hermes-engine             0.7.2    0.11.0   2022-01-27   critical(2)          high    security vulnerability              
json5                     2.2.0    2.2.3    2022-12-31   high(30)             high    security vulnerability              
react-native-safari-view  2.1.0    2.1.0    2017-10-02                        medium  no updates by author in over 2 years
react-native              0.64.2   0.71.7   2023-04-19                        low     not at latest version               
react-navigation-stack    2.10.4   2.10.4   2021-03-01                        medium  no updates by author in over 2 years
react-navigation          4.4.4    4.4.4    2021-02-21                        medium  no updates by author in over 2 years
redux-axios-middleware    4.0.1    4.0.1    2019-07-10                        medium  no updates by author in over 2 years
redux-devtools-extension  2.13.9   2.13.9   2021-03-06                        medium  no updates by author in over 2 years
redux-persist             6.0.0    6.0.0    2019-09-02                        medium  no updates by author in over 2 years
shell-quote               1.6.1    1.8.1    2023-04-07   critical(3)          high    security vulnerability              
shelljs                   0.8.4    0.8.5    2022-01-07   moderate(1) high(1)  high    security vulnerability              
simple-plist              1.3.0    1.3.1    2022-03-31   critical(1)          high    security vulnerability              
urijs                     1.19.7   1.19.11  2022-04-03   high(1) moderate(4)  high    security vulnerability

Found a total of 18 node modules.
10 vulnerable (61 vulnerabilities), 11 outdated, 7 deprecated.

To get more information about the node module vulnerabilities run:
 > yarn audit
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
