#
# Configure swift cache_errors.
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
# Copyright 2012 eNovance Labs licensing@enovance.com
#
class swift::proxy::catch_errors() {

  concat::fragment { 'swift_catch_errors':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/catch_errors.conf.erb'),
    order   => '24',
  }

}
