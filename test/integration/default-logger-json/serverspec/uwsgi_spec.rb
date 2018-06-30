require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("uwsgi") do
  it { should be_running }
end

describe file('/tmp/uwsgi.sock') do
  it { should be_socket }
end


## if using network socket or need curl 7.40+ to request on socket file
##	https://curl.haxx.se/download.html
##	http://mirror.city-fan.org/ftp/contrib/sysutils/Mirroring/
#describe command('curl --unix-socket /tmp/uwsgi.sock http://localhost') do
#  its(:stdout) { should match /You should be redirected automatically to target URL/ }
#  its(:stdout) { should_not match /Internal Server Error/ }
#  its(:stdout) { should_not match /Empty reply from server/ }
#end
describe command('curl -v http://localhost:9999'), :if => os[:family] == 'redhat' do
  its(:stdout) { should match /You should be redirected automatically to target URL/ }
  its(:stdout) { should_not match /Internal Server Error/ }
  its(:stdout) { should_not match /Empty reply from server/ }
end

