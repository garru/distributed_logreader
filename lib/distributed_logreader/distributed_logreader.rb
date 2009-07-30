module DLogReader
  class DistributedLogReader
    attr_accessor :selector, :distributer, :archiver, :filename

    def initialize(filename, backupdir, worker)
      self.filename = filename
      self.selector = RotatingLog.new
      self.distibuter = SimpleThreadPool.new(worker)
      self.archiver = DateDir.new(backupdir)
    end
    
    def process
      log_file = selector.file_to_process(filename)
      log_reader = LogReader.new(log_file) do |line|
        self.distributer.process(line)
      end
      self.distributer.join
      archiver.backup(log_file)
    end    
  end
end