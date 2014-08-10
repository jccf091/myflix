require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do

    it_behaves_like "requires admin sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "assigns @video" do
      set_admin_user
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end

    it "renders template :new" do
      set_admin_user
      get :new
      expect(response).to render_template :new
    end

  end

  describe "POST create" do

    it_behaves_like "requires admin sign in" do
      let(:action) { get :create, video: Fabricate.attributes_for(:video) }
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    context "when input is valid" do

      before do
        set_admin_user
        post :create, video: Fabricate.attributes_for(:video)
      end

      it "creates a video record" do
        expect{
          post :create, video: Fabricate.attributes_for(:video)
        }.to change(Video, :count).by(1)
      end

      it "redirect to new_admin_video path" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "sets flash message" do
        expect(flash[:success]).to be_present
      end
    end

    context "when input is invalid" do

      before { set_admin_user }

      it 'do not create a video record' do
        expect{
          post :create, video: Fabricate.attributes_for(:video, category: nil)
        }.not_to change(Video, :count)
      end

      it 'renders a template :new' do
        post :create, video: Fabricate.attributes_for(:video, category: nil)
        expect(response).to render_template :new
      end
    end

  end


end
