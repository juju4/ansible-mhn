require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("uwsgi") do
  it { should be_running }
end

describe file('/tmp/uwsgi.sock') do
  it { should be_socket }
end
