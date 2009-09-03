require 'digest/md5'
module DLogReader
  class LogReader
    attr_accessor :filename
    attr_writer :statefile
    
    def initialize(filename, &b)
      self.filename = filename
      @b = b
    end
  
    def run
      # raise IOError.new("no file given") if filename.nil?
      raise IOError.new("File not readable") unless File.readable?(filename)
      f = File.open(filename, "r+")
      load_saved_state(f)
      # raise IOError.new("File is locked") unless f.flock(File::LOCK_EX | File::LOCK_NB)
      unless f.eof?
        last_report = Time.now
        line_count = 0
        f.each_line do |line|
          @b.call(line)
          line_count += 1
          if (line_count % 100 == 0)
            time_passed = Time.now - last_report
            $dlog_logger.info( "#{Time.now.to_s} #{filename}: Processed (#{line_count}) lines [#{(100.0 / time_passed.to_f).to_i} lines/s]")
            last_report = Time.now
            save_state(f) 
          end
        end
        save_state(f)
      end
      # f.flock(File::LOCK_UN)
    end
    
    def statefile
      @statefile ||= begin
        log_basename = File.basename(filename)
        File.join("/tmp", "log_state_#{log_basename}")
      end
    end

  protected
    
    def load_saved_state(log_filehandle)
      return unless File.exists?(statefile) && !(state = File.read(statefile)).nil?
      pos, l_digest = Marshal.load(state)
      return if File.size(log_filehandle) < pos
      log_filehandle.pos = pos if digest(log_filehandle, pos) == l_digest
    end

    def save_state(log_filehandle)
      File.open(statefile, "w") do |f|
        f.write(Marshal.dump([log_filehandle.pos, digest(log_filehandle, log_filehandle.pos)]))
      end
    end

    def digest(log_filehandle, position)
      log_filehandle.pos = 0
      read_length = [position, 50].min
      l = log_filehandle.read(read_length)
      f_digest = Digest::MD5.hexdigest(l)
      log_filehandle.pos = position
      f_digest
    end
  end
end