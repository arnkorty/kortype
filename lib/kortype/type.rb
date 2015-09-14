module Kortype
  class Type
    attr_reader :name, :type, :options, :value, :default
    def initialize name, type, options = {}
      @name = name
      if type.is_a?(String) || type.is_a?(Symbol)
        @type = eval(type.to_s)
      else
        @type = type
      end
      @options = options
      @default = @options[:default]
      if @default
        @value =  (Proc === @default ? @default.call : @default)
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
      unless @type === @value
        @value = nil
        raise Kortype::TypeError.new, "#{value} is not parse to a #{@type}"
      end
      @value
    end

    def valid?
      return false if !@value && @options[:required]
      if @value && @options[:validate]
        if Regexp === @options[:validate]
          return !!(@value =~ @options[:validate])
        elsif Proc === @options[:validate]
          return @options[:validate].call(@value)
        end
      end
      true
    end

    # def dup
    #Kortype::Type.new @name, @type, @options
    #end
  end
end
