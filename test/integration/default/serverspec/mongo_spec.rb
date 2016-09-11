require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("mongod") do
  it { should be_running }
end

