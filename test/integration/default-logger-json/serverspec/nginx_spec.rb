require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

describe service('nginx') do  
  it { should be_enabled }
  it { should be_running }
end
## can be 80, 443 or other depending on config
describe port(5080) do
  it { should be_listening.with('tcp') }
end
describe port(50443) do
  it { should be_listening.with('tcp') }
end

