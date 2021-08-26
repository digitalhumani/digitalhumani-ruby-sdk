# DigitalHumani Ruby SDK

This repository hosts the DigitalHumani Ruby Gem SDK. It can be used for interacting with the DigitalHumani RaaS (Reforestation-as-a-Service) API. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'digitalhumani'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install digitalhumani

## Preparation

- Create an account on [DigitalHumani,com](https://my.digitalhumani.com/register) and grab your API key from the **Developer** menu item.
- Review the [DigitalHumani documentation](https://docs.digitalhumani.com) to familiarize yourself with the environments, requests, projects, etc

## Usage

### Configuration

```ruby
# Initialize the DigitalHumani SDK instance with:
#   - Your API key
#   - The environment (either "production" (default) or "sandbox")
#   - Your enterprise ID
digitalHumani = DigitalHumani::SDK.new(api_key: $API_KEY, enterprise_id: $ENTERPRISE_ID, environment: "production")
```

Alternatively, you can specify and update the `enterprise_id` separately:
```ruby
digitalHumani.enterprise_id = $ENTERPRISE_ID
```

Note that when `enterprise_id` has been specified on the instance, it will be used as a default value on all below methods. 

### Trees

```ruby
// Plant one or many trees
$digitalHumani->plantTree(enterprise_id: $ENTERPRISE_ID, project_id: '81818181', user: 'test@example.com', treeCount: 2);

// Get details of a single tree-planting request
$digitalHumani->tree('9f05511e-56c6-40f7-b5ca-e25567991dc1');
```

### Enterprises

```ruby
// Get Enterprise by ID
enterprise = digitalHumani->enterprise(enterprise_id: $ENTERPRISE_ID)
```

### Projects

```ruby
// Get list of all Projects
digitalHumani->projects()

// Get Project by ID
digitalHumani->project(project_id: '81818181')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digitalhumani/digitalhumani-ruby-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
