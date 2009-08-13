module DLogReader
  class ScribeReader
    attr_accessor :selector, :archiver, :filename
    attr_reader :log_reader
    def initialize(filename, backupdir, worker, num_threads = 10)
      self.filename = filename
      self.selector = RotatingLog.new
      self.selector.ignore_conditions << lambda{|x| !x.match(/scribe_stats/).nil?}
      @worker = worker
      self.archiver = DateDir.new(backupdir)
    end
    
    def process
      $dlog_logger.info("Started  #{log_file}:")
      lines_processed = 0
      @log_reader = LogReader.new(log_file) do |line|
        @worker.call(line)
        lines_processed += 1
      end
      @log_reader.run
      $dlog_logger.info("Finished #{log_file}: Processed (#{lines_processed}) lines")
      post_process
    end
    
    def log_file
      self.filename
    end
    
    def log_file
      @log_file ||= begin
        selector.file_to_process(filename)
      end
    end
    
    def post_process
      self.archiver.archive(log_file) unless current?
    end
    
    def current?
      directory = File.dirname(log_file)
      basename = File.basename(directory)
      current_file = Dir[File.join(directory, "*")].detect{|x| x.match(/current/)}
      File.exists?(current_file) && File.identical?(current_file, log_file) 
    end
  end
end