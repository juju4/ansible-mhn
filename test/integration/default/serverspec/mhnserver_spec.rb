require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end


describe service('redis-server'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do  
  it { should be_enabled }
  it { should be_running }
end
describe service('redis'), :if => os[:family] == 'redhat' do  
  it { should be_enabled }
  it { should be_running }
end
describe port(6379) do
  it { should be_listening.with('tcp') }
end

describe service('nginx') do  
  it { should be_enabled }
  it { should be_running }
end
## can be 80, 443 or other depending on config
describe port(50443) do
  it { should be_listening.with('tcp') }
end

describe file('/var/_mhn') do
  it { should be_directory }
end
describe file('/var/log/mhn') do
  it { should be_directory }
end
describe file('/etc/supervisor/conf.d/mnemosyne.conf'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
end
describe file('/etc/supervisord.d/mnemosyne.ini'), :if => os[:family] == 'redhat' do
  it { should be_file }
end
describe file('/tmp/uwsgi.sock') do
  it { should be_socket }
end

describe command("cd /var/_mhn/mhn/server/ && /var/_mhn/mhn/env/bin/python -c 'import mhn'") do
  its(:exit_status) { should eq 0 }
end

