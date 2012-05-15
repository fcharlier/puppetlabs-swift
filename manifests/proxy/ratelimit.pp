#
# Configure swift ratelimit.
#
# == Dependencies
#
# == Examples
#
# == Authors
#
#   François Charlier fcharlier@ploup.net
#
# == Copyright
#
# Copyright 2012 eNovance licensing@enovance.com
#
class swift::proxy::ratelimit(
  $clock_accuracy = 1000,
  $max_sleep_time_seconds = 60,
  $log_sleep_time_seconds = 0,
  $rate_buffer_seconds = 5,
  $account_ratelimit = 0
) {

  concat::fragment { 'swift_ratelimit':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/ratelimit.conf.erb'),
    order   => '26',
  }

}
