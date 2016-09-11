require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("redis-server") do
  it { should be_running }
end

