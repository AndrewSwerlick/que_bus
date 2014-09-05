require 'securerandom'

module QueBus
  class Bus
    def initialize
      @subscribers = []
    end

    def publish(channel=nil, message)

    end

    def subscribe(id=nil, channel=nil)
      sub_id = id || SecureRandom.uuid
      @subscribers << sub_id
      sub_id
    end

    def subscribers
      @subscribers.clone
    end
  end
end
