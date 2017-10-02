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

  # TODO create and test logging in
  # context "logging in" do
  # end

  # TODO create and test updating user info
  # context "updating user info" do
  # end

  # TODO create and test deleting
  # context "deleting" do
  # end
end
