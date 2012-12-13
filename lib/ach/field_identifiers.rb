module ACH
  module FieldIdentifiers
    # NOTE: the msg parameter is unused and should be removed when the API can change
    def field(name, klass, stringify = nil, default = nil, validate = nil, msg ='')
      fields << name

      # getter
      define_method name do
        instance_variable_get( "@#{name}" )
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        if validate.kind_of?(Regexp)
          unless val =~ validate
            raise RuntimeError, "#{val} does not match Regexp #{validate} for field #{name}"
          end
        elsif validate.respond_to?(:call) # Proc with value as argument
          unless validate.call(val)
            raise RuntimeError, "#{val} does not pass validation Proc for field #{name}"
          end
        end

        instance_variable_set( "@#{name}", val )
      end

      # to_ach
      define_method  "#{name}_to_ach" do
        val = instance_variable_get( "@#{name}" )

        if val.nil?
          if default.kind_of?(Proc)
            val = default.call
          elsif default
            val = default
          else
            raise RuntimeError, "val of #{name} is nil"
          end
        end

        if stringify.nil?
          return val
        else
          stringify.call(val)
        end
      end
    end

    def const_field(name, val)
      fields << name

      # to_ach
      define_method  "#{name}_to_ach" do
        val
      end
    end

    # NOTE: Deprecated; this can be removed when the API is allowed to change
    def left_justify(val, length)
      val.ljust(length)
    end

    # A routing number without leading space
    def spaceless_routing_field(sym)
      field sym, String, nil, nil, /\A\d{9}\z/
    end
  end
end
