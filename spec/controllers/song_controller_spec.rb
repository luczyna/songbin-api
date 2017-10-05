require 'rails_helper'

RSpec.describe SongController, type: :controller do
  context "while not authenticated" do
    it "should fail to give a list of songs"
    it "should fail to give a single song"
    it "should fail to create a new song"
    it "should fail to update a song"
    it "should fail to delete a song"
  end

  context "while authenticated" do
    context "getting songs" do
      it "should provide an array of songs for a user with songs"
      it "should provide an empty array of songs for a user with no songs"
    end

    context "getting a song" do
      it "should provide a song when provided a valid id"
      it "should fail when no id is provided"
      it "should fail when an invalid id is provided"
    end

    context "creating a song" do
      it "should fail if the request is missing the song parameter"
      it "should fail if the request is missing the song.name parameter"
      it "should fail if the request is missing the song.music_url parameter"
      it "should fail if the request has a duplicated song.name parameter"
      it "should fail if the request has a duplicated song.music_url parameter"
      it "should succeed if the request has a valid name and music_url in the song parameter"
    end

    context "updating a song" do
      it "should fail if the request is missing an id"
      it "should fail if the request is given an invalid id"
      it "should fail if the request is missing the song parameter"
      it "should fail if the request has a duplicated song.name parameter"
      it "should fail if the request has a duplicated song.music_url parameter"
      it "should succeed if the request only contains the song.name parameter"
      it "should succeed if the request only contains the song.music_url parameter"
      it "should succeed if the request contains both song[music_url, name] parameters"
    end

    context "deleting a song" do
      it "should fail if the request is missing an id"
      it "should fail if the request is given an invalid id"
      it "should succeed if the request is provided a valid id"
    end
  end
end
