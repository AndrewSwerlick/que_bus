
module QueBus
  class Bus
    def subscribers
      Subscriber.all
    end

    def publish(message, opts={})
      subs = subscribers
      opts[:event_id] ||= SecureRandom.uuid
      subs = subs.select{|s| s.topics.include?(opts[:topic]) || s.topics.map(&:to_sym).include?(:all) } if opts[:topic]

      subs.each do |sub|
        options = (opts || {}).clone
        options[:job_class] = sub.job_class
        options[:queue] = sub.subscriber_id
        queue_job(sub, message, options)
      end
    end

    def subscribe(opts={}, &block)
      options = opts
      id = opts if opts.kind_of?(String) || opts.is_a?(Symbol)
      options = {} if opts.kind_of?(String) || opts.is_a?(Symbol)

      topics = options[:topics]
      topics = [*topics]
      id = id || options[:id]

      sub_id = id || SecureRandom.uuid
      const_name = options[:class] ? options[:class].name : create_class(sub_id.to_s, block)
      subscriber = Subscriber.find_by_subscriber_id(sub_id)
      subscriber = subscriber || Subscriber.new(subscriber_id: sub_id)
      subscriber.topics = topics
      subscriber.job_class = const_name
      subscriber.save!

      create_worker(sub_id)
      sub_id
    end

    private
    def queue_job(subscriber, message, options)
      # if running in the same process, load the class to ensure sync mode works
      # if we aren't running the same process, fallback to the base Que::Job class
      klass = subscriber.job_class.constantize rescue Que::Job
      klass.enqueue(message, options)
    end

    # create a dynamic job class to recieve items from the queue
    def create_class(sub_id, run_method)
      klass = Class.new(Que::Job)
      klass.class_exec(run_method) do |run_method|
        klass.const_set "RUN", run_method
        def run(message,opts=nil)
          block = self.class.const_get("RUN")
          block.call(message) if block
        end
      end
      class_name = "Job#{sub_id.gsub("-","_")}"
      Jobs.const_set(class_name, klass)
      "QueBus::Jobs::#{class_name}"
    end

    def create_worker(sub_id)
      BusWorker.add_worker(sub_id)
    end
  end
  module Jobs

  end
end
