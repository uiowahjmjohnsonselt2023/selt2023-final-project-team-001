require "rails_helper"

RSpec.describe StorefrontsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :seller) }
  let(:user2) { FactoryBot.create(:user, :seller) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #index" do
    context "when user is logged in and is a seller" do
      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "renders the index template with search" do
        get :index, params: {search: "test"}
        expect(response).to render_template(:index)
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

      it "renders the index template with search" do
        get :index, params: {search: "test"}
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #new" do
    context "when user is logged in and is a seller" do
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "redirects to the storefront when the user already has one" do
        user.create_storefront(attributes_for(:storefront))
        get :new
        expect(response).to redirect_to(storefront_path(user.storefront))
        expect(flash[:alert]).to eq("You already have a storefront.")
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :new
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can create a storefront!"
        )
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to create a storefront!")
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in and is a seller" do
      context "with valid attributes" do
        it "redirects to the storefronts" do
          post :create, params: {storefront: attributes_for(:storefront)}
          expect(response).to redirect_to(storefront_path(Storefront.last))
          expect(flash[:notice]).to eq("Storefront successfully created!")
        end

        it "saves the new storefront to the database" do
          expect {
            post :create, params: {storefront: attributes_for(:storefront)}
          }.to change(Storefront, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "re-renders the new template" do
          post :create, params: {storefront: attributes_for(:storefront, name: nil)}
          expect(response).to render_template(:new)
        end

        it "does not save the new storefront to the database" do
          expect {
            post :create, params: {storefront: attributes_for(:storefront, name: nil)}
          }.to_not change(Storefront, :count)
        end
      end

      context "when user already has a storefront" do
        it "redirects to the storefront" do
          user.create_storefront(attributes_for(:storefront))
          post :create
          expect(response).to redirect_to(storefront_path(user.storefront))
          expect(flash[:alert]).to eq("You already have a storefront.")
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        post :create, params: {storefront: attributes_for(:storefront)}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You need to login before you can create a storefront!")
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        post :create, params: {storefront: attributes_for(:storefront)}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to create a storefront!")
      end
    end
  end

  describe "GET #edit" do
    context "when user is logged in and is a seller" do
      it "renders the edit template" do
        user.create_storefront(attributes_for(:storefront))
        get :edit, params: {id: user.storefront.id}
        expect(response).to render_template(:edit)
      end

      it "raises an error when the user doesn't have a storefront" do
        expect {
          get :edit, params: {id: 0}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects when the storefront isn't the user's" do
        user.create_storefront(attributes_for(:storefront))
        user2.create_storefront(attributes_for(:storefront))
        get :edit, params: {id: user2.storefront.id}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You can only update your own storefront!")
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :edit, params: {id: 0}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can edit a storefront!"
        )
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        get :edit, params: {id: 0}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to edit a storefront!")
      end
    end
  end

  describe "PATCH #update" do
    context "when user is logged in and is a seller" do
      context "with valid attributes" do
        it "redirects to the storefront" do
          user.create_storefront(attributes_for(:storefront))
          put :update, params: {id: user.storefront.id, storefront: {name: "New Name"}}
          expect(response).to redirect_to(storefront_path(user.storefront))
          expect(flash[:notice]).to eq("Storefront successfully updated!")
        end

        it "updates the storefront in the database" do
          user.create_storefront(attributes_for(:storefront))
          expect {
            put :update, params: {id: user.storefront.id, storefront: {name: "New Name"}}
          }.to change { Storefront.last.name }.to("New Name")
        end
      end

      context "with invalid attributes" do
        it "re-renders the edit template" do
          user.create_storefront(attributes_for(:storefront))
          put :update, params: {id: user.storefront.id, storefront: {name: nil}}
          expect(response).to render_template(:edit)
          expect(flash[:alert]).to eq("Please fix the errors below.")
        end

        it "does not update the storefront in the database" do
          user.create_storefront(attributes_for(:storefront))
          expect {
            put :update, params: {id: user.storefront.id, storefront: {name: nil}}
          }.to_not change { Storefront.last.name }
        end
      end

      context "when the storefront isn't the user's" do
        it "redirects to root" do
          user.create_storefront(attributes_for(:storefront))
          user2.create_storefront(attributes_for(:storefront))
          put :update, params: {id: user2.storefront.id, storefront: {name: "New Name"}}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You can only update your own storefront!")
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        put :update, params: {id: 0, storefront: {name: "New Name"}}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can update a storefront!"
        )
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        put :update, params: {id: 0, storefront: {name: "New Name"}}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to update a storefront!")
      end
    end
  end

  describe "GET #choose_template" do
    context "when user is logged in and is a seller" do
      it "renders choose_template when user has a storefront" do
        user.create_storefront(attributes_for(:storefront))
        get :choose_template, params: {id: user.storefront.id}
        expect(response).to render_template(:choose_template)
      end

      it "raises an error when the user doesn't have a storefront" do
        expect {
          get :choose_template, params: {id: 0}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects when the storefront isn't the user's" do
        user.create_storefront(attributes_for(:storefront))
        user2.create_storefront(attributes_for(:storefront))
        get :choose_template, params: {id: user2.storefront.id}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You can only update your own storefront!")
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :choose_template, params: {id: 0}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can choose a storefront template!"
        )
      end
    end
  end

  describe "GET #customize" do
    context "when user is logged in and is a seller" do
      it "renders choose_template when user has a storefront" do
        user.create_storefront(attributes_for(:storefront))
        get :customize, params: {id: user.storefront.id}
        expect(response).to render_template(:customize)
      end

      it "raises an error when the user doesn't have a storefront" do
        expect {
          get :customize, params: {id: 0}
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects when the storefront isn't the user's" do
        user.create_storefront(attributes_for(:storefront))
        user2.create_storefront(attributes_for(:storefront))
        get :customize, params: {id: user2.storefront.id}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You can only update your own storefront!")
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :customize, params: {id: 0}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can customize a storefront!"
        )
      end
    end
  end

  describe "GET #show" do
    before { user.create_storefront(attributes_for(:storefront)) }

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
    end

    context "when user is not logged in" do
      it "renders the show template" do
        session[:user_id] = nil
        get :show, params: {id: user.storefront.id}
        expect(response).to render_template(:show)
      end
    end

    context "when user is not a seller" do
      it "renders the show template" do
        user.update(is_seller: false)
        get :show, params: {id: user.storefront.id}
        expect(response).to render_template(:show)
      end
    end
  end

  describe "GET #preview" do
    context "when user is logged in and is a seller" do
      it "renders the preview template" do
        get :preview, params: {custom_code: "<h1>Test</h1>"}
        expect(response).to render_template(:preview)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :preview, params: {custom_code: "<h1>Test</h1>"}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can preview a storefront!"
        )
      end
    end

    context "when user is not a seller" do
      it "redirects to root" do
        user.update(is_seller: false)
        get :preview, params: {custom_code: "<h1>Test</h1>"}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to preview a storefront!")
      end
    end
  end
end
