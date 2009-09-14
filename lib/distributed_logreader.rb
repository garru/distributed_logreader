require 'distributed_logreader/selector.rb'
require 'distributed_logreader/achiver.rb'
require 'distributed_logreader/util.rb'
require 'distributed_logreader/distributed_log_reader'
require 'distributed_logreader/distributed_log_reader/rotater_reader'
require 'distributed_logreader/distributed_log_reader/scribe_reader'
require 'logger'

$dlog_logger = Logger.new("/var/log/distributed_logreader.log")
$dlog_logger.level = Logger::DEBUG
$dlog_logger.datetime_format = "%Y-%m-%d %H:%M:%S "
