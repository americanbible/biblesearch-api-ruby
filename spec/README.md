# BibleSearch::API Tests

The built-in tests are fairly standard [minitests](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest/Unit/TestCase.html. They use the [VCR Gem](https://github.com/vcr/vcr) to fake API interaction.

1. Run `bundle install`
1. Run `rake test`

For development document #TODO:

1. `rake focus` and `rake test TEST=<filename>`
1. `xdescribe`
1. `BIBLESEARCH_API_KEY` plus delete cassettes to re-record.

