# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

module Import
  module OTRS
    class DynamicField
      class DateTime < Import::OTRS::DynamicField
        def init_callback(dynamic_field)
          @attribute_config.merge!(
            data_type:   'datetime',
            data_option: {
              future: dynamic_field['Config']['YearsInFuture'] != '0',
              past:   dynamic_field['Config']['YearsInPast'] != '0',
              diff:   dynamic_field['Config']['DefaultValue'].to_i / 60 / 60,
              null:   true,
            }
          )
        end
      end
    end
  end
end
