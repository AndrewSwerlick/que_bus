module QueBus
  class BusWorker < Que::Worker
    class << self

      def add_worker(queue_name)
        workers.push(new(queue_name))
      end

      def mode=(mode)
        @mode = mode
        @wake_interval = 5
        if mode == :async
          wrangler
        end
      end
    end
  end
end
