# SendgridCollins

API for accessing sendgrid collins server

## Installation

Add this line to your application's Gemfile:

    gem 'sendgrid_collins'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendgrid_collins

## Usage

#### Create a connection to collins
```ruby
@collins  = SendgridCollins.configure do |config|
              config.username = 'collins'
              config.password = 'collins'
              config.host     = 'http://collins.sendgrid.net:8080'
            end
```


#### Create an asset
* Intake is missing from this step

```ruby
@collins.asset_tag = '00:00:00:55:12:12'  # will convert mac address to asset tag
@collins.create_asset(asset_tag)
# set some attributes
@collins.set_asset_attributes(asset_tag, 'kvm_host', 'foobar.sjc1.sendgrid.net')
# run intake <--- TBD
# set asset to UNALLOCATED
@collins.set_asset_status(asset_tag)
# provision asset
@collins.provision_asset(asset_tag)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
