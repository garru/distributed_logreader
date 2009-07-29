require 'fileutils'
module DLogReader
  class DateDir < Archiver
    include FileUtils
    attr_accessor :base_backup_dir
  
    def initialize(backup_dir)
      self.base_backup_dir = backup_dir
    end
  
    def backup(file)
      mv(file, backup_dir)
    end

  protected

    def backup_dir
      time = Time.now
      directory_structure = [base_backup_dir, time.year.to_s, time.month.to_s, time.day.to_s]
      temp_dir = []
      directory_structure.each do |x|
        temp_dir << x
        temp_file = File.join(temp_dir)
        unless File.exist?(temp_file)
          mkdir(temp_file) 
        end
      end
      File.join(temp_dir)
    end
  
  end
end