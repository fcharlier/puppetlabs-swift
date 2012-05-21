require 'spec_helper'

describe 'swift::proxy::authtoken' do

  let :facts do
    {
      :concat_basedir => '/var/lib/puppet/concat',
    }
  end

  let :pre_condition do
    '
      include concat::setup
      concat { "/etc/swift/proxy-server.conf": }
    '
  end

  it { should contain_keystone__client__authtoken('/etc/swift/proxy-server.conf') }

end
