require "rails_helper"

RSpec.describe Event, type: :model do
  it "is valid with a title, external_id and starts_at" do
    expect(build(:event)).to be_valid
  end

  it "requires a title" do
    expect(build(:event, title: nil)).not_to be_valid
  end

  it "requires an external_id" do
    expect(build(:event, external_id: nil)).not_to be_valid
  end

  it "requires external_id to be unique" do
    create(:event, external_id: "billetto-1")

    expect(build(:event, external_id: "billetto-1")).not_to be_valid
  end

  it "requires starts_at" do
    expect(build(:event, starts_at: nil)).not_to be_valid
  end

  describe ".upsert_from_billetto" do
    it "creates a new event when the external_id is unseen" do
      attrs = attributes_for(:event, external_id: "billetto-42")

      expect { Event.upsert_from_billetto(attrs).save! }.to change(Event, :count).by(1)
    end

    it "updates the existing event when the external_id is already known" do
      existing = create(:event, external_id: "billetto-42", title: "Old title")
      attrs = attributes_for(:event, external_id: "billetto-42", title: "New title")

      expect { Event.upsert_from_billetto(attrs).save! }.not_to change(Event, :count)
      expect(existing.reload.title).to eq("New title")
    end
  end
end
