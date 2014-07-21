require 'spec_helper'

describe CategoriesController do
  let(:action) { FactoryGirl.create(:category)}
  describe "GET show" do
    it "assigns @category" do
      get :show, id: action.id
      expect(assigns(:category)).to eq (action)
    end
    it "render show tmplate" do
      get :show, id: action.id
      expect(response).to render_template :show
    end
  end

end