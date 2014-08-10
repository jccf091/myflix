require 'spec_helper'

describe VideosController do

  let(:current_user) { Fabricate(:user) }
  before { session[:user_id] = current_user.id }

  describe "GET index" do
    let(:cat) { Fabricate(:category) }
    before { get :index }

    it "assigns @categories" do
      expect(assigns(:categories)).to eq([cat])
    end

    it "renders template :index" do
      expect(response).to render_template :index
    end

  end

  describe "GET show" do
    let(:video) {Fabricate(:video)}
    let(:review1) { Fabricate(:review, video: video) }
    let(:review2) { Fabricate(:review, video: video) }
    before { get :show, id: video.token }

    it "assigns @video" do
      expect(assigns(:video)).to eq(video)
    end

    it "assigns @reviews" do
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "renders template :show" do
      expect(response).to render_template :show
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end
end
