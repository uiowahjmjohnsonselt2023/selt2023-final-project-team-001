require "rails_helper"

RSpec.describe StorefrontsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :seller) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #index" do
    context "when user is logged in and is a seller" do
      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns necessary variables" do
        get :index
        expect(assigns(:storefronts)).to eq(Storefront.all)
      end
    end

    context "when user is not logged in" do
      before do
        session[:user_id] = nil
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns necessary variables" do
        get :index
        # I won't use this in the future sorry
        expect(assigns(:storefronts)).to eq(Storefront.all)
      end
    end
  end

  describe "GET #new" do
    context "when user is logged in and is a seller" do
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "assigns necessary variables" do
        get :new
        expect(assigns(:products)).to eq(user.products)
        expect(assigns(:storefront)).to eq(user.storefront)
        expect(assigns(:previewed_code)).to eq(user.storefront.custom_code)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :new
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You need to login before you can create a storefront!")
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "Get #new_storefront_with_template" do
    context "when user is logged in and is a seller" do
      it "renders the new_storefront_with_template template" do
        get :new_storefront_with_template
        expect(response).to render_template(:new_storefront_with_template)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :new_storefront_with_template
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You need to login before you can create a storefront!")
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        session[:user_id] = user.id
        get :new_storefront_with_template
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to create a storefront")
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in and is a seller" do
      context "when user clicks the 'Preview Custom Code' button" do
        it "renders the new template on preview" do
          post :create, params: {storefront: {custom_code: "1"}, preview_button: "Preview Custom Code"}
          expect(response).to render_template(:new)
          expect(flash[:notice]).to eq("Storefront successfully previewed, scroll down to see!")
        end

        it "assigns necessary variables" do
          post :create, params: {storefront: {custom_code: "1"}, preview_button: "Preview Custom Code"}
          expect(assigns(:products)).to eq(user.products)
          expect(assigns(:storefront)).to eq(user.storefront)
          expect(assigns(:previewed_code)).to eq("1")
        end
      end

      context "when user clicks the 'Save' button" do
        it "redirects to the storefronts" do
          post :create, params: {storefront: {custom_code: "1"}, save_button: "Save"}
          expect(response).to redirect_to(storefront_path(user.storefront))
          expect(flash[:notice]).to eq("Storefront successfully updated!")
        end

        it "updates the storefronts with the custom code" do
          post :create, params: {storefront: {custom_code: "1"}, save_button: "Save"}
          expect(user.storefront.reload.custom_code).to eq("1")
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        post :create, params: {storefront: {custom_code: "1"}, save_button: "Save"}
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST #choose_template" do
    context "when user is logged in and is a seller" do
      it "redirects to the storefronts" do
        post :choose_template, params: {template_number: "1"}
        expect(response).to redirect_to(storefront_path(user.storefront))
      end

      it "updates the storefronts with the custom code" do
        post :choose_template, params: {template_number: "1"}
        expect(user.storefront.reload.custom_code).to eq("1")
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        post :choose_template, params: {template_number: "1"}
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #show" do
    before do
      user.storefront = user.storefront || user.create_storefront
      user.storefront.update(custom_code: "some html code")
    end

    context "when user is logged in and is a seller" do
      it "renders the show template" do
        get :show, params: {id: user.storefront.id}
        expect(response).to render_template(:show)
      end

      it "renders the template1 template if the storefronts has custom code 1" do
        user.storefront.update(custom_code: "1")
        get :show, params: {id: user.storefront.id}
        expect(response).to render_template(:template1)
      end

      it "renders the template2 template if the storefronts has custom code 2" do
        user.storefront.update(custom_code: "2")
        get :show, params: {id: user.storefront.id}
        expect(response).to render_template(:template2)
      end

      it "assigns necessary variables" do
        get :show, params: {id: user.storefront.id}
        expect(assigns(:storefront)).to eq(user.storefront)
        expect(assigns(:user)).to eq(user)
        expect(assigns(:products)).to eq(user.products)
      end
    end
  end
end
