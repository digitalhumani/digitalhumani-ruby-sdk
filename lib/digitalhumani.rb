# frozen_string_literal: true

require "json"
require "faraday"
require_relative "digitalhumani/version"

module DigitalHumani
  class Error < StandardError; end

  class SDK
    # Allow enterprise_id to be read, written
    attr_accessor :enterprise_id

    # Specify key, environment (w/ default "production"), enterpriseId (w/ "" default)
    def initialize(api_key:, environment: "production", enterprise_id: nil)
      # Validation
        # api_key required
        # environment must be "production" or "sandbox"

      @api_key = api_key
      @environment = environment
      @enterprise_id = enterprise_id if enterprise_id

      # Define API base url based on specified environment
      case environment
      when "production"
        @url = "https://api.digitalhumani.com/"
      when "sandbox"
        @url = "https://api.sandbox.digitalhumani.com"
      end
    end


    # Get enterprise by ID
    def enterprise(enterprise_id: @enterprise_id)
      # Validation - enterprise_id required
      request(http_method: :get, endpoint: "/enterprise/#{enterprise_id}")
    end

    # For an enterprise resource ...
      # get tree count for enterprise
        # w/ date range parameters
        # w/ month date parameters

    # Get list of all projects
    def projects()
      request(endpoint: "/project", http_method: :get)
    end

    # Get project by ID
    def project(project_id:)
      # Validation - project_id required
      request(endpoint: "/project/#{project_id}", http_method: :get)
    end

    # Plant tree
    def plantTree(enterprise_id: @enterprise_id, project_id:, user:, treeCount: 1)
      # Validation - enterprise_id, project_id required
      request(endpoint: "/tree", http_method: :post, params: {
        enterpriseId: enterprise_id,
        projectId: project_id,
        user: user,
        treeCount: treeCount
      })
    end

    # Get tree by UUID
    def getTree(uuid:)
      # Validation - uuid required
      request(endpoint: "/tree/#{uuid}", http_method: :get)
    end

    # Get trees planted by user
    # def countTreesPlantedByUser()

    private
    
    # Initialize Faraday connection
    def client
      @_client ||= Faraday.new(@url) do |client|
        client.request :url_encoded
        client.headers["X-API-KEY"] = @api_key if @api_key
        client.headers["Content-Type"] = "application/json"
      end
    end

    # Send request via Faraday connection object, return JSON-parse response body
    def request(http_method:, endpoint:, params: {})
      params = JSON.generate(params) if !params.empty?
      response = client.public_send(http_method, endpoint, params)
      JSON.parse(response.body)
    end

  end
end
