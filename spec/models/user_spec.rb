require 'rails_helper'

RSpec.describe User, type: :model do
  context "creation" do
    it "fails without a password" do
      expect(User.new(name: "bana").valid?).to be false
    end

    it "fails without a name" do
      expect(User.new(email: "bana@haha.com").valid?).to be false
    end

    it "fails with a password that's too short" do
      user = User.new(name: "bana", password: "fancy", email: "bana@haha.com")
      expect(user.valid?).to be false
    end

    it "fails without an email address" do
      user = User.new(name: "bana", password: "fancyduds")
      expect(user.valid?).to be false
    end

    it "fails when making a user with an email address that's already used" do
      first = User.new(name: "ba", password: "12345678", email: "ba@ha.com")
      expect(first.valid?).to be true
      first.save

      second = User.new(name: "na", password: "password", email: "ba@ha.com")
      expect(second.valid?).to be false
    end

    it "succeeds when we have a name, password, and email address" do
      user = User.new(name: "bana", password: "fancyduds", email: "bana@haha.com")
      expect(user.valid?).to be true
    end
  end

  context "updating user info" do
    let(:user) {  build(:user) }

    it "succeeds when changing a name" do
      user.update(name: 'bana')
      expect(user.valid?).to be true
    end

    it "succeeds when changing an email" do
      user.update(email: 'bana@haha.com')
      expect(user.valid?).to be true
    end

    it "succeeds when updating the password" do
      user.password = 'banarama'
      expect(user.valid?).to be true
    end

    it "fails when updating with too short a password" do
      user.update(password: 'short')
      expect(user.valid?).to be false
    end
  end

  context "deleting" do
     let!(:user) { create(:user, :with_songs) }

    it "succeeds" do
      user.destroy
      expect(user.destroyed?).to be true
    end

    it "removes all associated songs" do
      # 1 User, with 4 songs already created
      # Now 2 Users, 5 songs total
      leftover_song = create(:song, user: create(:user, email: "bana@haha.com"))

      all_song_count = Song.count
      expect(all_song_count).to be > 0

      song_count = Song.where(user: user).count
      expect(song_count).to be > 0

      user.destroy
      expect(Song.all.count).to eq(all_song_count - song_count)
    end
  end
end
