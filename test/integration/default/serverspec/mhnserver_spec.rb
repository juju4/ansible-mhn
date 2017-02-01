require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

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

describe command("cd /var/_mhn/mhn/server/ && /var/_mhn/mhn/env/bin/python -c 'import mhn'") do
  its(:exit_status) { should eq 0 }
end

describe file('/var/log/mhn/mnemosyne.log') do
  its(:content) { should_not match /error/ }
end
describe file('/var/log/mhn/mhn-celery-worker.log') do
  its(:content) { should_not match /error/ }
end

