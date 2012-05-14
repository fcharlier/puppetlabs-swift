class swift::proxy::authtoken(
  $admin_token         = undef,
  $admin_user          = undef,
  $admin_tenant_name   = undef,
  $admin_password      = undef,
  $delay_auth_decision = undef,
  $auth_host           = undef,
  $auth_port           = undef,
  $auth_protocol       = undef,
) {

  keystone::client::authtoken { '/etc/swift/proxy-server.conf':
    admin_token         => $admin_token,
    admin_user          => $admin_user,
    admin_tenant_name   => $admin_tenant_name,
    admin_password      => $admin_password,
    delay_auth_decision => $delay_auth_decision,
    auth_host           => $auth_host,
    auth_port           => $auth_port,
    auth_protocol       => $auth_protocol
  }

}
