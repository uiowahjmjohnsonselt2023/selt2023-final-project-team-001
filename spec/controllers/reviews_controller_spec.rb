require "rails_helper"

describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }

  describe "new" do
    context "when user tries to leave a review for themselves" do
      before do
        allow(controller).to receive(:require_login)
        allow(Current).to receive(:user).and_return(user)
      end

      it "redirects to the user profile with an alert message" do
        get :new, params: {profile_id: profile.id}
        expect(flash[:alert]).to eq("You cannot leave a review for yourself.")
        expect(response).to redirect_to(profile_path(Profile.find_by(user_id: user.id).id))
      end
    end

    context "when user is leaving a review for someone else" do
      before do
        allow(controller).to receive(:require_login)
        allow(Current).to receive(:user).and_return(user)
        allow(Profile).to receive(:find).and_return(profile)
      end

      it "renders the new template" do
        get :new, params: {profile_id: profile.id}

        expect(response).to redirect_to(profile_path(Profile.find_by(user_id: user.id).id))
      end
    end
  end

  describe "create" do
    let(:seller) { create(:user, is_seller: true) }
    let(:seller_profile) { create(:profile, user: seller, public_profile: true) }
    let(:valid_attributes) do
      {
        seller_id: seller.id,
        profile_id: seller_profile.id,
        answer: 1,
        rating: 4,
        description: "Great experience!"
      }
    end

    before do
      allow(controller).to receive(:require_login)
      allow(Current).to receive(:user).and_return(user)
      allow(User).to receive(:find).and_return(seller)
      allow(Review).to receive(:create)
      allow(Profile).to receive(:update)
    end

    it "creates a new review" do
      post :create, params: {profile_id: seller_profile.id, seller_id: seller.id, answer: valid_attributes[:answer], rating: valid_attributes[:rating], description: valid_attributes[:description]}
      expect(Review).to have_received(:create).with(reviewer_id: user.id, seller_id: seller.id.to_s, has_purchased_from: valid_attributes[:answer] == 1, interaction_rating: valid_attributes[:rating], description: valid_attributes[:description])
      expect(Profile).to have_received(:update).with(seller_profile.id.to_s, seller_rating: seller.reviews_for_sellers.average(:interaction_rating).to_i)
      expect(flash[:success]).to eq("Review successfully created!")
      expect(response).to redirect_to(profile_path(seller_profile.id))
    end
  end
end
