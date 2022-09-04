# frozen_string_literal: true

class SetWrongTypeOfOutputAdvanced < Actor
  output :name,
         type: {
           class_name: String,
           message: (lambda do |_kind, input_key, _service_name, expected_type_names, actual_type_name|
             "Wrong type `#{actual_type_name}` for `#{input_key}`. " \
             "Expected: `#{expected_type_names}`"
           end)
         }

  def call
    self.name = 42
  end
end