require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("uwsgi") do
  it { should be_running }
end

