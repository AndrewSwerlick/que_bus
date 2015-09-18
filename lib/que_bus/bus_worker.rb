module QueBus
  class BusWorker < Que::Worker
    @wake_interval = 5

    class << self
      def add_worker(queue_name)
        workers.push(new(queue_name))
      end

      def mode=(mode)
        @mode = mode
        if mode == :async
          wrangler
        end
      end

      def wake!
        wake_all!
      end
    end
  end
end
