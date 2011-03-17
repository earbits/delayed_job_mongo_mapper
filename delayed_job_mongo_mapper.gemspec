# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name              = 'delayed_job_mongo_mapper'
  s.summary           = "MongoMapper backend for delayed_job"
  s.version           = '1.0.0'
  s.authors           = 'Andrew Timberlake'
  s.date              = Date.today.to_s
  s.email             = 'andrew@andrewtimberlake.com'
  s.extra_rdoc_files  = ["LICENSE", "README.md"]
  s.files             = Dir.glob("{lib,spec}/**/*") + %w[LICENSE README.md]
  s.homepage          = 'http://github.com/andrewtimberlake/delayed_job_mongo_mapper'
  s.rdoc_options      = ['--charset=UTF-8']
  s.require_paths     = ['lib']
  s.test_files        = Dir.glob('spec/**/*')

  s.add_runtime_dependency      'mongo_mapper',      '~> 0.9'
  s.add_runtime_dependency      'delayed_job',  '~> 2.1.1'
  s.add_development_dependency  'rspec',        '>= 2.0'
end

