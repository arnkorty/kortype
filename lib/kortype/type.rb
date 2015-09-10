module Kortype
  class Type
    attr_reader :name, :type, :options
    def initialize name, type, options = {}
      @name = name
      if type.is_a?(String) || type.is_a?(Symbol)
        @type = eval(type.to_s)
      else
        @type = type
      end
      @options = options
    end

    def value
      @value ||= if options[:default]
        if Proc === options[:default]
          options[:default].call
        else
          options[:default]
        end
      end
    end

    def value=(value)
      if @type === value
        return @value = value
      elsif @options[:parse] && Proc === @options[:parse]
        @value = @options[:parse].call(value)
      elsif Kortype::Parse.has_parse?(@type)
        @value = Kortype::Parse.parse(value, @type)
      else
        if @type.respond_to? :parse
          begin
          @value = @type.parse value
          rescue
            raise Kortype::TypeError.new, "#{value} is not parse to a #{@type}"
          end
        else
          @value = value
        end
      end
      raise Kortype::TypeError.new, "#{value} is not parse to a #{@type}" unless @type === @value
      @value
    end

    # def dup
      #Kortype::Type.new @name, @type, @options
    #end
  end
end
