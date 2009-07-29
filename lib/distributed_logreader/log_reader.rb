module DLogReader
  class LogReader
    attr_accessor :statefile, :filename
    def initialize(filename, &b)
      self.filename = filename
      log_basename = File.basename(filename)
      self.statefile = File.join(File.dirname(filename), "log_state_#{log_basename}")
      @b = b
    end
  
    def run
      raise IOError.new("File not readable") unless File.readable?(filename)
      f = File.open(filename, "r+")
      load_saved_state(f)
      raise IOError.new("File is locked") unless f.flock(File::LOCK_EX | File::LOCK_NB)
      f.each_line do |line|
        @b.call(line)
      end
      save_state(f)
      f.flock(File::LOCK_UN)
    end

  protected

    def load_saved_state(log_filehandle)
      return unless File.exists?(statefile) && !(state = File.read(statefile)).nil?
      pos, last_file_size = Marshal.load(state)
      # Check for log rotation
      return if File.size(filename) < last_file_size
      log_filehandle.pos = pos
    end

    def save_state(log_filehandle)
      File.open(statefile, "w") do |f|
        f.write(Marshal.dump([log_filehandle.pos, File.size(log_filehandle)]))
      end
    end

  end
end