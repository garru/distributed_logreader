require File.join(File.dirname(__FILE__), 'distributer', 'simple_thread_pool')
require File.join(File.dirname(__FILE__), 'selector', 'rotating_log')
require File.join(File.dirname(__FILE__), 'archiver', 'date_dir')
require File.join(File.dirname(__FILE__), 'log_reader')

module DLogReader
  class DistributedLogReader
    attr_accessor :distributer, :filename
    attr_reader :log_reader
    def initialize(filename, worker, num_threads = 10)
      self.filename = filename
      self.distributer = SimpleThreadPool.new(worker, num_threads)
    end
    
    # selector/archiver seem to be strongly connected.  it's possible it
    # needs to be moved into LogReader
    def process
      pre_process

      $dlog_logger.info("Started #{log_file}:")
        lines_processed = 0
      @log_reader = LogReader.new(log_file) do |line|
        begin
          self.distributer.process(line)
        rescue Exception => e
          $dlog_logger.warn("Exception in processing thread #{log_file}:#{log_file.pos} -- #{line} -- #{e.message}")
        end
        lines_processed += 1
      end
      @log_reader.run
      self.distributer.join
      $dlog_logger.info("Finished #{log_file}: Processed (#{lines_processed}) lines")
      post_process
    end
    
    def log_file
      self.filename
    end
    
    #predefined hooks
    def pre_process  
    end
    
    #predefined hooks
    def post_process
    end
  end
end