require 'spec_helper'

describe UsersController do

  let(:current_user) { Fabricate(:user) }
  let(:another_user) { Fabricate(:user) }

  describe "GET show" do

    before { session[:user_id] = current_user.id }

    it "assigns @user" do
      get :show, id: current_user
      expect(assigns(:user)).to eq(current_user)
    end

    it "renders template :show" do
      get :show, id: current_user
      expect(response).to render_template :show
    end
  end

  describe "GET new" do

    it "assigns @user" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "renders template :new" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET new_with_invite" do
    let(:invitation) { Fabricate(:invitation) }

    context "valid token" do
      before { get :new_with_invite, token: invitation.token }

      it "assigns @user with recipient email" do
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it "render :new template" do
        expect(response).to render_template :new
      end

      it "assigns @invitation_token" do
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end
    end


    it_behaves_like "invalid token expired" do
      let(:action) { get :new_with_invite, token: "123123" }
    end
  end


  describe "POST create" do

    context "successful user registration" do

      before do
        result = double(:result, successful?: true, user: Fabricate(:user))
        UserRegistration.any_instance.should_receive(:registrate).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end

      it 'set the flash info' do
        expect(flash[:success]).to be_present
      end
    end

    context "failed user registration" do

      before do
        result = double(:result, successful?: false, error_message: "Error." )
        expect_any_instance_of(UserRegistration).to receive(:registrate).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "renders template :new" do
        expect(response).to render_template :new
      end

      it "set error message" do
        expect(flash[:warning]).to be_present
      end

    end
  end


  # describe "PUT update" do
  #
  #   let(:user) { Fabricate(:user, email: "Lawrence@example.com", full_name:"KK Smith") }
  #   before { session[:user_id] = user.id }
  #
  #   context "valid attributes" do
  #     it "locate requested @user" do
  #       put :edit, id: user
  #       expect(assigns(:user)).to eq(user)
  #     end
  #
  #     it "change @user' attributes" do
  #       put :update, id: user.slug, user: Fabricate.attributes_for(:user, email: "marisa@becker.com", full_name: "Brianne Mraz")
  #       user.reload
  #       expect(user.email).to eq("marisa@becker.com")
  #     end
  #   end
  # end
  #
end
