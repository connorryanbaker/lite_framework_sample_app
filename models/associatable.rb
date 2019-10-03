require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.downcase.to_s + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.capitalize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || (self_class_name.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id 
    @class_name = options[:class_name] || name.to_s.capitalize.singularize
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do 
      pk = options.send(:primary_key)
      fk = options.send(:foreign_key)
      model = options.send(:class_name).constantize
      params = {"#{pk}": self.send("#{fk}")}
      model.where(params).first
    end 
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do 
      pk = options.send(:primary_key)
      id = self.send(pk)
      fk = options.send(:foreign_key)
      model = options.send(:class_name).constantize
      params = {"#{fk}": id}
      res = model.where(params)
      if res.is_a?(Array) 
        return res.length == 0 ? [] : res
      end 
      [res]
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do 
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      id = self.send(through_options.foreign_key)
      through_options.model_class.find(id).send(source_name)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
