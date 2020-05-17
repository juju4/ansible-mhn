require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("mongod") do
  it { should be_running }
end

describe service('mongodb'), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  it { should be_enabled }
  it { should be_running }
end
describe service('mongod'), :if => os[:family] != 'ubuntu' || os[:release] != '18.04' do
  it { should be_enabled }
  it { should be_running }
end
describe port(27017) do
  it { should be_listening.with('tcp') }
end

describe file('/var/log/mongodb/mongod.log') do
  its(:content) { should_not match /ERROR/ }
end

