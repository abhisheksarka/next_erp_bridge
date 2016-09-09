# NextErpBridge

Provides CRUD operations for all default/custom Doctypes in NextErp and provides a wrapper on top of it as well like ActiveRecord Models. Instead of communicating through the API directly you should use this gem since it provides better interfaces and cleaner implementation

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'next_erp_bridge', git: 'https://5e96429b259a95a8fe20ddb35ed89e0e983ecf08:x-oauth-basic@github.com/NestAway/next_erp_bridge.git', branch: 'master'
```

And then execute:

    $ bundle

## Usage

### Configure the gem in an initializer file as follows

```ruby
NextErpBridge.configure do | c |
  c.host = "https://erp.nestaway.com"
  c.username = "some.user@nestaway.com"
  c.password = "password"
end
```

### Register the DocTypes that you want to do CRUD on

The gem already comes with some predefined DocTypes
```ruby
NextErpBridge::Core::Doctypes.supported
```

You can add DocTypes you want to communicate with using the following
```ruby
s = NextErpBridge::Core::Doctypes.supported

# Register DocTypes
s.merge!({
  User: 'User',
  SalesInvoice: 'Sales%20Invoice'
})
# The hash key is used to generate class names within this gem
# The value is the value of the Doctype in the ERP system
```

### CRUD on any of the registered DocTypes
```ruby
user = NextErpBridge::Entity::User.create({first_name: 'Foo'})

user.update(last_name: 'Bar')

sales_invoice = NextErpBridge::Entity::SalesInvoice.find('a23252b')

sales_invoice.name = "Some Random Name"

sales_invoice.save
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/next_erp_bridge. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
