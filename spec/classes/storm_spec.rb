require 'spec_helper'

describe 'storm' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        default_configuration_file  = '/opt/storm/conf/storm.yaml'

        describe "storm class with default settings on #{osfamily}" do
          let(:params) {{ }}
          # We must mock $::operatingsystem because otherwise this test will
          # fail when you run the tests on e.g. Mac OS X.
          it { should compile.with_all_deps }

          it { should contain_class('storm::params') }
          it { should contain_class('storm::install').that_comes_before('storm::config') }
          it { should contain_class('storm::config') }

          it { should contain_package('storm').with_ensure('present') }

          it { should contain_group('storm').with({
            'ensure'     => 'present',
            'gid'        => 53001,
          })}

          it { should contain_user('storm').with({
            'ensure'     => 'present',
            'home'       => '/home/storm',
            'shell'      => '/bin/bash',
            'uid'        => 53001,
            'comment'    => 'Storm system account',
            'gid'        => 'storm',
            'managehome' => true,
          })}

          it { should contain_file('/app/storm').with({
            'ensure'       => 'directory',
            'owner'        => 'storm',
            'group'        => 'storm',
            'mode'         => '0750',
            'recurse'      => true,
            'recurselimit' => 0,
          })}

          it { should contain_file('/var/log/storm').with({
            'ensure' => 'directory',
            'owner'  => 'storm',
            'group'  => 'storm',
            'mode'   => '0755',
          })}

          it { should contain_file('/opt/storm/logs').with({
            'ensure' => 'link',
            'target' => '/var/log/storm',
          })}

          it { should contain_file(default_configuration_file).
            with({
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            }).
            with_content(/^storm\.zookeeper\.servers:\n    - zookeeper1\n$/).
            with_content(/^nimbus\.host: "nimbus1"$/).
            with_content(/^storm\.local\.dir: "\/app\/storm"$/).
            with_content(/^nimbus\.childopts: "-Xmx256m -Djava\.net\.preferIPv4Stack=true"$/).
            with_content(/^ui\.childopts: "-Xmx256m -Djava\.net\.preferIPv4Stack=true"$/).
            with_content(/^supervisor\.childopts: "-Xmx256m -Djava\.net\.preferIPv4Stack=true"$/).
            with_content(/^worker\.childopts: "-Xmx256m -Djava\.net\.preferIPv4Stack=true"$/).
            with_content(/^supervisor\.slots\.ports:\n    - 6700\n    - 6701\n$/).
            with_content(/^storm\.messaging\.transport: "backtype\.storm\.messaging\.netty\.Context"$/)
          }

          it { should contain_file('/opt/storm/logback/cluster.xml').
            with({
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0644',
            }).
            with_content(/^### This file is managed by Puppet\.$/).
            with_content(Regexp.new(Regexp.quote('<file>/var/log/storm/${logfile.name}</file>'))).
            with_content(
              Regexp.new(Regexp.quote('<fileNamePattern>/var/log/storm/${logfile.name}.%i</fileNamePattern>')
            )).
            with_content(/<file>\/var\/log\/storm\/access\.log<\/file>$/).
            with_content(/<fileNamePattern>\/var\/log\/storm\/access\.log\.%i<\/fileNamePattern>$/).
            with_content(/<file>\/var\/log\/storm\/metrics\.log<\/file>$/).
            with_content(/<fileNamePattern>\/var\/log\/storm\/metrics\.log\.%i<\/fileNamePattern>$/)
          }

        end

        describe "storm class with three ZooKeeper servers on #{osfamily}" do
          let(:params) {{
            :zookeeper_servers => ['zookeeper1', 'zkserver2', 'zkserver3'],
          }}
          it { should contain_file(default_configuration_file).
            with_content(/^storm\.zookeeper\.servers:\n    - zookeeper1\n    - zkserver2\n    - zkserver3\n$/)
          }
        end

        describe "storm class with messaging backend set to ZeroMQ on #{osfamily}" do
          let(:params) {{
            :storm_messaging_transport => 'backtype.storm.messaging.zmq',
          }}
          it { should contain_file(default_configuration_file).
            with_content(/^storm\.messaging\.transport: "backtype\.storm\.messaging\.zmq"$/)
          }
        end

        describe "storm class with disabled group management on #{osfamily}" do
          let(:params) {{
            :group_manage => false,
          }}
          it { should_not contain_group('storm') }
          it { should contain_user('storm') }
        end

        describe "storm class with disabled user management on #{osfamily}" do
          let(:params) {{
            :user_manage  => false,
          }}
          it { should contain_group('storm') }
          it { should_not contain_user('storm') }
        end

        describe "storm class with disabled user and group management on #{osfamily}" do
          let(:params) {{
            :group_manage => false,
            :user_manage  => false,
          }}
          it { should_not contain_group('storm') }
          it { should_not contain_user('storm') }
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'storm class without any parameters on Debian' do
      let(:facts) {{
        :osfamily => 'Debian',
      }}

      it { expect { should contain_package('storm') }.to raise_error(Puppet::Error,
        /The storm module is not supported on a Debian based system./) }
    end
  end
end
