require File.join(File.dirname(__FILE__), 'distributer', 'simple_thread_pool')
require File.join(File.dirname(__FILE__), 'selector', 'rotating_log')
require File.join(File.dirname(__FILE__), 'archiver', 'date_dir')
require File.join(File.dirname(__FILE__), 'log_reader')

module DLogReader
  class DistributedLogReader
    attr_accessor :selector, :distributer, :archiver, :filename
    attr_reader :log_reader
    def initialize(filename, backupdir, worker)
      self.filename = filename
      self.selector = RotatingLog.new
      self.distributer = SimpleThreadPool.new(worker)
      self.archiver = DateDir.new(backupdir)
    end
    
    def process
      log_file = selector.file_to_process(filename)
      @log_reader = LogReader.new(log_file) do |line|
        self.distributer.process(line)
      end
      @log_reader.run
      self.distributer.join
      self.archiver.backup(log_file)
    end    
  end
end