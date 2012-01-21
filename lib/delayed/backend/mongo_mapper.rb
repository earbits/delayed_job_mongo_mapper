module Delayed
  module Backend
    module MongoMapper
      
      ## Persisted Job Object
      ## Contains the work object as YAML 
      class Job
        include ::MongoMapper::Document
    
        include Delayed::Backend::Base
        set_collection_name 'delayed_jobs'

        key :priority,    Integer, :default => 0
        key :attempts,    Integer, :default => 0
        key :handler,     String
        key :run_at,      Time
        key :locked_at,   Time
        key :locked_by,   String    #,  :index => true
        key :failed_at,   Time
        key :last_error,  String
        
        timestamps!

        #ensure_index [[:locked_by, -1], [:priority, 1], [:run_at, 1]]

        before_save :set_default_run_at

        def self.before_fork
          ::MongoMapper.connection.close
        end

        def self.after_fork
          ::MongoMapper.connection.connect
        end

        def self.db_time_now
            Time.now.utc
        end



        # Reserves this job for the worker.
        #
        # Uses Mongo's findAndModify operation to atomically pick and lock one
        # job from from the collection. findAndModify is not yet available
        # directly thru MongoMapper so go down to the Mongo Ruby driver instead.
    def self.reserve(worker, max_run_time = Worker.max_run_time)
          right_now = db_time_now
          

          conditions = {:run_at  => {"$lte" => right_now}, :failed_at => nil}
          (conditions[:priority] ||= {})['$gte'] = Worker.min_priority.to_i if Worker.min_priority
          (conditions[:priority] ||= {})['$lte'] = Worker.max_priority.to_i if Worker.max_priority


          conditions['$or'] = [
            { :locked_by => worker.name },
            { :locked_at => nil },
            { :locked_at => { '$lt' => (right_now - max_run_time) }}
          ]

          begin
            result = self.collection.find_and_modify(
              :query  => conditions,
              :sort   => [['locked_by', -1], ['priority', -1], ['run_at', 1]],
              :update => {"$set" => {:locked_at => right_now, :locked_by => worker.name}}
            )

            # Return result as a MongoMapper document.
            # When MongoMapper starts supporting findAndModify, this extra step should no longer be necessary.
            self.first :conditions => {:_id => result["_id"]} unless result.nil?
          rescue Mongo::OperationFailure
            nil # no jobs available
          end
        end

        # When a worker is exiting, make sure we don't have any locked jobs.
        def self.clear_locks!(worker_name)
          self.collection.update({:locked_by => worker_name}, {"$set" => {:locked_at => nil, :locked_by => nil}}, :multi => true)
        end
    
        
    
      end
    end
  end
end
