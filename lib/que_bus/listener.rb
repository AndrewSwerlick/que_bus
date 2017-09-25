module QueBus
  module Listener

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        job = Class.new(Que::Job) do
          def run(*args)
            ActiveRecord::Base.transaction do
              method = self.class.parent.get_execution_method
              event_id = args[1]["event_id"] || args[1][:event_id]
              final_args = case args[0]
                when Hash
                  args[0].merge(topic: args[1]["topic"], event_id: event_id)
                else
                  [args[0], args[1]["topic"], event_id]
                end
              self.class.parent.send(method, final_args)
              destroy
            end
          end
        end
        base.const_set(:Job, job)

      end
    end

    module ClassMethods
      def has_run?(args)
        QueBus::Event.where(event_id: args[:event_id], subscriber: self.subscription_id).count > 0
      end

      def subscribe
        bus = QueBus::Bus.new
        bus.subscribe id: self.subscription_id, class: self::Job, topics: self.topics_list
      end

      def record_event_id(args)
        QueBus::Event.create(event_id: args[:event_id], subscriber: self.subscription_id)
      end

      def subscription_id
        "#{QueBus.subscription_namespace}/#{self.name}"
      end

      def topics(*topics)
        @topics = topics
      end

      def topics_list
        @topics
      end

      def exec_method(method)
        @method = method
      end

      def get_execution_method
        @method || :run
      end
    end
  end
end
