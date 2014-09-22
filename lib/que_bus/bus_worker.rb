module QueBus
  class BusWorker < Que::Worker
    class << self
      @wake_interval = 5

      def add_worker(queue_name)
        workers.push(new(queue_name))
      end

      def mode=(mode)
        @mode = mode
        if mode == :async
          wrangler
        end
      end

      def wrangler
        @wrangler ||= Thread.new do
          loop do
            sleep(5)
            wake! if mode == :async
          end
        end
      end
    end
  end
end
