require 'spec_helper'

describe Video do
  context ".create_and_upload" do
    let(:video) { double('video', :status= => false, :save => false, :upload => false) }

    before do
      Video.stub(:new).and_return(video)
    end

    it "builds new video" do
      Video.should_receive(:new).with(a: 'b')
      Video.create_and_upload(a: 'b')
    end

    it "changes status to uploading" do
      video.should_receive(:status=).with('uploading')
      Video.create_and_upload
    end

    it "saves built video" do
      video.should_receive(:save)
      Video.create_and_upload
    end

    it "uploads video file to zencoder if saved successfully" do
      video.stub(:save).and_return(true)
      video.should_receive(:upload)
      Video.create_and_upload
    end

    it "doesn't upload video file to zencoder if failed to save" do
      video.stub(:save).and_return(false)
      video.should_not_receive(:upload)
      Video.create_and_upload
    end

    it "returns built video" do
      Video.create_and_upload.should == video
    end
  end

  context "#upload" do
    let(:body_hash) { {'outputs' => [{'id' => ':id', 'label' => 'uploads'}]} }
    let(:result) { double('response', body: body_hash) }

    before do
      Zencoder::Job.stub(:create).and_return(result)
      subject.stub(:save)
    end

    it "creates a new zencoder job" do
      Zencoder::Job.should_receive(:create)
      subject.upload
    end

    it "uploads to zencoder" do
      subject.should_receive(:upload_to_zencoder)
      subject.upload
    end

    context "successful upload" do
      before { Zencoder::Job.stub(:create).and_return(result) }

      it "sets output id" do
        subject.should_receive(:zencoder_output_id=).with(':id')
        subject.upload
      end

      it "updates the status" do
        subject.should_receive(:status=).with('processing')
        subject.upload
      end
    end

    context "failed upload" do
      before { Zencoder::Job.stub(:create).and_return(nil) }

      it "updates the status" do
        subject.should_receive(:status=).with('failed')
        subject.upload
      end
    end

    it "saves the record" do
      subject.should_receive(:save)
      subject.upload
    end
  end
end

