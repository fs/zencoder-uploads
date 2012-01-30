class VideosController < ApplicationController
  respond_to :html, :json

  def new
    @video = Video.new
    respond_with @video
  end

  def create
    @video = Video.create_and_upload(params[:video])
    respond_with @video
  end
end

