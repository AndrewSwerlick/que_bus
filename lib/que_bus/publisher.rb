module QueBus
  module Publisher
    def publish(topic, message)
      publisher.publish(message, topic: topic)
      messages << [topic, message]
    end

    def publisher
      @publisher ||= QueBus::Bus.new
    end

    def messages
      @message ||= []
    end
  end
end
