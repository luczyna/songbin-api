require 'rails_helper'

#  was generated as type: :controller
RSpec.describe UserController, type: :request do
  context "creating a user" do
    it "gives us an error when we don't provide new user details" do
      post "/user"

      expect(response.body.to_json['error']).to_not be_nil
    end

    it "gives us an error when we don't provide new user name" do
      bad_user_details = { user: { "password" => "fancypants", "email" => "bana@haha.com" } }
      post "/user", params: bad_user_details

      expect(response.body.to_json['error'] => 'name').to_not be_nil
    end

    it "gives us an error when we don't provide new password" do
      bad_user_details = { user: { "name" => "bana", "email" => "bana@haha.com" } }
      post "/user", params: bad_user_details

      expect(response.body.to_json['error'] => 'password').to_not be_nil
    end

    it "gives us an error when we don't provide valid password" do
      bad_user_details = { user: { "name" => "bana", "email" => "bana@haha.com", "password" => "fancy" } }
      post "/user", params: bad_user_details

      expect(response.body.to_json['error'] => 'password').to_not be_nil
    end

    it "gives us an error when we don't provide email" do
      bad_user_details = { user: { "name" => "bana", "email" => "bana@haha.com", "password" => "fancy" } }
      post "/user", params: bad_user_details

      expect(response.body.to_json['error'] => 'email').to_not be_nil
    end

    it "returns to us a JSON Web Token on successfully creating a user" do
      okay_user_details = { user: { "name" => "bana", "email" => "bana@haha.com", "password" => "fancypants" } }
      post "/user", params: okay_user_details

      expect(response.body.to_json['auth_token']).to_not be_nil
    end

    it "gives us an error when we provide an email that's already used" do
      okay_user_details = { "name" => "bana", "email" => "bana@haha.com", "password" => "fancypants" }
      User.create(okay_user_details)

      bad_user_details = { user: { "name" => "bhana", "email" => "bana@haha.com", "password" => "fancybaji" } }
      post "/user", params: bad_user_details

      expect(response.body.to_json['error'] => 'email').to_not be_nil
    end
  end

  context "deleting a user" do
    it "works when user is authenticated" do
      user = User.new(name: "test", password: "yesyesyes", email: "yes@haha.com")
      user.save

      user_count = User.all.count

      # post "/authenticate", params: { email: user.email, password: user.password}
      token = JsonWebToken.encode({user_id: user.id})
      delete "/user", headers: { Authorization: token }
      expect(User.all.count).to equal(user_count - 1)
    end

    it "fails when token is incorrect" do
      user = User.new(name: "test", password: "yesyesyes", email: "yes@haha.com")
      user.save

      user_count = User.all.count

      token = "wrong"
      delete "/user", headers: { Authorization: token }
      expect(User.all.count).to equal(user_count)
    end

    it "fails when token belongs to a user that doesn't exist" do
      user = User.new(name: "test", password: "yesyesyes", email: "yes@haha.com")
      user.save

      # post "/authenticate", params: { email: user.email, password: user.password}
      token = JsonWebToken.encode({user_id: user.id})
      delete "/user", headers: { Authorization: token }

      # again!
      delete "/user", headers: { Authorization: token }
      expect(response.body.to_json['error']).not_to be_nil
    end
  end

  context "updating user information" do
    let(:user) { create(:user) }

    it "fails when not authenticated at all" do
      user_details = { "name" => "bana" }

      put "/user", params: user_details
      expect(response.body.to_json['error']).not_to be_nil
    end

    it "fails when not authenticated correctly" do
      user_details = { "name" => "bana" }
      incorrect_header = { Authorization: "wrong" }

      put "/user", headers: incorrect_header, params: user_details
      expect(response.body.to_json['error']).not_to be_nil
    end

    it "works when changing the password" do
      user_details = { user: { "password" => "poiuytre" } }
      header = { Authorization: JsonWebToken.encode({user_id: user.id}) }

      put "/user", headers: header, params: user_details
      expect(response.status).to equal(200)
    end

    it "works when changing the name" do
      user_details = { user: { "name" => "bana" } }
      header = { Authorization: JsonWebToken.encode({user_id: user.id}) }

      put "/user", headers: header, params: user_details
      expect(response.status).to equal(200)
    end

    it "works when changing the email" do
      user_details = { user: { "email" => "noway@haha.com" } }
      header = { Authorization: JsonWebToken.encode({user_id: user.id}) }

      put "/user", headers: header, params: user_details
      expect(response.status).to equal(200)
    end

    it "works when changing the name and email together" do
      user_details = { user: { "name" => "bana", "email" => "jk@haha.com" } }
      header = { Authorization: JsonWebToken.encode({user_id: user.id}) }

      put "/user", headers: header, params: user_details
      expect(response.status).to equal(200)
    end

    it "fails when trying to change the name, email, and password together" do
      user_details = { user: { "name" => "bana", "email" => "jk@haha.com", "password" => 'lkjlkjlkj' } }
      header = { Authorization: JsonWebToken.encode({user_id: user.id}) }

      put "/user", headers: header, params: user_details
      expect(response.status).to equal(400)
    end
  end
end
