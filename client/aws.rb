require 'aws-sdk'
require 'awesome_print'
require 'logger'
require 'byebug'
require 'vcr'
require 'webmock'
require 'hawkular/hawkular_client'

options = {}
options[:log] = false
options[:log_set] = true
options[:debug] = false
options[:debug_set] = true
cfg = {}
cfg[:region] = options[:region] if options[:region]
if options[:log]
  logger = Logger.new($stdout)
  logger.formatter = proc {|severity, datetime, progname, msg| msg }
  cfg[:logger] = logger
end

if options[:color]
  cfg[:log_formatter] = Aws::Log::Formatter.colored
end

if options[:debug]
  cfg[:http_wire_trace] = true
end

Aws.config = cfg

ENV['AWS_REGION']='us-east-1'
ENV['AWS_ACCESS_KEY_ID']=''
ENV['AWS_SECRET_ACCESS_KEY']=''

VCR.configure do |c|
  # c.cassette_library_dir = Rails.root.join('spec/vcr_cassettes')
  c.cassette_library_dir = './'
  c.hook_into :webmock
end

store = {}
VCR.use_cassette('aws') do
  cw = Aws::CloudWatch::Resource.new
  start_time = Time.parse('2017-06-01 00:00:00 +0000')
  end_time = Time.parse('2017-06-31 00:00:00 +0000')

  metrics = cw.metrics({ namespace: 'AWS/EC2'})
  metrics.each do |m|
    ap m.name
    m.dimensions.each do |dim|
      ap dim.name
      next unless dim.name == 'InstanceId'
      ap dim.value
      st = et = start_time
      while (st < end_time)
        st = et
        et += 1440*60
        s = m.get_statistics({dimensions: [dim.to_h],
                              start_time: st,
                              end_time: et,
                              period: 60,
                              statistics: ["Maximum", "Minimum", "Average", "SampleCount", "Sum"],
                             })
        if s.datapoints.any?
          key = {id: dim.value, name: m.name}
          store[key] ||= []
          store[key].concat(s.datapoints.map &:to_h)
        end
      end
    end
  end
end

File.open('aws.dump', 'wb') {|f| f.write(Marshal.dump(store))}





