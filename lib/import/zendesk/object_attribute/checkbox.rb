# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

module Import
  class Zendesk
    module ObjectAttribute
      class Checkbox < Import::Zendesk::ObjectAttribute::Base

        def init_callback(_object_attribte)
          @data_option.merge!(
            default: false,
            options: {
              true  => 'yes',
              false => 'no',
            },
          )
        end

        private

        def data_type(_attribute)
          'boolean'
        end
      end
    end
  end
end
