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

end
