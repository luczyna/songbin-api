module CreatorHelper
  def self.populate_songs(user)
    10.times do |i|
      self.create_song(user, i + 1)
    end
  end

  private
  def self.create_song(user, number)
    Song.create do |s|
      s.name = "Good Song #{number}"
      good_song = "https://www.youtube.com/watch?v=w2Sa0pUpTyA"
      s.music_url = "#{good_song}#{number}"
      s.user = user
    end
  end
end
