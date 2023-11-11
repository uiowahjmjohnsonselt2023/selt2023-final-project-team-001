require "rails_helper"

describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:seller) { create(:seller) }
  let(:product) { create(:product) }

  context "when not logged in" do
    describe "GET #show" do
      context "when the product is public" do
        it "renders the show template" do
          get :show, params: {id: product.id}
          expect(response).to render_template :show
        end
      end

      context "when the product is private" do
        it "redirects to the login page" do
          product = create(:product, private: true)
          get :show, params: {id: product.id}
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "GET #new" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to login_path
      end
    end

    describe "POST #create" do
      it "redirects to the login page" do
        post :create, params: {product: attributes_for(:product_without_seller)}
        expect(response).to redirect_to login_path
      end
    end

    describe "GET #edit" do
      it "redirects to the login page" do
        get :edit, params: {id: product.id}
        expect(response).to redirect_to login_path
      end
    end

    describe "PUT #update" do
      it "redirects to the login page" do
        put :update, params: {id: product.id, product: {name: "New Name"}}
        expect(response).to redirect_to login_path
      end
    end
  end

  context "when logged in as a non-seller" do
    before { login_as user }

    describe "GET #show" do
      context "when the product is public" do
        it "renders the show template" do
          get :show, params: {id: product.id}
          expect(response).to render_template :show
        end
      end

      context "when the product is private" do
        it "redirects to the home page" do
          product = create(:product, private: true)
          get :show, params: {id: product.id}
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "GET #new" do
      it "redirects to the home page" do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe "POST #create" do
      it "redirects to the home page" do
        post :create, params: {product: attributes_for(:product_without_seller)}
        expect(response).to redirect_to root_path
      end
    end

    describe "GET #edit" do
      it "redirects to the home page" do
        get :edit, params: {id: product.id}
        expect(response).to redirect_to root_path
      end
    end

    describe "PUT #update" do
      it "redirects to the home page" do
        put :update, params: {id: product.id, product: {name: "New Name"}}
        expect(response).to redirect_to root_path
      end
    end
  end

  context "when logged in as a seller" do
    before { login_as seller }

    describe "GET #show" do
      context "when the product is public" do
        it "renders the show template" do
          get :show, params: {id: product.id}
          expect(response).to render_template :show
        end
      end

      context "when the product is private" do
        context "when the seller is the product's seller" do
          it "renders the show template" do
            product = create(:product, private: true, seller: seller)
            get :show, params: {id: product.id}
            expect(response).to render_template :show
          end
        end

        context "when the seller is not the product's seller" do
          it "redirects to the home page" do
            product = create(:product, private: true)
            get :show, params: {id: product.id}
            expect(response).to redirect_to root_path
          end
        end
      end
    end

    describe "GET #new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "saves the new product in the database" do
          expect {
            post :create, params: {product: attributes_for(:product_without_seller)}
          }.to change(Product, :count).by(1)
        end

        it "redirects to the home page" do
          post :create, params: {product: attributes_for(:product_without_seller)}
          expect(response).to redirect_to product_path(Product.last)
        end
      end

      context "with invalid attributes" do
        it "does not save the new product in the database" do
          expect {
            post :create, params: {product: attributes_for(:product, price: -1)}
          }.to_not change(Product, :count)
        end

        it "re-renders the :new template" do
          post :create, params: {product: attributes_for(:product, price: -1)}
          expect(response).to render_template :new
        end
      end
    end

    describe "GET #edit" do
      context "when the seller is the product's seller" do
        it "renders the edit template" do
          product = create(:product, seller: seller)
          get :edit, params: {id: product.id}
          expect(response).to render_template :edit
        end
      end

      context "when the seller is not the product's seller" do
        it "redirects to the home page" do
          product = create(:product)
          get :edit, params: {id: product.id}
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "PUT #update" do
      context "when the seller is the product's seller" do
        context "with valid attributes" do
          it "updates the product in the database" do
            product = create(:product, seller: seller)
            put :update, params: {id: product.id, product: {name: "New Name"}}
            product.reload
            expect(product.name).to eq("New Name")
          end
        end
      end

      context "when the seller is not the product's seller" do
        it "redirects to the home page" do
          product = create(:product)
          put :update, params: {id: product.id, product: {name: "New Name"}}
          expect(response).to redirect_to root_path
        end
      end

      context "with invalid attributes" do
        it "does not update the product in the database" do
          product = create(:product, seller: seller)
          put :update, params: {id: product.id, product: {price: -1}}
          product.reload
          expect(product.name).to_not eq("New Name")
        end

        it "re-renders the edit template" do
          product = create(:product, seller: seller)
          put :update, params: {id: product.id, product: {price: -1}}
          expect(response).to render_template :edit
        end
      end
    end
  end
end
