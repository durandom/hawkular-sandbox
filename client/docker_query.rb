require 'hawkular/hawkular_client'
require 'awesome_print'
require 'byebug'

# ENV['HAWKULARCLIENT_LOG_RESPONSE'] = true

client = Hawkular::Client.new(
    entrypoint: 'http://localhost:8080',
    credentials: { username: 'jdoe', password: 'password' },
    options: { tenant: 'miq2' }
)

starts = Time.parse('2017-06-30 00:00:00').to_i * 1000
ends = Time.parse('2017-07-01 00:00:00').to_i * 1000
ap client.metrics.gauges.get_data_by_tags({ems_id: 1, name: 'CPUUtilization'}, starts: starts, ends: ends, buckets: 2)
ap client.metrics.gauges.get_data_by_tags({ems_id: 1}, starts: starts, ends: ends, buckets: 2)
ap client.metrics.gauges.raw_data(['i-9e769164/CPUUtilization'], starts: starts, ends: ends, limit: 2)
