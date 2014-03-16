require 'spec_helper'

describe 'storm' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

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
