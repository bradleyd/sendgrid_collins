require "sendgrid_collins/configuration"
require "sendgrid_collins/api"
require "sendgrid_collins/version"

module SendgridCollins
  def self.configure(&block)
    config = Configuration.new(&block)
    SendgridCollins::Api.new(configuration: config)
  end
end
