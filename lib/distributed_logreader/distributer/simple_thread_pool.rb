require 'thread'

module DLogReader
  class SimpleThreadPool
    attr_accessor :num_threads, :worker, :thread_pool, :queue
    
    def initialize(worker, num_threads)
      self.worker = worker
      self.num_threads = num_threads
      self.queue = Queue.new
      num_threads.times do 
        create_thread
      end
    end
    
    def process(line)
      self.queue << line
    end
    
protected    
    def create_thread
      Thread.new do
        loop do
          line = self.queue.pop
          self.worker.call(line)
        end
      end
    end
  end
end