require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end


describe package('python-dev'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end  

describe service('python-devel'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('python-pip') do
  it { should be_installed }
end
describe package('python-virtualenv') do
  it { should be_installed }
end

