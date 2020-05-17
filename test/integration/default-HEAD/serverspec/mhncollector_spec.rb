require 'serverspec'

# Required by serverspec
set :backend, :exec

## default, collector is disabled
#describe file('/var/log/mhn/mhn-collector.log') do
#  its(:content) { should match /Connecting to / }
#  its(:content) { should match /Connected to / }
#  its(:content) { should_not match /Error/ }
#end
