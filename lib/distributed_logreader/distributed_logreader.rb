class DistributedLogReader
  attr_accessor :logger, :log_chooser, :log_archiver

  def initialize(log_chooser, log_archiver)
    @log_chooser = log_chooser
    @log_archiver = log_archiver
    @file_name = RotatingLog.file_to_process(file_or_dir)
    @tarball = false
    @base_backup_dir = backup_dir
    @backup_dir = nil
    @tarball = (backup_dir && tarball)
    @logger = Logger.new(File.join(File.dirname(__FILE__), '..', 'distributed_logreader.log'))
  end

  def add_worker(worker)
    logger.info("Adding Worker #{worker.to_s}")
    self.workers << worker
  end
  
  def run
    next unless File.readable?()
    f = File.open(x, "r+")
    next unless f.flock(File::LOCK_EX | File::LOCK_NB)
    file_to_process(@file_name)
    process(f)
    f.flock(File::LOCK_UN)
    create_backup_dir(@base_backup_dir, Time.now) if @base_backup_dir
    backup(x)
  end
  
  def process(log_file)
    log_file.each_line do |line|
      self.workers.each do |worker|
        # log.info("Log Parser - Passing parsed_log_data to #{worker.name}")
        begin
          worker.call(line)
        rescue Exception => e
          RAILS_DEFAULT_LOGGER.fatal(e.message)
          log_file.flock(File::LOCK_UN)
        rescue ActiveRecord::StatementInvalid => e
          if e.message =~ /MySQL server has gone away/
            RAILS_DEFAULT_LOGGER.fatal(e.message)
            sleep 1
            ActiveRecord::Base.connection.reconnect!
          end
        end
      end
    end
  end
  
  def create_tarball
    File.exist?(@backup_dir + "tar.bz2")
  end
  
  def tarball
    if @tarball
      tar_cmd = "tar -cjf #{@base_backup_dir}/#{@time}.tar.bz2 -C #{@base_backup_dir} --remove-files #{@time}/"
      puts tar_cmd
      `#{tar_cmd}` 
      # rmdir(@backup_dir)
    end
  end
  
protected

  def load_saved_state(log_file)
    return unless File.exists?(statefile) && !(state = File.read(statefile)).nil?
    pos, last_file_size = Marshal.load(state)
    
    # Check for log rotation
    return if File.size(@file_name) < last_file_size
    
    log_file.pos = pos
  end

  def logger
    @logger
  end

  def save_state(log_file)
    File.open(statefile, "w") do |f|
      f.write(Marshal.dump([log_file.pos, File.size(log_file)]))
    end
  end
  
end
