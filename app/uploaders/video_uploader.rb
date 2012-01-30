class VideoUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "uploads/videos/#{model.id}"
  end

  def extension_white_list
    %w[mov avi mp4]
  end
end

