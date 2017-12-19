require 'awesome_print'
require 'byebug'


metrics = Marshal.load(File.binread('aws.dump'))

metrics.each do |m, data|
  ap metric_name = "#{m[:id]}/#{m[:name]}"
  ap data.first[:unit]
  ap data.count {|d| d[:sample_count] < 1}
end
