FactoryGirl.define do
  factory :user do
    name "lana"
    email "lana@haha.com"
    password "poipoipoi"
    password_digest "MyString"
  end

  factory :user_two, class: "User" do
    name "bana"
    email "bana@haha.com"
    password "poipoipoi"
    password_digest "MyString"
  end
end
