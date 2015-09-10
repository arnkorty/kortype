require "kortype/version"
require 'kortype/type_error'
require 'kortype/parse'
require 'kortype/type'

#require 'active_support/concern'
#require 'active_support/hash_with_indifferent_access'

module Kortype
  #extend ActiveSupport::Concern
  def Kortype.included(base)
    base.extend Kortype::ClassMethods
  end

  def kortype_columns
    @kortype_columns ||= begin
                           cols = {}
                           self.class.kortype_columns.each do |key, value|
                             cols[key] = Kortype::Type.new value.name, value.type, value.options
                           end
                           cols
                         end
  end

  module ClassMethods
    def kortype_columns
      @kortype_columns ||= {}
    end

    def kortype *attrs
      if Hash === attrs[-1]
        options = {}
        attrs.delete_at(-1).each do |key, value|
          options[key.to_sym] = value
        end
      else
        options = {}
      end
      type = options.delete :type
      raise ArgumentError.new, 'must set the attribute type' unless type
      attrs.map!(&:to_sym)
      attrs.each do |attr|
        kortype_columns[attr] = Kortype::Type.new attr, type, options
        class_eval do
          define_method attr do
            self.kortype_columns[attr].value
          end
          define_method "#{attr}=" do |value|
            self.kortype_columns[attr].value = value
          end
        end
      end
    end
  end
end
