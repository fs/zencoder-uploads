require 'spec_helper'

describe VideosController do
  let(:video) { double('video') }

  before do
    controller.stub(:respond_with)
  end

  context "#new" do
    before do
      Video.stub(:new).and_return(video)
    end

    it "should build a video object" do
      Video.should_receive(:new)
      get :new
    end

    it "should respond with built video" do
      controller.should_receive(:respond_with).with(video)
      get :new
    end
  end

  context "#create" do
    before do
      Video.stub(:create_and_upload).and_return(video)
    end

    def send_request
      post :create, video: {a: 'b'}, format: :json
    end

    it "should create and upload a new video record" do
      Video.should_receive(:create_and_upload).with('a' => 'b')
      send_request
    end

    it "should render create template" do
      controller.should_receive(:respond_with).with(video)
      send_request
    end
  end
end

