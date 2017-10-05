FactoryGirl.define do
  factory :user do
    name "lana"
    email "lana@haha.com"
    password "poipoipoi"
    password_digest "MyString"

    trait :with_songs do
      transient do
        song_count 4
      end

      after(:create) do |user, evaluator|
        create_list(:song, evaluator.song_count, user: user)
      end
    end
  end

  factory :user_two, class: "User" do
    name "bana"
    email "bana@haha.com"
    password "poipoipoi"
    password_digest "MyString"
  end
end
