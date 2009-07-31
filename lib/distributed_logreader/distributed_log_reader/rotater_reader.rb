module DLogReader
  class RotaterReader < DistributedLogReader
    attr_accessor :selector, :archiver
    attr_reader :log_reader
    def initialize(filename, backupdir, worker, num_threads = 10)
      super(filename, worker, num_threads)
      self.selector = RotatingLog.new
      self.archiver = DateDir.new(backupdir)
    end
        
    def log_file
      @log_file ||= begin
        selector.file_to_process(filename)
      end
    end
    
    def post_process
      self.archiver.archive(log_file)
    end
  end
end