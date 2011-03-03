# delayed_job MongoMapper backend

## Installation

Add the gems to your Gemfile:

    gem 'delayed_job'
    gem 'delayed_job_mongo_mapper'

Create the indexes:

    script/rails runner 'Delayed::Backend::MongoMapper::Job.create_indexes'

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).
