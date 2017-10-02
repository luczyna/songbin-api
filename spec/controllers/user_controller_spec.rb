require 'rails_helper'

#  was generated as type: :controller
RSpec.describe UserController, type: :request do
  context "creating a user" do
    it "gives us an error when we don't provide new user details" do
      post "/create-user"

      expect(response.body.to_json['error']).to_not be_nil
    end

    it "gives us an error when we don't provide new user name" do
      bad_user_details = { "password" => "fancypants", "email" => "bana@haha.com" }
      post "/create-user", params: bad_user_details

      expect(response.body.to_json['error'] => 'name').to_not be_nil
    end

    it "gives us an error when we don't provide new password" do
      bad_user_details = { "name" => "bana", "email" => "bana@haha.com" }
      post "/create-user", params: bad_user_details

      expect(response.body.to_json['error'] => 'password').to_not be_nil
    end

    it "gives us an error when we don't provide valid password" do
      bad_user_details = { "name" => "bana", "email" => "bana@haha.com", "password" => "fancy" }
      post "/create-user", params: bad_user_details

      expect(response.body.to_json['error'] => 'password').to_not be_nil
    end

    it "gives us an error when we don't provide email" do
      bad_user_details = { "name" => "bana", "email" => "bana@haha.com", "password" => "fancy" }
      post "/create-user", params: bad_user_details

      expect(response.body.to_json['error'] => 'email').to_not be_nil
    end

    it "returns to us a JSON Web Token on successfully creating a user" do
      okay_user_details = { "name" => "bana", "email" => "bana@haha.com", "password" => "fancypants" }
      post "/create-user", params: okay_user_details

      expect(response.body.auth_token).to_not be_nil
    end

    it "gives us an error when we provide an email that's already used" do
      okay_user_details = { "name" => "bana", "email" => "bana@haha.com", "password" => "fancypants" }
      User.create(okay_user_details)

      bad_user_details = { "name" => "bhana", "email" => "bana@haha.com", "password" => "fancybaji" }
      post "/create-user", params: bad_user_details

      expect(response.body.to_json['error'] => 'email').to_not be_nil
    end
  end
end
