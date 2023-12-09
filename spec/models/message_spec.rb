require "rails_helper"

describe Message, type: :model do
  let(:user) { create(:user) }

  context "with valid attributes" do
    it "is valid" do
      message = build(:message, sender: user, receiver: user, sender_name: "joe", receiver_name: "jane", subject: "test", message: "test")
      expect(message).to be_valid
    end
  end

  context "with missing sender information" do
    it "is invalid" do
      message = build(:message, sender_id: nil, sender_name: nil)
      expect(message).to be_invalid
      expect(message.errors[:sender_id]).to include("can't be blank")
      expect(message.errors[:sender_name]).to include("can't be blank")
    end
  end

  context "with missing receiver information" do
    it "is invalid" do
      message = build(:message, receiver_id: nil, receiver_name: nil)
      expect(message).to be_invalid
      expect(message.errors[:receiver_id]).to include("can't be blank")
      expect(message.errors[:receiver_name]).to include("can't be blank")
    end
  end

  context "with missing message information" do
    it "is invalid" do
      message = build(:message, subject: nil, message: nil)
      expect(message).to be_invalid
      expect(message.errors[:subject]).to include("can't be blank")
      expect(message.errors[:message]).to include("can't be blank")
    end
  end
end
