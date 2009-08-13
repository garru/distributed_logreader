# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{distributed_logreader}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gary Tsang"]
  s.date = %q{2009-08-12}
  s.email = %q{gary@garru.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "distributed_logreader.gemspec",
     "lib/distributed_logreader.rb",
     "lib/distributed_logreader/achiver.rb",
     "lib/distributed_logreader/archiver/date_dir.rb",
     "lib/distributed_logreader/distributed_log_reader.rb",
     "lib/distributed_logreader/distributed_log_reader/rotater_reader.rb",
     "lib/distributed_logreader/distributed_log_reader/scribe_reader.rb",
     "lib/distributed_logreader/distributer.rb",
     "lib/distributed_logreader/distributer/mutex_counter.rb",
     "lib/distributed_logreader/distributer/pandemic_processor.rb",
     "lib/distributed_logreader/distributer/simple_forked_process.rb",
     "lib/distributed_logreader/distributer/simple_thread_pool.rb",
     "lib/distributed_logreader/log_reader.rb",
     "lib/distributed_logreader/selector.rb",
     "lib/distributed_logreader/selector/rotating_log.rb",
     "lib/distributed_logreader/util.rb",
     "spec/archiver/date_dir_spec.rb",
     "spec/archiver_spec.rb",
     "spec/distributed_log_reader/rotater_reader_spec.rb",
     "spec/distributed_log_reader/scribe_reader_spec.rb",
     "spec/distributed_log_reader_spec.rb",
     "spec/distributer/simple_thread_pool_spec.rb",
     "spec/distributer_spec.rb",
     "spec/fixtures/copytruncate/test",
     "spec/fixtures/copytruncate/test.1",
     "spec/fixtures/copytruncate/test_current",
     "spec/fixtures/logrotate/test-20090101",
     "spec/fixtures/logrotate/test-20090102",
     "spec/fixtures/symlink/test",
     "spec/fixtures/symlink/test_older_sym",
     "spec/fixtures/test_file",
     "spec/fixtures/virality_metrics/test",
     "spec/fixtures/virality_metrics/virality_metrics_current",
     "spec/log_reader_spec.rb",
     "spec/selector/rotating_log_spec.rb",
     "spec/selector_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/garru/distributed_logreader}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}
  s.test_files = [
    "spec/archiver/date_dir_spec.rb",
     "spec/archiver_spec.rb",
     "spec/distributed_log_reader/rotater_reader_spec.rb",
     "spec/distributed_log_reader/scribe_reader_spec.rb",
     "spec/distributed_log_reader_spec.rb",
     "spec/distributer/simple_thread_pool_spec.rb",
     "spec/distributer_spec.rb",
     "spec/log_reader_spec.rb",
     "spec/selector/rotating_log_spec.rb",
     "spec/selector_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
