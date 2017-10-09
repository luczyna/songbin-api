class SongController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Sorry, we can't find that song." }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do
    render json: {
      error: "Malformed request! Please refer to the documentation and try again"
    }, :status => :bad_request
  end

  def show
    song = Song.select(:name, :music_url, :id).where(id: params[:id], user: @current_user).first

    if song.present?
      render json: { data: song }, status: :ok
    else
      render json: { error: "Sorry, we can't find that song." }, status: :not_found
    end
  end

  def index
    songs = Song.select(:name, :music_url, :id).where(user: @current_user)
    render json: { data: songs }, status: :ok
  end

  def create
    song = Song.new(song_params)
    song.user = @current_user

    if song.save
      render json: { ok: true }, status: :created
    else
      render json: { error: song.errors }, status: :bad_request
    end
  end

  def update
    song = Song.where(id: params[:id], user: @current_user).first

    if song.blank?
      render json: { error: "Sorry, we can't find that song." }, status: :not_found
    elsif song.update_attributes song_params
      render json: { ok: true }, status: :ok
    else
      render json: { error: song.errors }, status: :bad_request
    end
  end

  def destroy
    song = Song.where(id: params[:id], user: @current_user).first

    if song.blank?
      render json: { error: "Sorry, we can't find that song." }, status: :not_found
    elsif song.destroy
      render json: { ok: true }, status: :ok
    else
      render json: { error: song.errors }, status: :bad_request
    end
  end

  private

  def song_params
    params.require(:song).permit(:name, :music_url)
  end
end
