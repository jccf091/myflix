require "rails_helper"

RSpec.describe Video, :type => :model do

  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it { should validate_presence_of(:large_cover_image_url)}
  it { should validate_presence_of(:small_cover_image_url)}
  it { should validate_presence_of(:category_id)}


  describe "search_by_title" do
    let(:test1) { Video.create(title: "test1_case", description: "testing1", large_cover_image_url: "url_str", small_cover_image_url: "url_str", category_id: 1, created_at: 1.day.ago )}
    let(:test2) { Video.create(title: "test2_case", description: "testing1", large_cover_image_url: "url_str", small_cover_image_url: "url_str", category_id: 1 )}

    it "should return empty array if no match" do
      expect(Video.search_by_title("hi")).to eq([])
    end
    it "should return a array of a obj if a perfect match" do
      expect(Video.search_by_title("test1_case")).to eq([test1])
    end
    it "should return a array of a obj if a partial match" do
      expect(Video.search_by_title("test1")).to eq([test1])
    end
    it "should return a array of objs in order of created_at" do
      expect(Video.search_by_title("test")).to eq([test2, test1])
    end
    it "should return empty array if input is empty str" do
      expect(Video.search_by_title("")).to eq([])
    end
  end
end