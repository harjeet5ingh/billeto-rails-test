module Command
  # Mixin for a simple, self-executing command (GOF command pattern): give it
  # typed attributes, some validations, and a #call method with the actual
  # logic. No handler class or registration needed beyond wiring it into the
  # command bus.
  module Executable
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
      include ActiveModel::Attributes
    end
  end
end
