require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("mongod") do
  it { should be_running }
end

describe service('mongod') do  
  it { should be_enabled }
  it { should be_running }
end
describe port(27017) do
  it { should be_listening.with('tcp') }
end

describe command('cat /var/log/mongodb/mongod.log') do
  its(:stdout) { should_not match /ERROR/ }
  its(:exit_status) { should eq 0 }
end

