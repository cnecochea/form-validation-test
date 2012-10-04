module FormHelper
end

module ActionView
  module Helpers
    class FormBuilder
      def validated_date_select(field_name, options={}, html_options={})
        options.merge!(validate: false)
        validator_id = "#{@object_name}_#{field_name}"
        html_options.merge!('data-validated-by' => validator_id,
                            'data-pre-validation-callback' => "buildDateString('#{validator_id}')")
        @template.date_select(@object_name, field_name, options, html_options)
      end
    end
  end
end
