require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive  }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password) }
  it { should validate_presence_of(:password_confirmation) }
  it { should ensure_length_of(:password_confirmation ) }
  it { should have_secure_password }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order("ranking") }
  it { should have_many(:relationships) }
  it { should have_many(:followed_users) }
  it { should have_many(:reverse_relationships) }
  it { should have_many(:followers) }
  it { should have_many(:invitations)}

  let(:current_user) { Fabricate(:user) }
  let(:another_user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }

  it_behaves_like "tokenify" do
    let(:object) { current_user }
  end

  it "set admin false as default" do
    expect(Fabricate(:user).admin?).to be false
  end

  it "user can be set as admin" do
    expect(Fabricate(:user).toggle!(:admin)).to be true
  end
  describe "#queued?(video)" do

    it "returns true when user queued the video" do
      Fabricate(:queue_item, creator: current_user, video: video)
      current_user.queued?(video).should be true
    end
    it "returns false when user has not queued the video" do
      current_user.queued?(video).should be false
    end
  end

  describe "#follow(another_user)" do

    it "follow another_user" do
      current_user.follow(another_user)
      expect(current_user.followed_users.last).to eq(another_user)
    end
  end

  describe "#following?(another_user_id)" do
    it "return true if user is following another_user" do
      Fabricate(:relationship, follower: current_user, followed: another_user)
      expect(current_user.following?(another_user)).to be true
    end

    it "return false if user is not following another_user" do
      expect(current_user.following?(another_user)).to be false
    end
  end

  describe "#lock!" do
    it "lock a user" do
      current_user.lock!
      expect(current_user).to be_lock
    end
  end

  describe "#unlock!" do
    it "unlock a user" do
      user = Fabricate(:user, lock: true)
      user.unlock!
      expect(user).not_to be_lock
    end
  end
end
