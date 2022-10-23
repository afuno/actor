# frozen_string_literal: true

# Ensure your inputs and outputs are not nil by adding `allow_nil: false`.
#
# Example:
#
#   class CreateUser < Actor
#     input :name, allow_nil: false
#     output :user, allow_nil: false
#   end
#
#   class CreateUser < Actor
#     input :name,
#           allow_nil: {
#             is: false,
#             message: (lambda do |origin:, input_key:, actor:|
#               "The value \"#{input_key}\" cannot be empty"
#             end)
#           }
#
#     input :phone, allow_nil: { is: false, message: "Phone must be present" }
#
#     output :user,
#             allow_nil: {
#               is: false,
#               message: (lambda do |origin:, input_key:, actor:|
#                 "The value \"#{input_key}\" cannot be empty"
#               end)
#             }
#   end
class ServiceActor::Checkers::NilChecker < ServiceActor::Checkers::Base
  DEFAULT_MESSAGE = lambda do |origin:, input_key:, actor:|
    "The \"#{input_key}\" #{origin} on \"#{actor}\" does not allow nil values"
  end

  private_constant :DEFAULT_MESSAGE

  def self.for(origin:, input_key:, input_options:, actor:, allow_nil:, value:) # rubocop:disable Metrics/ParameterLists
    new(
      origin: origin,
      input_key: input_key,
      input_options: input_options,
      actor: actor,
      allow_nil: allow_nil,
      value: value,
    ).check
  end

  def initialize(origin:, input_key:, input_options:, actor:, allow_nil:, value:) # rubocop:disable Layout/LineLength, Metrics/ParameterLists
    super()

    @origin = origin
    @input_key = input_key
    @input_options = input_options
    @actor = actor
    @allow_nil = allow_nil
    @value = value
  end

  def check
    return unless @value.nil?

    allow_nil, message =
      define_allow_nil_and_message_from(@input_options[:allow_nil])

    # puts
    # puts
    # puts :input_options
    # puts @input_options.inspect
    # puts @input_options[:allow_nil].inspect
    # puts
    # puts

    # puts
    # puts
    # puts :allow_nil?
    # puts allow_nil.inspect
    # puts allow_nil?(allow_nil).inspect
    # puts
    # puts

    return if allow_nil?(allow_nil)

    add_argument_error(
      message,
      origin: @origin,
      input_key: @input_key,
      actor: @actor,
    )
  end

  private

  def define_allow_nil_and_message_from(allow_nil)
    if allow_nil.is_a?(Hash)
      allow_nil.values_at(:is, :message)
    else
      [allow_nil, DEFAULT_MESSAGE]
    end
  end

  def allow_nil?(tmp_allow_nil)
    return tmp_allow_nil unless tmp_allow_nil.nil?

    if @input_options.key?(:default) && @input_options[:default].nil?
      return true
    end

    !@input_options[:type]
  end
end