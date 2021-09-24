# DigitalHumani Ruby SDK

| :warning: | This gem is currently under development and not yet published nor recommended for production use |
| --------- | :----------------------------------------------------------------------------------------------- |

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
# Initialize the DigitalHumani SDK instance
dh = DigitalHumani::SDK.new do
    @api_key = $API_KEY             # your API key
    @environment = "production"     # "production" or "sandbox"
    @enterprise_id = $ENTERPRISE_ID # optional; your enterprise ID
end
```

Alternatively, you can specify and update the `enterprise_id` separately:

```ruby
digitalHumani.enterprise_id = $ENTERPRISE_ID
```

Note that when `enterprise_id` has been specified on the instance, it will be used as a default value on all below methods and therefore does not need to be provided as a parameter.

### Trees

```ruby
# Plant one or many trees
digitalHumani.plant_tree(enterprise_id: $ENTERPRISE_ID, project_id: '81818181', user: 'test@example.com', treeCount: 5)

# Get details of a single tree-planting request
digitalHumani.tree(uuid: $TREE_UUID)
```

### Enterprises

```ruby
# Get enterprise by ID
digitalHumani.enterprise(enterprise_id: $ENTERPRISE_ID)

# Get count of trees planted by date range
digitalHumani.treeCount(enterprise_id: $ENTERPRISE_ID, start: '2021-01-01', end: '2022-01-01')

# Get count of trees planted for month
digitalHumani.treeCount(enterprise_id: $ENTERPRISE_ID, month: '2021-01')

# Get count of trees planted by specific user. User string will match what's specified in `plant_tree` call
digitalHumani.treeCount(enterprise_id: $ENTERPRISE_ID, user: 'test@example.com')
```

### Projects

```ruby
# Get list of all projects
digitalHumani.projects()

# Get project by ID
digitalHumani.project(project_id: '81818181')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digitalhumani/digitalhumani-ruby-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
