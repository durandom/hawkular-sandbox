require 'hawkular/hawkular_client'

# ENV['HAWKULARCLIENT_LOG_RESPONSE'] = true

# client = Hawkular::Client.new(
#     entrypoint: 'https://metrics-openshift-infra.192.168.64.2.nip.io/hawkular/metrics',
#     # credentials: { token: 'xG20l1SAMRM2zdJPoVlAniL6ASS7qbxpxvkyq4xFg60'},
#     credentials: { token: 'LG6R_7L-LRbEICngDeaaKzchplkz_671sZAOQLQn8AM'},
#     options: { tenant: 'hawkular', :verify_ssl => OpenSSL::SSL::VERIFY_NONE}
# )
client = Hawkular::Client.new(
    entrypoint: 'http://localhost:8080/hawkular/metrics',
    credentials: { token: 'LG6R_7L-LRbEICngDeaaKzchplkz_671sZAOQLQn8AM'},
    options: { tenant: 'hawkular', :verify_ssl => OpenSSL::SSL::VERIFY_NONE}
)
is_network01_available = true
is_network02_available = false
client.metrics.push_data(availabilities: [
  { id: 'network-01', data: [{ value: is_network01_available ?  'up' : 'down' }] },
  { id: 'network-02', data: [{ value: is_network02_available ?  'up' : 'down' }] }
])
# client.metrics