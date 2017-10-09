require 'rails_helper'

RSpec.describe Song, type: :model do
  context "creation" do
    let(:user) { build(:user) }
    let(:user_two) { build(:user, name: "bana", email: "bana@haha.com") }
    let(:good_url) { "https://www.youtube.com/watch?v=AcQnxa3rT4g" }
    let(:bad_url) { "console.log" }

    it "fails when the name is missing" do
      song = Song.new(music_url: good_url, user: user)
      expect(song).not_to be_valid
    end

    it "fails when the url is missing" do
      song = Song.new(name: 'good song', user: user)
      expect(song).not_to be_valid
    end

    it "fails when the url is invalid" do
      song = Song.new(name: 'good song', music_url: bad_url, user: user)
      expect(song).not_to be_valid
    end

    it "fails when not associated with a user" do
      song = Song.new(name: 'good song', music_url: good_url)
      expect(song).not_to be_valid
    end

    it "works when there is a name, a valid url, and a user" do
      song = Song.new(name: 'good song', user: user, music_url: good_url)
      expect(song).to be_valid
    end

    it "fails when the name is not unique to the songs of the user" do
      song = Song.create(name: 'good song', user: user, music_url: good_url)

      second = Song.new(name: 'good song', user: user, music_url: good_url.chop)
      expect(second).not_to be_valid
    end

    it "fails when the url is not unique to the songs of the user" do
      song = Song.create(name: 'good song', user: user, music_url: good_url)

      second = Song.new(name: 'great song', user: user, music_url: good_url)
      expect(second).not_to be_valid
    end

    it "works when the name is also used in a song belonging to another user" do
      song = Song.create(name: 'good song', user: user, music_url: good_url)

      second = Song.new(name: 'good song', user: user_two, music_url: good_url.chop)
      expect(second).to be_valid
    end

    it "works when the url is also used in a song belonging to another user" do
      song = Song.create(name: 'good song', user: user, music_url: good_url)

      second = Song.new(name: 'great song', user: user_two, music_url: good_url)
      expect(second).to be_valid
    end
  end
end
