class Event < ApplicationRecord
  has_one :vote_count, class_name: "Voting::VoteCount", inverse_of: :event, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :starts_at, presence: true
  validate :starts_at_is_a_time

  def self.upsert_from_billetto(attrs)
    find_or_initialize_by(external_id: attrs.fetch(:external_id)).tap do |event|
      event.assign_attributes(attrs)
    end
  end

  def upvotes
    vote_count&.upvotes.to_i
  end

  def downvotes
    vote_count&.downvotes.to_i
  end

  private

  def starts_at_is_a_time
    return if starts_at.blank? || starts_at.is_a?(ActiveSupport::TimeWithZone) || starts_at.is_a?(Time)

    errors.add(:starts_at, "must be a valid date and time")
  end
end
