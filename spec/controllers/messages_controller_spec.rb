require "rails_helper"

describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:another_user) { create(:user) }

  before do
    allow(controller).to receive(:require_login)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "new" do
    it "redirects to root path if user tries to send a message to themselves and have profile" do
      get :new, params: {profile_id: profile.id, receiver_id: user.id}

      expect(response).to redirect_to(profile_path(profile))
      expect(flash[:alert]).to eq("You cannot send a message to yourself.")
    end
  end

  describe "create" do
    context "with valid parameters" do
      it "creates a new message" do
        expect do
          post :create, params: {profile_id: profile.id, receiver_id: another_user.id, message: {subject: "test", message: "test"}}
        end.to change(Message, :count).by(1)
      end

      it "redirects to the profile path" do
        post :create, params: {profile_id: profile.id, receiver_id: another_user.id, message: {subject: "test", message: "test"}}

        expect(response).to redirect_to(profile_path(profile))
        expect(flash[:success]).to eq("Message successfully sent!")
      end
    end

    context "with invalid parameters" do
      it 'renders "new" template with unprocessable entity status' do
        post :create, params: {profile_id: profile.id, receiver_id: another_user.id, message: {subject: "Invalid Message"}}

        expect(response).to render_template("new")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "show" do
    let(:message) { create(:message, sender_id: another_user.id, receiver_id: user.id, sender_name: another_user.full_name, receiver_name: user.full_name, subject: "test", message: "test") }

    it "updates the message status based on the user role" do
      get :show, params: {message_id: message.id}

      expect(assigns(:message).hasRead).to be_truthy
    end
  end

  describe "delete inbox message" do
    let(:message) { create(:message, sender_id: another_user.id, receiver_id: user.id, sender_name: another_user.full_name, receiver_name: user.full_name, subject: "test", message: "test") }

    context 'with confirmation "yes"' do
      it "soft-deletes the message" do
        post :delete, params: {message_id: message.id, confirmation: "yes"}

        expect(message.reload.hasReceiverDeleted).to be_truthy
        expect(flash[:success]).to eq("Message deleted.")
      end

      it "redirects to view_messages_path" do
        post :delete, params: {message_id: message.id, confirmation: "yes"}

        expect(response).to redirect_to(view_messages_path)
      end
    end

    describe "delete inbox message" do
      let(:message) { create(:message, sender_id: user.id, receiver_id: another_user.id, sender_name: user.full_name, receiver_name: another_user.full_name, subject: "test", message: "test") }

      context 'with confirmation "yes"' do
        it "soft-deletes the message" do
          post :delete, params: {message_id: message.id, confirmation: "yes"}

          expect(message.reload.hasSenderDeleted).to be_truthy
          expect(flash[:success]).to eq("Message deleted.")
        end

        it "redirects to view_messages_path" do
          post :delete, params: {message_id: message.id, confirmation: "yes"}

          expect(response).to redirect_to(view_sent_messages_path)
        end
      end
    end
  end
end
