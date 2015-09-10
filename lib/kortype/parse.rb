module Kortype
  class Parse
    PARSE = {
      String => :to_s,
      Integer => :to_i,
      Fixnum => :to_i,
      Float => :to_f,
      Array => :to_a,
      Hash => :to_h,
      #BigDecimal => :to_d,
      Symbol => :to_sym
    }
    def self.has_parse? type
      PARSE.has_key? type
    end
    def self.parse(value, type)
      value.send(PARSE[type])
    end
  end
end
