# frozen_string_literal: true

class PayWithProvider < Actor
  input :provider, inclusion: %w[MANGOPAY PayPal Stripe], default: "Stripe"
  output :message, type: String

  def call
    self.message = "Money transferred to #{provider}!"
  end
end
