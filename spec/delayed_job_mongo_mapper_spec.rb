require 'spec_helper'

describe Delayed::Backend::MongoMapper::Job do
  it_should_behave_like 'a delayed_job backend'

  describe "before_fork" do
    after do
      ::MongoMapper.connection.close
    end

    it "should disconnect" do
      lambda do
        Delayed::Backend::MongoMapper::Job.before_fork
      end.should change { !!MongoMapper.connection.connected? }.from(true).to(false)
    end
  end

  describe "after_fork" do
    before do
      ::MongoMapper.connection.close
    end

    it "should call reconnect" do
      lambda do
        Delayed::Backend::MongoMapper::Job.after_fork
      end.should change { !!MongoMapper.connection.connected? }.from(false).to(true)
    end
  end
end
