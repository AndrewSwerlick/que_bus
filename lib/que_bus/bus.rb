
module QueBus
  class Bus
    def subscribers
      Subscriber.all
    end

    def publish(message, opts={})
      subs = subscribers
      subs = subs.select{|s| s.topics.include? opts[:topics] } if opts[:topics]

      subs.each do |sub|
        options = (opts || {}).clone
        options[:job_class] = sub.job_class
        options[:queue] = sub.subscriber_id
        queue_job(sub, message, options)
      end
    end

    def subscribe(opts={}, &block)
      options = opts
      id = opts if opts.kind_of? String
      options = {} if opts.kind_of? String

      topics = options[:topics]
      topics = [*topics]

      sub_id = id || SecureRandom.uuid
      const_name = create_class(sub_id, block)
      subscriber = Subscriber.find_by_subscriber_id(sub_id)
      subscriber = subscriber ||
        Subscriber.create(
          subscriber_id: sub_id,
          job_class: const_name,
          topics: topics
      )

      create_worker(sub_id)
      sub_id
    end

    private
    def queue_job(subscriber, message, options)
      #if running in the same process, load the class to ensure sync mode work
      #if we aren't running the same process, fallback to the base Que::Job class
      klass = subscriber.job_class.constantize rescue Que::Job
      klass.enqueue(message, options)
    end

    #create a dynamic job class to recieve items from the queue
    def create_class(sub_id, run_method)
      klass = Class.new(Que::Job)
      klass.class_exec(run_method) do |run_method|
        klass.const_set "RUN", run_method
        def run(message,opts=nil)
          block = self.class.const_get("RUN")
          block.call if block
        end
      end
      class_name = "Job#{sub_id.gsub("-","_")}"
      Jobs.const_set(class_name, klass)
      "Jobs::#{class_name}"
    end

    def create_worker(sub_id)
      BusWorker.add_worker(sub_id)
    end
  end
  module Jobs

  end
end
