# frozen_string_literal: true

# Add checks to your inputs, by specifying what values are authorized under the
# "in" key.
#
# Example:
#
#   class Pay < Actor
#     input :provider, inclusion: ["MANGOPAY", "PayPal", "Stripe"]
#   end
#
#   class Pay < Actor
#     input :provider,
#           inclusion: {
#             in: ["MANGOPAY", "PayPal", "Stripe"],
#             message: (lambda do |input_key:, actor:, inclusion_in:, value:|
#               "Payment system \"#{value}\" is not supported"
#             end)
#           }
#   end
class ServiceActor::Checkers::InclusionChecker < ServiceActor::Checkers::Base
  DEFAULT_MESSAGE = lambda do |input_key:, actor:, inclusion_in:, value:|
    "The \"#{input_key}\" input must be included " \
      "in #{inclusion_in.inspect} on \"#{actor}\" " \
        "instead of #{value.inspect}"
  end

  private_constant :DEFAULT_MESSAGE

  def self.for(input_key:, actor:, inclusion:, value:)
    new(
      input_key: input_key,
      actor: actor,
      inclusion: inclusion,
      value: value,
    ).check
  end

  def initialize(input_key:, actor:, inclusion:, value:)
    super()

    @input_key = input_key
    @actor = actor
    @inclusion = inclusion
    @value = value
  end

  def check
    inclusion_in, message = define_inclusion_and_message

    return if inclusion_in.nil?
    return if inclusion_in.include?(@value)

    add_argument_error(
      message,
      input_key: @input_key,
      actor: @actor,
      inclusion_in: inclusion_in,
      value: @value,
    )
  end

  private

  def define_inclusion_and_message
    if @inclusion.is_a?(Hash)
      @inclusion.values_at(:in, :message)
    else
      [@inclusion, DEFAULT_MESSAGE]
    end
  end
end