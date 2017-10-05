FactoryGirl.define do
  factory :song do
    name "good song"
    # you're welcome
    music_url "https://www.youtube.com/watch?v=77qAgl1SCPk"

    # I believe this is clearer
    # association :user, factory: :user
    user
  end
end
