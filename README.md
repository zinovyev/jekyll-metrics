# JekyllMetrics


A Jekyll plugin to inject Google Analytics and Yandex Metrica counters into your pages


## Installation


Add this line to your application's Gemfile:

```ruby
gem 'jekyll-metrics'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-metrics


## Usage


The scripts will be automatically injected to the top of your pages as soon as the plugin is enabled:
* Above the first `<script>` in the `<head>` tag;
* Or just to the bottom of the `<head>` tag if no other scripts are loaded;

To enable the plugin, add it to the list of plugins:

```yaml
plugins:
  ...
  - jekyll-metrics
```

To make the plugin work properly, the following configuration options should be added to your `_config.yml` file:

```yaml
jekyll_metrics:
  yandex_metrica_id: 11111111,
  google_analytics_id: 22-222222222-2
```

The `11111111` should be replaced with your personal Yandex Metrica counter ID and the `22-222222222-2` - with one
from your Google Analytics account accordinately.


## Advanced configuration


Actually the plugin may be used to inject any script you like. You'll just need to replace the template of the
substitution scripts. To do so create a file (e.g. `_includes/metrics.html.liquid`) in your site directory and add an
extra parameter to the configuration section described above:

```yaml
jekyll_metrics:
  template: _includes/metrics.html.liquid
  yandex_metrica_id: 11111111,
  google_analytics_id: 22-222222222-2
```


## Development


After checking out the repo, run `rake spec` to run the tests. 


## Contributing


Bug reports and pull requests are welcome on GitHub at https://github.com/zinovyev/jekyll-metrics.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the [code of conduct](https://github.com/zinovyev/jekyll-metrics/blob/master/CODE_OF_CONDUCT.md).


## License


The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct


Everyone interacting in the JekyllMetrics project's codebases, issue trackers, chat rooms and mailing lists is
expected to follow the [code of conduct](https://github.com/[USERNAME]/jekyll-metrics/blob/master/CODE_OF_CONDUCT.md).
