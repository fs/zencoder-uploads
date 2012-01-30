class Video < ActiveRecord::Base
  attr_accessible :original_file
  mount_uploader :original_file, VideoUploader

  validates_presence_of :original_file

  def self.create_and_upload(attributes = {})
    Video.new(attributes).tap do |video|
      video.status = 'uploading'
      video.save && video.upload
    end
  end

  def upload
    if output = upload_to_zencoder
      self.zencoder_output_id = output['id']
      self.status = 'processing'
    else
      errors.add(:base, 'failed to upload to zencoder')
      self.status = 'failed'
    end
    save(validate: false)
  end

  private

  def upload_to_zencoder
    result = Zencoder::Job.create(
      input: original_file_url,
      output: [{
        base_url: ENV['ZENCODER_OUTPUT_URL'],
        filename: "#{id}.mp4",
        label: 'uploads',
        speed: 5,
        quality: 1
      }]
    )

    if result
      result.body['outputs'].to_a.find {|o| o['label'] == 'uploads' }
    else
      nil
    end
  end
end

