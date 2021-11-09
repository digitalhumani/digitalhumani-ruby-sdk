# frozen_string_literal: true

RSpec.describe DigitalHumani do
  it "has a version number" do
    expect(DigitalHumani::VERSION).not_to be nil
  end

  describe "Configure SDK" do
    it "should initialize successfully" do
      dh = DigitalHumani::SDK.new do
        @api_key = "$API_KEY"
        @environment = "production"
      end
      expect(dh).to be_a DigitalHumani::SDK
    end

    it "should require api_key on init" do
      expect {
        dh = DigitalHumani::SDK.new do
            @environment = "production"
            @enterprise_id = "$ENTERPRISE_ID"
        end
      }.to raise_error(RuntimeError)
    end

    it "should require enviornment on init" do
      expect {
        dh = DigitalHumani::SDK.new do
            @api_key = "$API_KEY"
            @enterprise_id = "$ENTERPRISE_ID"
        end
      }.to raise_error(RuntimeError)
    end
  end

  describe "DigitalHumani API (mocked)" do
    before(:each) do
      @dh = DigitalHumani::SDK.new do
        @api_key = "$API_KEY"
        @environment = "sandbox"
        @enterprise_id = "$ENTERPRISE_ID"
      end
      # Stub external network requests
      stub_request(:any, /api.sandbox.digitalhumani.com/).
        with(headers: {'Content-Type'=>'application/json', 'X-API-KEY'=>'$API_KEY'}).
        to_return(status: 200, body: '{ "response": true }', headers: {})
    end

    it "plant a tree" do
      tree = @dh.plant_tree(project_id: '81818181', user: 'test@example.com', treeCount: 2)
      expect(tree).to be_an_instance_of(Hash)
    end

    it "fetch a tree" do
      tree = @dh.tree(uuid: '$TREE_UUID')
      expect(tree).to be_an_instance_of(Hash)
    end 

    it "fetch an enterprise" do
      enterprise = @dh.enterprise()
      expect(enterprise).to be_an_instance_of(Hash)
    end

    it "fetch a project" do
      project = @dh.project(project_id: '81818181')
      expect(project).to be_an_instance_of(Hash)
    end
  end

  describe "DigitalHumani API | Error handling" do
    before(:each) do
      @dh = DigitalHumani::SDK.new do
        @api_key = "$API_KEY"
        @environment = "sandbox"
        @enterprise_id = "$ENTERPRISE_ID"
      end
    end

    it "handles 400" do
      # Stub network request with 400 error
      stub_request(:any, /api.sandbox.digitalhumani.com/).
        with(headers: {'Content-Type'=>'application/json', 'X-API-KEY'=>'$API_KEY'}).
        to_return(status: 400, body: '{ "message": "Test Error" }', headers: {
          "content-type": "application/json"
        })

      expect{
        project = @dh.project(project_id: 'invalid')
      }.to raise_error(RuntimeError, "400 | Test Error")
    end

    it "handles 401" do
      # Stub network request with 400 error
      stub_request(:any, /api.sandbox.digitalhumani.com/).
        with(headers: {'Content-Type'=>'application/json', 'X-API-KEY'=>'$API_KEY'}).
        to_return(status: 401, body: 'Unauthorized', headers: {
          "content-type": "application/json"
        })

      expect{
        project = @dh.project(project_id: 'invalid')
      }.to raise_error(RuntimeError, "401 Unauthorized")
    end

    it "handles 403" do
      # Stub network request with 400 error
      stub_request(:any, /api.sandbox.digitalhumani.com/).
        with(headers: {'Content-Type'=>'application/json', 'X-API-KEY'=>'$API_KEY'}).
        to_return(status: 403, body: 'Forbidden', headers: {
          "content-type": "application/json"
        })

      expect{
        project = @dh.project(project_id: 'invalid')
      }.to raise_error(RuntimeError, "403 Forbidden")
    end
    
    it "handles 404" do
      # Stub network request with 400 error
      stub_request(:any, /api.sandbox.digitalhumani.com/).
        with(headers: {'Content-Type'=>'application/json', 'X-API-KEY'=>'$API_KEY'}).
        to_return(status: 404, body: '{ "message": "Test Error" }', headers: {
          "content-type": "application/json"
        })

      expect{
        project = @dh.project(project_id: 'invalid')
      }.to raise_error(RuntimeError, "404 | Test Error")
    end

    it "handles 500" do
      # Stub network request with 400 error
      stub_request(:any, /api.sandbox.digitalhumani.com/).
        with(headers: {'Content-Type'=>'application/json', 'X-API-KEY'=>'$API_KEY'}).
        to_return(status: 500, body: '{ "message": "Test Error" }', headers: {
          "content-type": "application/json"
        })

      expect{
        project = @dh.project(project_id: 'invalid')
      }.to raise_error(RuntimeError, "500 | Test Error")
    end
  end
end
