require "rails_helper"

describe PasswordMailer, type: :mailer do
  describe "reset" do
    let(:user) { create(:user) }
    let(:mail) { PasswordMailer.with(user: user).reset }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["shopprwebsite@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Reset password")
    end

    it "sends the email to the correct user" do
      expect(mail.to).to eq([user.email])
    end
  end
end
