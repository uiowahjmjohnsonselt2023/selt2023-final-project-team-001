# spec/controllers/sessions_controller_spec.rb

require "rails_helper"

describe ProfilesController, type: :controller do
  # let(:valid_user) { create(:user, email: "admin@admin.com", password: "admin") }

  let(:valid_user) { create(:user) }

  before do
    session[:user_id] = valid_user.id
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "creates a new profile" do
        expect(valid_user.profile).to be_nil
        post :create, params: {
          profile: {
            first_name: "John",
            last_name: "Doe",
            bio: "I am a test user",
            location: "New York, NY",
            twitter: "https://twitter.com/test",
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
        expect(valid_user.reload.profile).to be_truthy

        expect(valid_user.profile.first_name).to eq("John")
        expect(valid_user.profile.last_name).to eq("Doe")
        expect(valid_user.profile.bio).to eq("I am a test user")
        expect(valid_user.profile.location).to eq("New York, NY")
        expect(valid_user.profile.twitter).to eq("https://twitter.com/test")
        expect(valid_user.profile.facebook).to eq("https://facebook.com/test")
        expect(valid_user.profile.instagram).to eq("https://instagram.com/test")
        expect(valid_user.profile.website).to eq("https://test.com")
        expect(valid_user.profile.occupation).to eq("Test User")
        expect(valid_user.profile.public_profile).to be_truthy
        expect(valid_user.profile.avatar).to be_truthy
        expect(response).to redirect_to(profile_path(valid_user.profile))
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
    end
  end

  describe "DELETE #destroy" do
    pending "deletes the profile" do
    end
    # it "signs out the user" do
    #   user = create(:user)
    #   session[:user_id] = user.id
    #   delete :destroy
    #   expect(session[:user_id]).to be_nil
    # end
    #
    # it "redirects to the root after logging in" do
    #   user = create(:user)
    #   session[:user_id] = user.id
    #   delete :destroy
    #   expect(response).to redirect_to("/")
    # end
    #
    # it "displays a success flash message after logging in" do
    #   user = create(:user)
    #   session[:user_id] = user.id
    #   delete :destroy
    #   expect(flash[:notice]).to eq("Signed out successfully!")
    # end
    #
    # it "redirects to the login when not logged in" do
    #   delete :destroy
    #   expect(response).to redirect_to("/login")
    # end
    #
    # it "gives flash message telling to log in when not logged in" do
    #   delete :destroy
    #   expect(flash[:notice]).to eq("You need to sign in before you can sign out!")
    # end
  end

  describe "GET #new" do
    pending "renders the new profile page" do
    end
    # it "renders the sign-in page" do
    #   get :new
    #   expect(response).to render_template("new")
    # end
  end

  # Other tests can be added
end
