require 'rails_helper'

RSpec.describe SongController, type: :request do
  context "while not authenticated" do
    it "should fail to give a list of songs" do
      get "/songs"
      expect(response.status).to eq(401)
    end

    it "should fail to give a single song" do
      get "/songs/1"
      expect(response.status).to eq(401)
    end

    it "should fail to create a new song" do
      new_song = { song: {name: 'Good Song Name', music_url: 'https://youtube.com/sdfhskdjfh'} }

      post "/songs", params: new_song
      expect(response.status).to eq(401)
    end

    it "should fail to update a song" do
      update_these = { song: {name: 'Real Good Song Name'} }

      put "/songs/1", params: update_these
      expect(response.status).to eq(401)
    end

    it "should fail to delete a song" do
      delete "/songs/1"
      expect(response.status).to eq(401)
    end
  end

  context "while authenticated" do
    context "getting songs" do
      let!(:lana) { create(:user, :with_songs, song_count: 10) }
      let!(:bana) { create(:user, email: "bana@haha.com", name: "bana") }

      it "should provide an array of songs for a user with songs" do
        auth = { Authorization: JsonWebToken.encode(user_id: lana.id)}
        get "/songs", headers: auth

        expect(json['data'].length).to eq(10)
        expect(response.status).to eq(200)
      end

      it "should provide an empty array of songs for a user with no songs" do
        auth = { Authorization: JsonWebToken.encode(user_id: bana.id)}
        get "/songs", headers: auth

        expect(json['data'].length).to eq(0)
        expect(response.status).to eq(200)
      end
    end

    context "getting a song" do
      let(:user) { create(:user) }
      let(:auth) { { Authorization: JsonWebToken.encode({user_id: user.id}) } }
      let(:song) { create(:song, user: user) }

      it "should provide a song when provided a valid id" do
        get "/songs/#{song.id}", headers: auth

        expect(response.status).to eq(200)
        expect(json['data']).not_to be_nil
      end

      it "should provide song name, id, and music_url with a valid id" do
        get "/songs/#{song.id}", headers: auth

        song_data = json['data']
        expect(response.status).to eq(200)
        expect(song_data).to have_key('name')
        expect(song_data).to have_key('id')
        expect(song_data).to have_key('music_url')
      end

      it "should fail when an invalid id is provided" do
        get "/songs/hahaha", headers: auth

        expect(json['error']).not_to be nil
        expect(response.status).to eq(404)
      end

      it "should fail when a song id belonging to another user is provided" do
        another_song = create(:song, user: create(:user, email: "jana@haha.com"))
        get "/songs/#{another_song.id}", headers: auth
        
        expect(response.status).to eq(404)
      end
    end

    context "creating a song" do
      let(:user) { create(:user) }
      let(:auth) { { Authorization: JsonWebToken.encode({user_id: user.id}) } }
      let(:song_data) { { name: "Real Good Song Name", music_url: 'https://youtube.com/lksjfslkdfj' } }
      let(:song_sender) { { song: song_data } }

      it "should fail if the request is missing the song parameter" do
        post "/songs", headers: auth, params: song_data
        expect(json['error']).not_to be_nil
      end

      it "should fail if the request is missing the song.name parameter" do
        missing_params = { song: song_data.except(:name) }
        post "/songs", headers: auth, params: missing_params

        expect(json['error']).not_to be_nil
      end

      it "should fail if the request is missing the song.music_url parameter" do
        missing_params = { song: song_data.except(:music_url) }
        post "/songs", headers: auth, params: missing_params

        expect(json['error']).not_to be_nil
      end

      it "should fail if the request has an invalid song.music_url parameter" do
        song_sender[:song][:music_url] = 'console.log'
        post "/songs", headers: auth, params: song_sender

        expect(json['error']).not_to be_nil
      end

      it "should fail if the request has a duplicated song.name parameter" do
        existing_song = create(:song, user: user)
        song_sender[:song][:name] = existing_song.name

        post "/songs", headers: auth, params: song_sender

        expect(json['error']).not_to be_nil
      end

      it "should fail if the request has a duplicated song.music_url parameter" do
        existing_song = create(:song, user: user)
        song_sender[:song][:music_url] = existing_song.music_url

        post "/songs", headers: auth, params: song_sender

        expect(json['error']).not_to be_nil
      end

      it "should succeed if the request has a valid name and music_url in the song parameter" do
        post "/songs", headers: auth, params: song_sender
        expect(response.status).to eq(201)
      end
    end

    context "updating a song" do
      let!(:user) { create(:user) }
      let!(:auth) { { Authorization: JsonWebToken.encode({user_id: user.id}) } }
      let!(:song) { create(:song, user: user) }

      it "should fail if the request is given an invalid id" do
        put "/songs/nope", headers: auth, params: { song: {name: 'nope'} }
        expect(response.status).to eq(404)
      end

      it "should fail if the request is missing the song parameter" do
        put "/songs/#{song.id}", headers: auth, params: { name: 'nope' }
        expect(response.status).to eq(400)
      end

      it "should fail if the request has a duplicated song.name parameter" do
        existing_song = create(:song, user: user)
        updates = { song: { name: existing_song.name } }
        put "/songs/#{song.id}", headers: auth, params: updates

        expect(response.status).to eq(400)
      end

      it "should fail if the request has a duplicated song.music_url parameter" do
        existing_song = create(:song, user: user)
        updates = { song: { music_url: existing_song.music_url } }
        put "/songs/#{song.id}", headers: auth, params: updates

        expect(response.status).to eq(400)
      end

      it "should succeed if the request only contains the song.name parameter" do
        updates = { song: { name: 'Fancy Pants Song' } }
        put "/songs/#{song.id}", headers: auth, params: updates

        expect(response.status).to eq(200)
      end

      it "should succeed if the request only contains the song.music_url parameter" do
        updates = { song: { music_url: 'https://youtube.com/awuroiweur' } }
        put "/songs/#{song.id}", headers: auth, params: updates

        expect(response.status).to eq(200)
      end

      it "should succeed if the request contains both song[music_url, name] parameters" do
        updates = { song: {
          name: 'Fancy Pants Song',
          music_url: 'https://youtube.com/awuroiweur'
        }}
        put "/songs/#{song.id}", headers: auth, params: updates

        expect(response.status).to eq(200)
      end

      it "should fail if the song does not belong to the authenticated user" do
        another_song = create(:song, user: create(:user, email: "jana@haha.com"))
        put "/songs/#{another_song.id}", headers: auth
        expect(response.status).to eq(404)
      end
    end

    context "deleting a song" do
      let!(:user) { create(:user) }
      let!(:user_two) { create(:user, email: "jana@haha.com") }
      let!(:auth) { { Authorization: JsonWebToken.encode({user_id: user.id}) } }
      let!(:song) { create(:song, user: user) }
      let!(:another_song) { create(:song, user: user_two) }

      it "should fail if the request is given an invalid id" do
        delete "/songs/nope", headers: auth
        expect(response.status).to eq(404)
      end

      it "should succeed if the request is provided a valid id" do
        song_count = Song.count

        delete "/songs/#{song.id}", headers: auth

        expect(response.status).to eq(200)
        expect(Song.count).to eq(song_count - 1)
      end

      it "should fail if the song does not belong to the authenticated user" do
        delete "/songs/#{another_song.id}", headers: auth
        expect(response.status).to eq(404)
      end
    end
  end
end
