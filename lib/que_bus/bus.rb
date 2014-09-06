require 'securerandom'
require 'que'

module QueBus
  class Bus
    def initialize
      @subscribers = []
      @subscriber_classes = {}
    end

    def publish(channel=nil, message)
      @subscriber_classes.each do |k,v|
        v.enqueue(message)
      end
    end

    def subscribe(id=nil, channel=nil, &block)
      b = block
      sub_id = id || SecureRandom.uuid
      @subscribers << sub_id
      klass = Class.new(Que::Job)
      klass.class_exec(b) do |b|
        klass.const_set "BLOCK", b
        def run(message)
          block = self.class.const_get("BLOCK")
          block.call if block
        end
      end
      class_name = "Job#{sub_id.gsub("-","_")}"
      Jobs.const_set(class_name, klass)
      @subscriber_classes[sub_id] = "Jobs::#{class_name}".constantize
      sub_id
    end

    def subscribers
      @subscribers.clone
    end
  end
  module Jobs

  end
end
