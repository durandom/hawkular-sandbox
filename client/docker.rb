require 'hawkular/hawkular_client'
require 'awesome_print'
require 'byebug'

# ENV['HAWKULARCLIENT_LOG_RESPONSE'] = true

client = Hawkular::Client.new(
    entrypoint: 'http://localhost:8080',
    credentials: { username: 'jdoe', password: 'password' },
    options: { tenant: 'miq2' }
)
# is_network01_available = true
# is_network02_available = false
# client.metrics.push_data(availabilities: [
#   { id: 'network-01', data: [{ value: is_network01_available ?  'up' : 'down' }] },
#   { id: 'network-02', data: [{ value: is_network02_available ?  'up' : 'down' }] }
# ])

metrics = Marshal.load(File.binread('aws.dump'))

metrics.each do |m, data|
  metric_name = "#{m[:id]}/#{m[:name]}"
  tags = {
      ems_ref: m[:id],
      ems_id: 1,
      name: m[:name]
  }

  begin
    client.metrics.gauges.create(id: metric_name, tags: tags)
  rescue => e
    raise unless e.message =~ /already exists/
  end

  metric_data = data.map do |data_point|
    {
        :value => data_point[:average],
        :timestamp => data_point[:timestamp].to_f * 1000,
    }
  end
  client.metrics.gauges.push_data(metric_name, metric_data)
end
