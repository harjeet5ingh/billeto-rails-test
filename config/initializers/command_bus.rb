Rails.application.config.to_prepare do
  bus = Arkency::CommandBus.new

  # Each handler runs inside a transaction, matching the guideline that
  # command execution should always be atomic.
  in_transaction = ->(command) { ApplicationRecord.transaction { command.call } }

  bus.register(Voting::UpvoteEvent, in_transaction)
  bus.register(Voting::DownvoteEvent, in_transaction)

  Rails.configuration.command_bus = bus
end
