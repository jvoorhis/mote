$:.unshift File.expand_path('../../../lib', __FILE__)

require 'eventmachine'
require 'mote/agent'

SAMPLE_CONFIG = {
  'sensors' => %w[ Mem ],
  'outputs' => %w[ Buffer ]
}

Given /^an agent$/ do
  @agent = Mote::Agent.new(SAMPLE_CONFIG)
end

When /^I run the agent$/ do
  EM.run do
    EM.add_timer(1.5) { EM.stop }
    @agent.run
  end
end

Then /^it should report data from the configured sensors$/ do
  buffer = @agent.outputs.first
  event = buffer.events.first
  event.should be_kind_of(Hash)
  event['sensor'].should == 'mem'
end

Then /^it should load the given sensors$/ do
  SAMPLE_CONFIG['sensors'].all? do |sensor_name|
    @agent.sensors.any? { |sensor| sensor.class.name.include?(sensor_name) }
  end.should be_true
end

Then /^it should load the given outputs$/ do
  SAMPLE_CONFIG['outputs'].all? do |output_name|
    @agent.outputs.any? { |output| output.class.name.include?(output_name) }
  end.should be_true
end
