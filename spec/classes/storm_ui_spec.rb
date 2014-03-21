require 'spec_helper'

describe 'storm::ui' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      ['RedHat', 'CentOS', 'Amazon', 'Fedora'].each do |operatingsystem|
        let(:facts) {{
          :osfamily        => osfamily,
          :operatingsystem => operatingsystem,
        }}

        describe "storm ui with default settings on #{osfamily}" do
          let(:params) {{ }}

          it { should contain_class('storm::ui') }

          it { should contain_supervisor__service('storm-ui').with({
            'ensure'      => 'present',
            'enable'      => true,
            'command'     => '/opt/storm/bin/storm ui',
            'directory'   => '/',
            'environment' => ',',
            'user'        => 'storm',
            'group'       => 'storm',
            'autorestart' => true,
            'startsecs'   => 10,
            'retries'     => 999,
            'stdout_logfile_maxsize' => '20MB',
            'stdout_logfile_keep'    => 5,
            'stderr_logfile_maxsize' => '20MB',
            'stderr_logfile_keep'    => 10,
            'require'     => [ 'Class[Storm::Config]', 'Class[Supervisor]' ],
          })}
        end

        describe "storm ui with custom environment on #{osfamily}" do
          let(:params) {{
            :service_environment => 'FOOVAR=BARVALUE,hello=world',
          }}

          it { should contain_supervisor__service('storm-ui').with({
            'environment' => 'FOOVAR=BARVALUE,hello=world,',
          })}
        end

      end
    end
  end
end
