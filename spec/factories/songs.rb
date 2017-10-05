FactoryGirl.define do
  sequence :song_name do |n|
    "good song #{n}"
  end

  sequence :song_music_url do |m|
    "https://www.youtube.com/watch?v=77qAgl1SCPk#{m}"
  end

  factory :song do
    name { generate(:song_name) }
    music_url { generate(:song_music_url) }
    user
  end
end
