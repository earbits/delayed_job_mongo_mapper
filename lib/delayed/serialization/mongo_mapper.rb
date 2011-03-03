MongoMapper::Document.class_eval do
  yaml_as "tag:ruby.yaml.org,2002:MongoMapper"

  def self.yaml_new(klass, tag, val)
    klass.find!(val['_id'])
  rescue MongoMapper::DocumentNotFound
    raise Delayed::DeserializationError
  end

  def to_yaml_properties
    ['@_id']
  end
end

