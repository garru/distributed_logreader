require 'thread'
require File.join(File.dirname(__FILE__), 'pandemic_processor')
require File.join(File.dirname(__FILE__), 'mutex_counter')
module DLogReader
  class SimpleForked
    attr_accessor :num_threads_per_process, :worker, :thread_pool, :queue, :processors
    def initialize(worker, num_processes = 3, num_threads_per_process = 10)
      self.worker = worker
      self.num_threads_per_process = (num_threads_per_process || 10)
      self.queue = Queue.new
      self.processors = []
      num_processes.times do |x|
        $dlog_logger.debug("Forking #{x} process")
        self.processors << create_process
      end
    end
    
    def process(line)
      self.queue << line
    end
    
    def join
      num_jobs_outstanding = self.processors.inject(0){|a,b| a + b.num_jobs}
      while(queue.size > 0 || num_jobs_outstanding > 0)
        sleep 0.1
        num_jobs_outstanding = self.processors.inject(0){|a,b| a + b.num_jobs}
        $dlog_logger.debug("Shutting down #{num_jobs_outstanding} left")
      end
    end
    
protected    
    def create_process
      processor = Processor.new(self.worker, self.num_threads_per_process)
      Thread.new do
        loop do
          line = self.queue.pop
          begin
            processor.process(line)
          rescue Exception => e
            $dlog_logger.warn("Exception in processing thread #{line} -- #{e.message}")
          end
        end
      end
      processor
    end
  end
end