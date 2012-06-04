class swift::dispersion (
  $auth_url = 'http://127.0.0.1:5000/v2.0/',
  $auth_user = 'dispersion',
  $auth_tenant = 'services',
  $auth_pass = 'dispersion_pass',
  $auth_version = '2.0',
  $swift_dir = '/etc/swift',
  $coverage = 1,
  $retries = 5,
  $concurrency = 25,
  $dump_json = 'no'
) {

  include swift::params

  file { '/etc/swift/dispersion.conf':
    ensure  => present,
    content => template('swift/dispersion.conf.erb'),
    owner   => 'swift',
    group   => 'swift',
    mode    => '0660',
    require => Package['swift'],
  }

  exec { 'swift-dispersion-populate':
    path      => '/usr/bin',
    subscribe => File['/etc/swift/dispersion.conf'],
    onlyif    => "swift -A ${auth_url} -U ${auth_user}:${auth_tenant} -K ${auth_pass} -V ${auth_version} stat",
    unless    => "swift -A ${auth_url} -U ${auth_user}:${auth_tenant} -K ${auth_pass} -V ${auth_version} list | grep -q dispersion_",
  }

}
