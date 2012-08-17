require 'eventmachine'
require 'sigar'
require 'json'

module Mote

  module Sensor

    class Mem
      def execute
        sigar = Sigar.new
        {
          'timestamp' => Time.now,
          'sensor'    => 'mem',
          'values'    => {
            'total' => sigar.mem.total,
            'used'  => sigar.mem.used,
            'free'  => sigar.mem.free
          }
        }
      end
    end

    class Load
      def execute
        sigar = Sigar.new
        {
          'timestamp' => Time.now,
          'sensor'    => 'load',
          'values'    => {
            '1 minute'   => sigar.loadavg[0],
            '5 minutes'  => sigar.loadavg[1],
            '15 minutes' => sigar.loadavg[2],
          }
        }
      end
    end
  end

  module Output

    class Buffer
      attr_reader :events

      def initialize
        @events = []
      end

      def handle_event(event)
        @events << event
      end
    end

    class Stdout
      def handle_event(event)
        $stdout << event.to_json << "\n"
      end
    end

  end

  class Agent
    attr_reader :sensors, :outputs

    def initialize(config)
      @period = 1

      @sensors = []
      (config['sensors'] || []).each do |sensor_spec|
        sensor_class = Mote::Sensor.const_get(sensor_spec)
        @sensors << sensor_class.new
      end

      @outputs = []
      (config['outputs'] || []).each do |output_spec|
        output_class = Mote::Output.const_get(output_spec)
        @outputs << output_class.new
      end
    end

    def run
      block = proc do
        execute_sensors
        EM.add_timer(@period, &block)
      end
      block.call
    end

    private

    def execute_sensors
      @sensors.each do |sensor|
        event = sensor.execute
        @outputs.each do |output|
          output.handle_event(event)
        end
      end
    end
  end
end
