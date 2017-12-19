require 'hawkular/hawkular_client'
require 'awesome_print'
require 'byebug'

# ENV['HAWKULARCLIENT_LOG_RESPONSE'] = true

client = Hawkular::Client.new(
    entrypoint: 'http://localhost:8080',
    credentials: { username: 'jdoe', password: 'password' },
    options: { tenant: 'miq' }
)

client.metrics.gauges.query.each do |m|
  ap m
end
