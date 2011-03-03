require 'mongo_mapper'
require 'delayed_job'
require 'delayed/serialization/mongo_mapper'
require 'delayed/backend/mongo_mapper'

Delayed::Worker.backend = :mongo_mapper
