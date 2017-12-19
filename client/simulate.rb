require 'hawkular/hawkular_client'
require 'awesome_print'
require 'byebug'

client = Hawkular::Client.new(
    entrypoint: 'http://localhost:8080',
    credentials: { username: 'jdoe', password: 'password' },
    options: { tenant: 'miq3' }
)



starts = Time.parse('2017-07-01 00:00:00 +0000').to_i * 1000
ends = Time.parse('2017-07-02 00:00:00 +0000').to_i * 1000

ends = Time.now.to_i * 1000
starts = Time.now.to_i * 1000 - (60 * 60 * 24 * 1000)

# create cpu usage

vms = {
    vm_01: {
        host: 'host_01',
        granularity: 15,
    },
    vm_02: {
        host: 'host_01',
        granularity: 15,
    },
    vm_03: {
        host: 'host_02',
        granularity: 60,
    }
}


vms.each do |resource_id, inventory|
  tags = {
      resource_type: 'Vm',
      resource_id: resource_id,
      host: inventory[:host]
  }
  granularity = inventory[:granularity]

  metric_name = tags.map{|k,v| "#{k}:#{v}" }.join('/')

  begin
    client.metrics.gauges.create(id: metric_name, tags: tags)
  rescue => e
    p e.message
    raise unless e.message =~ /already exists/
  end
  ap metric_name

  # add data at 1 minute interval
  metric_data = (starts..ends).step(granularity * 1000).map do |timestamp|
    {
        :timestamp => timestamp,
        :value => rand(10)
    }
  end

  client.metrics.gauges.push_data(metric_name, metric_data)
end

