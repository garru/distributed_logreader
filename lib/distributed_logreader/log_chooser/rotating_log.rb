class RotatingLog < LogChooser
  
  def file_to_process(file_or_dir)
    if File.directory?(file_or_dir)
      directory = file_or_dir
      basename = '/'
    else
      directory = File.dirname(file_or_dir)
      basename = File.basename(file_or_dir)
    end    
    oldest_logfile(directory, basename)
  end

protected

  def oldest_logfile(directory, basename)
    file_list = Dir[File.join(directory, "#{basename}*")]
    file_list.reject!{|x| symlink_file_in_dir?(x)}
    file = file_list.size > 0 ? file_list.sort_by{|a| File.new(a).mtime}.first : nil
  end

  # returns true if filename is a symlink and its referring to a file already inside the current directory
  def symlink_file_in_dir?(filename)
    File.symlink?(filename) && File.dirname(File.readlink(filename)) == File.dirname(filename)
  end
end