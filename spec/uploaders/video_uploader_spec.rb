require 'spec_helper'

describe VideoUploader do
  let(:model) { double('model', id: ':id') }
  subject { VideoUploader.new(model) }

  it "returns correct store directory" do
    subject.store_dir.should == "uploads/videos/:id"
  end

  it "returns correct extension list" do
    subject.extension_white_list.should == %w[mov avi mp4]
  end
end

