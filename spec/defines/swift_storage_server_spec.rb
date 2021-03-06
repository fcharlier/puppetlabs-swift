require 'spec_helper'
describe 'swift::storage::server' do

  let :facts do
    {
      :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
      :processorcount  => 1,
      :concat_basedir  => '/var/lib/puppet/concat',
    }

  end

  let :pre_condition do
    "class { 'ssh::server::install': }
     class { 'swift': swift_hash_suffix => 'foo' }
     class { 'swift::storage': storage_local_net_ip => '10.0.0.1' }"
  end
  let :default_params do
    {:devices => '/srv/node',
     :owner => 'swift',
     :group  => 'swift',
     :max_connections => '25'}
  end

  describe 'with an invalid title' do
    let :params do
      {:storage_local_net_ip => '127.0.0.1',
      :type => 'object'}
    end
    let :title do
      'foo'
    end
    it 'should fail' do
      expect do
        subject
      end.should raise_error(Puppet::Error, /does not match/)
    end
  end

  ['account', 'object', 'container'].each do |t|

    describe "for type #{t}" do

      let :title do
        '8000'
      end

      let :req_params do
        {:storage_local_net_ip => '10.0.0.1', :type => t}
      end
      let :params do
        req_params
      end

      it { should contain_package("swift-#{t}").with_ensure('present') }
      it { should contain_service("swift-#{t}").with(
        :ensure    => 'running',
        :enable    => true,
        :hasstatus => true
      )}
      let :fragment_file do
        "/var/lib/puppet/concat/_etc_swift_#{t}-server_#{title}.conf/fragments/00_swift-#{t}-#{title}"
      end

      describe 'when parameters are overridden' do
        {
          :devices     => '/tmp/foo',
          :user        => 'dan',
          :mount_check => true,
          :concurrency => 5,
          :workers     => 7,
          :pipeline    => 'foo'
        }.each do |k,v|
          describe "when #{k} is set" do
            let :params do req_params.merge({k => v}) end
            it { should contain_file(fragment_file) \
              .with_content(/^#{k.to_s}\s*=\s*#{v}\s*$/)
            }
          end
          describe "when pipline is passed an array" do
            let :params do req_params.merge({:pipeline => [1,2,3]})  end
            it { should contain_file(fragment_file) \
              .with_content(/^pipeline\s*=\s*1 2 3\s*$/)
            }
          end
        end
      end

      describe 'with all allowed defaults' do
        let :params do
          req_params
        end

        it { should contain_rsync__server__module("#{t}").with(
          :path            => '/srv/node',
          :lock_file       => "/var/lock/#{t}.lock",
          :uid             => 'swift',
          :gid             => 'swift',
          :max_connections => 25,
          :read_only       => false
        )}

        # verify template lines
        it { should contain_file(fragment_file) \
          .with_content(/^devices\s*=\s*\/srv\/node\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^bind_ip\s*=\s*10\.0\.0\.1\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^bind_port\s*=\s*#{title}\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^mount_check\s*=\s*false\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^user\s*=\s*swift\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^log_facility\s*=\s*LOG_LOCAL2\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^workers\s*=\s*1\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^concurrency\s*=\s*1\s*$/)
        }
        it { should contain_file(fragment_file) \
          .with_content(/^pipeline\s*=\s*#{t}-server\s*$/)
        }
      end
    end
  end
end
