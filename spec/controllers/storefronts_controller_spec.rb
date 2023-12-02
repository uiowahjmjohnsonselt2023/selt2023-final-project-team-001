require "rails_helper"

RSpec.describe StorefrontsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:seller) { FactoryBot.create(:seller) }
  let(:seller_with_storefront) { FactoryBot.create(:seller_with_storefront) }
  let(:storefront) { seller_with_storefront.storefront }

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "renders the index template with search" do
      get :index, params: {search: "test"}
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: {id: storefront.id}
      expect(response).to render_template(:show)
    end

    it "renders the template1 template if the storefronts has custom code 1" do
      storefront.update(custom_code: "1")
      get :show, params: {id: storefront.id}
      expect(response).to render_template(:template1)
    end

    it "renders the template2 template if the storefronts has custom code 2" do
      storefront.update(custom_code: "2")
      get :show, params: {id: storefront.id}
      expect(response).to render_template(:template2)
    end
  end

  context "when user is logged in and is a seller" do
    before { login_as seller }

    context "when the user doesn't have a storefront" do
      describe "GET #new" do
        it "renders the new template" do
          get :new
          expect(response).to render_template(:new)
        end
      end

      describe "POST #create with valid attributes" do
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

      describe "POST #create with invalid attributes" do
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

      describe "GET #edit" do
        it "raises an error" do
          expect {
            get :edit, params: {id: 0}
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "PATCH #update" do
        it "raises an error" do
          expect {
            patch :update, params: {id: 0, storefront: {name: "New Name"}}
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "GET #choose_template" do
        it "raises an error" do
          expect {
            get :choose_template, params: {id: 0}
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "GET #customize" do
        it "raises an error" do
          expect {
            get :customize, params: {id: 0}
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "GET #preview" do
        it "renders the preview template" do
          get :preview, params: {custom_code: "<h1>Test</h1>"}
          expect(response).to render_template(:preview)
        end
      end
    end

    context "when the user has a storefront" do
      before { login_as seller_with_storefront }

      describe "GET #new" do
        it "redirects to the storefront" do
          get :new
          expect(response).to redirect_to(storefront_path(storefront))
          expect(flash[:alert]).to eq("You already have a storefront.")
        end
      end

      describe "POST #create" do
        it "redirects to the storefront" do
          post :create
          expect(response).to redirect_to(storefront_path(storefront))
          expect(flash[:alert]).to eq("You already have a storefront.")
        end
      end

      describe "GET #edit" do
        it "renders the edit template" do
          get :edit, params: {id: storefront.id}
          expect(response).to render_template(:edit)
        end
      end

      describe "PATCH #update with valid attributes" do
        it "redirects to the storefront" do
          patch :update, params: {id: storefront.id, storefront: {name: "New Name"}}
          expect(response).to redirect_to(storefront_path(storefront))
          expect(flash[:notice]).to eq("Storefront successfully updated!")
        end

        it "updates the storefront in the database" do
          expect {
            patch :update, params: {id: storefront.id, storefront: {name: "New Name"}}
          }.to change { Storefront.last.name }.to("New Name")
        end
      end

      describe "PATCH #update with invalid attributes" do
        it "re-renders the edit template" do
          patch :update, params: {id: storefront.id, storefront: {name: nil}}
          expect(response).to render_template(:edit)
          expect(flash[:alert]).to eq("Please fix the errors below.")
        end

        it "does not update the storefront in the database" do
          expect {
            patch :update, params: {id: storefront.id, storefront: {name: nil}}
          }.to_not change { Storefront.last.name }
        end
      end

      describe "GET #choose_template" do
        it "renders choose_template" do
          get :choose_template, params: {id: storefront.id}
          expect(response).to render_template(:choose_template)
        end
      end

      describe "GET #customize" do
        it "renders customize" do
          get :customize, params: {id: storefront.id}
          expect(response).to render_template(:customize)
        end
      end
    end

    context "when the storefront isn't the user's" do
      describe "GET #edit" do
        it "redirects to root" do
          get :edit, params: {id: storefront.id}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You can only update your own storefront!")
        end
      end

      describe "PATCH #update" do
        it "redirects to root" do
          patch :update, params: {id: storefront.id, storefront: {name: "New Name"}}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You can only update your own storefront!")
        end
      end

      describe "GET #choose_template" do
        it "redirects to root" do
          get :choose_template, params: {id: storefront.id}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You can only update your own storefront!")
        end
      end

      describe "GET #customize" do
        it "redirects to root" do
          get :customize, params: {id: storefront.id}
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You can only update your own storefront!")
        end
      end
    end
  end

  context "when user is logged in and is not a seller" do
    before { login_as user }

    describe "GET #new" do
      it "redirects to root" do
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to create a storefront!")
      end
    end

    describe "POST #create" do
      it "redirects to root" do
        post :create, params: {storefront: attributes_for(:storefront)}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to create a storefront!")
      end
    end

    describe "GET #edit" do
      it "redirects to root" do
        get :edit, params: {id: 100}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to edit a storefront!")
      end
    end

    describe "PATCH #update" do
      it "redirects to root" do
        put :update, params: {id: 0, storefront: {name: "New Name"}}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to update a storefront!")
      end
    end

    describe "GET #choose_template" do
      it "redirects to root" do
        get :choose_template, params: {id: 0}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to choose a storefront template!")
      end
    end

    describe "GET #customize" do
      it "redirects to root" do
        get :customize, params: {id: 0}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to customize a storefront!")
      end
    end

    describe "GET #preview" do
      it "redirects to root" do
        get :preview, params: {custom_code: "<h1>Test</h1>"}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be a seller to preview a storefront!")
      end
    end
  end

  context "when user is not logged in" do
    describe "GET #new" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can create a storefront!"
        )
      end
    end

    describe "POST #create" do
      it "redirects to login" do
        post :create, params: {storefront: attributes_for(:storefront)}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You need to login before you can create a storefront!")
      end
    end

    describe "GET #edit" do
      it "redirects to login" do
        get :edit, params: {id: 0}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can edit a storefront!"
        )
      end
    end

    describe "PATCH #update" do
      it "redirects to login" do
        put :update, params: {id: 0, storefront: {name: "New Name"}}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can update a storefront!"
        )
      end
    end

    describe "GET #choose_template" do
      it "redirects to login" do
        get :choose_template, params: {id: 0}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can choose a storefront template!"
        )
      end
    end

    describe "GET #customize" do
      it "redirects to login" do
        get :customize, params: {id: 0}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can customize a storefront!"
        )
      end
    end

    describe "GET #preview" do
      it "redirects to login" do
        get :preview, params: {custom_code: "<h1>Test</h1>"}
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq(
          "You need to login before you can preview a storefront!"
        )
      end
    end
  end
end
