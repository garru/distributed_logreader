require 'distributed_logreader/distributed_logreader'
require 'distributed_logreader/selector'
require 'distributed_logreader/achiver'
require 'distributed_logreader/util'
require 'logger'

$dlog_logger = Logger.new("distributed_logreader.log")
$dlog_logger.level = Logger::INFO
$dlog_logger.datetime_format = "%Y-%m-%d %H:%M:%S "