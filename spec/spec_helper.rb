require 'puppetlabs_spec_helper/module_spec_helper'
require 'hiera'

# See https://github.com/rodjek/rspec-puppet#hiera-integration
Hiera_yaml = 'spec/fixtures/hiera/hiera.yaml'

RSpec.configure do |c|
  c.before do
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(:root? => true)
  end
end
