require 'spec_helper'

describe 'storm::nimbus' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        describe "storm nimbus with default settings on #{osfamily}" do
          let(:params) {{ }}

          it { should contain_class('storm::nimbus') }

          it { should contain_supervisor__service('storm-nimbus').with({
            'ensure'      => 'present',
            'enable'      => true,
            'command'     => '/opt/storm/bin/storm nimbus',
            'directory'   => '/',
            'environment' => ',',
            'user'        => 'storm',
            'group'       => 'storm',
            'autorestart' => true,
            'startsecs'   => 10,
            'retries'     => 999,
            'stopsignal'  => 'KILL',
            'stdout_logfile_maxsize' => '20MB',
            'stdout_logfile_keep'    => 5,
            'stderr_logfile_maxsize' => '20MB',
            'stderr_logfile_keep'    => 10,
            'require'     => [ 'Class[Storm::Config]', 'Class[Supervisor]' ],
          })}
        end

        describe "storm nimbus with custom environment on #{osfamily}" do
          let(:params) {{
            :service_environment => 'FOOVAR=BARVALUE,hello=world',
          }}

          it { should contain_supervisor__service('storm-nimbus').with({
            'environment' => 'FOOVAR=BARVALUE,hello=world,',
          })}
        end

      end
    end
  end
end
