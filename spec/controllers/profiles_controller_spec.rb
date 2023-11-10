# spec/controllers/sessions_controller_spec.rb

require "rails_helper"

describe ProfilesController, type: :controller do
  let(:valid_user) { create(:user) }

  before do
    session[:user_id] = valid_user.id
  end

  describe "GET #edit" do
    let!(:valid_user) { create(:user_with_profile) }

    it "renders the edit form for the user's own profile" do
      get :edit, params: {id: valid_user.profile.id}

      expect(response).to render_template("edit")
      expect(assigns(:profile)).to eq(valid_user.profile)
    end

    it "redirects to root_path with an alert for editing someone else's profile while they have their own profile" do
      other_user = create(:user_with_profile)
      session[:user_id] = other_user.id

      get :edit, params: {id: valid_user.profile.id}

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You can only edit your own profile!")
    end

    it "redirects to new_profile_path with an alert for a user without a profile" do
      user = create(:user)
      session[:user_id] = user.id
      get :edit, params: {id: 10} # Profile id is irrelevant here, could be anything

      expect(response).to redirect_to(new_profile_path)
      expect(flash[:alert]).to eq("You don't have a profile to edit!")
    end
  end

  describe "PATCH #update" do
    let!(:valid_user) { create(:user_with_profile) }

    let(:profile_params) { {first_name: "Updated Name"} }

    it "updates the user's own profile and redirects to the profile" do
      patch :update, params: {id: valid_user.profile.id, profile: profile_params}

      expect(response).to redirect_to(profile_path(valid_user.profile))
      expect(flash[:notice]).to eq("Profile was successfully updated.")
    end

    it "redirects to root_path with an alert for updating someone else's profile when they have a profile" do
      other_user = create(:user_with_profile)
      patch :update, params: {id: other_user.profile.id, profile: profile_params}

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You can only edit your own profile!")
    end

    it "redirects to new_profile_path with an alert for a user without a profile" do
      other_user = create(:user)
      session[:user_id] = other_user.id
      patch :update, params: {id: 2812, profile: profile_params} # Profile id is irrelevant here, could be anything

      expect(response).to redirect_to(new_profile_path)
      expect(flash[:alert]).to eq("You don't have a profile to edit!")
    end

    it "renders the edit form with an alert for a failed update" do
      allow_any_instance_of(Profile).to receive(:update).and_return(false)
      patch :update, params: {id: valid_user.profile.id, profile: profile_params}

      expect(response).to render_template("edit")
      expect(flash.now[:alert]).to eq("Profile update failed. Please check the form.")
    end
  end

  describe "GET #new" do
    it "renders the sign-in page" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "creates a new profile" do
        user = create(:user)
        session[:user_id] = user.id
        expect(user.profile).to be_nil
        post :create, params: {
          profile: {
            first_name: "John",
            last_name: "Doe",
            bio: "I am a test user",
            location: "New York, NY",
            twitter: "https://x.com/test",
            facebook: "https://facebook.com/test",
            instagram: "https://instagram.com/test",
            website: "https://test.com",
            occupation: "Test User",
            public_profile: true,
            avatar: fixture_file_upload("test-avatar.png", "image/png")
          }
        }

        # forces ActiveRecord to re-fetch the associated profile from the database.
        # This is a common solution in tests when dealing with associations that
        # might not be updated immediately in-memory during the course of a test.
        expect(user.reload.profile).to be_truthy

        expect(user.profile.first_name).to eq("John")
        expect(user.profile.last_name).to eq("Doe")
        expect(user.profile.bio).to eq("I am a test user")
        expect(user.profile.location).to eq("New York, NY")
        expect(user.profile.twitter).to eq("https://x.com/test")
        expect(user.profile.facebook).to eq("https://facebook.com/test")
        expect(user.profile.instagram).to eq("https://instagram.com/test")
        expect(user.profile.website).to eq("https://test.com")
        expect(user.profile.occupation).to eq("Test User")
        expect(user.profile.public_profile).to be_truthy
        expect(user.profile.avatar).to be_truthy
        expect(response).to redirect_to(profile_path(user.profile))
        expect(flash[:notice]).to eq("Profile created successfully!")
      end
    end

    context "with invalid credentials" do
      it "fails to create a profile with an invalid website" do
        post :create, params: {
          profile: {
            website: "invalid_website"
          }
        }

        expect(valid_user.reload.profile).to be_nil
        expect(response).to render_template("new")
        expect(flash[:alert]).to eq("Profile creation failed. Please check the form.")
        expect(assigns(:profile).errors.full_messages).to include("Website is not a valid URL")
      end

      it "fails to create a profile with an invalid Twitter link" do
        post :create, params: {
          profile: {
            twitter: "invalid_twitter"
          }
        }

        expect(valid_user.reload.profile).to be_nil
        expect(response).to render_template("new")
        expect(flash[:alert]).to eq("Profile creation failed. Please check the form.")
        expect(assigns(:profile).errors.full_messages).to include("Twitter is not a valid Twitter link")
      end

      it "fails to create a profile with an invalid Instagram link" do
        post :create, params: {
          profile: {
            instagram: "invalid_instagram"
          }
        }

        expect(valid_user.reload.profile).to be_nil
        expect(response).to render_template("new")
        expect(flash[:alert]).to eq("Profile creation failed. Please check the form.")
        expect(assigns(:profile).errors.full_messages).to include("Instagram is not a valid Instagram link")
      end

      it "fails to create a profile with an invalid Facebook link" do
        post :create, params: {
          profile: {
            facebook: "invalid_facebook"
          }
        }

        expect(valid_user.reload.profile).to be_nil
        expect(response).to render_template("new")
        expect(flash[:alert]).to eq("Profile creation failed. Please check the form.")
        expect(assigns(:profile).errors.full_messages).to include("Facebook is not a valid Facebook link")
      end

      it "successfully creates a profile with blank fields" do
        post :create, params: {
          profile: {
            first_name: "",
            last_name: "",
            bio: "",
            location: "",
            twitter: "",
            facebook: "",
            instagram: "",
            website: "",
            occupation: "",
            public_profile: true,
            avatar: ""
          }
        }

        expect(valid_user.reload.profile).to be_truthy
        expect(response).to redirect_to(profile_path(assigns(:profile)))
        expect(flash[:notice]).to eq("Profile created successfully!")
      end
    end
  end

  describe "GET #show" do
    let(:valid_user) { create(:user_with_profile) }

    context "when viewing own profile" do
      it "renders the show page" do
        get :show, params: {id: valid_user.profile.id}

        expect(response).to render_template("show")
        expect(assigns(:profile)).to eq(valid_user.profile)
      end
    end

    context "when viewing another user's public profile" do
      let(:public_user) { create(:user_with_public_profile) }

      it "renders the show page" do
        get :show, params: {id: public_user.profile.id}

        expect(response).to render_template("show")
        expect(assigns(:profile_requested)).to eq(public_user.profile)
      end
    end

    context "when viewing another user's private profile" do
      let(:private_user) { create(:user_with_private_profile) }

      it "redirects to root_path with an alert" do
        get :show, params: {id: private_user.profile.id}

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("This profile is private!")
      end
    end

    context "when viewing a non-existent profile" do
      it "redirects to root_path with an alert" do
        get :show, params: {id: 999} # Non-existent profile id

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("This profile does not exist!")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:valid_user) { create(:user) }
    let(:valid_profile) { create(:profile, user: valid_user) }

    before do
      session[:user_id] = valid_user.id
      valid_user.profile = valid_profile
    end

    it "destroys the user's own profile and redirects to root_path" do
      delete :destroy, params: {id: valid_user.profile.id}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Profile deleted successfully!")
    end

    it "redirects to root_path with an alert for deleting someone else's profile" do
      other_user = create(:user_with_profile)
      delete :destroy, params: {id: other_user.profile.id}

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You can only delete your own profile!")
    end

    it "redirects to root_path with an alert for a user without a profile" do
      other_user = create(:user)
      session[:user_id] = other_user.id
      delete :destroy, params: {id: 123} # profile id is irrelevant here, could be anything

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You don't have a profile to delete!")
    end
  end

  # delete
  describe "GET #delete" do
    it "renders the delete page" do
      other_user = create(:user_with_profile)
      session[:user_id] = other_user.id
      get :delete, params: {id: other_user.profile.id}
      expect(response).to render_template("delete")
    end
  end
  # Other tests can be added
end
