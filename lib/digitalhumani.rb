# frozen_string_literal: true

require "json"
require "faraday"
require_relative "digitalhumani/version"

module DigitalHumani
  class Error < StandardError; end

  class SDK
    # Allow enterprise_id to be read, written
    attr_accessor :enterprise_id

    # Initilaize instance w/ API key, environment, and optionally enterpriseId
    def initialize(&block)
      instance_eval(&block)

      # Validate api_key, environment inputs
      if !@api_key or @api_key === ""
        raise "Error: @api_key parameter required"
      end
      if !@environment or !["production","sandbox","local"].include?(@environment)
        raise "Error: @environment parameter required and must be one of 'production','sandbox'"
      end

      # Set API base url based on environment
      case @environment
        when "production"
          @url = "https://api.digitalhumani.com/"
        when "sandbox"
          @url = "https://api.sandbox.digitalhumani.com"
        when "local"
          @url = "http://localhost:3000"
        end
    end

    # Get enterprise by ID
    def enterprise(enterprise_id: @enterprise_id)
      if !enterprise_id
        raise "Error: `enterprise_id` not set"
      end 

      request(http_method: :get, endpoint: "/enterprise/#{enterprise_id}")
    end

    # Get list of all projects
    def projects()
      request(endpoint: "/project", http_method: :get)
    end

    # Get project by ID
    def project(project_id:)
      if !project_id
        raise "Error: `project_id` parameter required"
      end 

      request(endpoint: "/project/#{project_id}", http_method: :get)
    end

    # Plant tree
    def plant_tree(enterprise_id: @enterprise_id, project_id:, user:, treeCount: 1)
      if !enterprise_id
        raise "Error: `enterprise_id` not set"
      end 
      if !project_id
        raise "Error: `project_id` parameter required"
      end 

      request(endpoint: "/tree", http_method: :post, params: {
        enterpriseId: enterprise_id,
        projectId: project_id,
        user: user,
        treeCount: treeCount
      })
    end

    # Get tree by UUID
    def tree(uuid:)
      if !uuid
        raise "Error: `uuid` parameter required"
      end 
      request(endpoint: "/tree/#{uuid}", http_method: :get)
    end

    # Get tree count for enterprise - for date range, month, or user
    def tree_count(enterprise_id: @enterprise_id, start_date: "", end_date: "", month: "", user: "")
      if !enterprise_id
        raise "Error: `enterprise_id` not set"
      end 

      if start_date and start_date != ""
        if end_date and end_date != ""
          # Request tree count over date range
          request(http_method: :get, endpoint: "/enterprise/#{enterprise_id}/treeCount", params: {
            startDate: start_date,
            endDate: end_date
          })
        else
          raise "Error: Both `start_date` and `end_date` parameters required"
        end
      elsif month and month != ""
        # Request tree count for month
        request(http_method: :get, endpoint: "/enterprise/#{enterprise_id}/treeCount/#{month}")
      elsif user and user != ""
        # Request tree count for user
        request(http_method: :get, endpoint: "/tree", params: {
          enterpriseId: enterprise_id,
          user: user
        })
      else
        raise "Error: invalid parameters. Must specify `start_date`/`end_date`, `month`, or `user`"
      end
    end

    private
    
    # Initialize Faraday connection
    def client
      @_client ||= Faraday.new(@url) do |client|
        client.request :url_encoded
        client.headers["X-API-KEY"] = @api_key if @api_key
        client.headers["Content-Type"] = "application/json"
        client.headers["User-Agent"] = "Digital Humani Ruby SDK"
      end
    end

    # Send request via Faraday connection object, return JSON-parse response body
    def request(http_method:, endpoint:, params: {})
      params = JSON.generate(params) if !params.empty? and http_method != :get
      response = client.public_send(http_method, endpoint, params)
      
      if response.status === 200
        return JSON.parse(response.body)
      elsif response.status === 401 or response.status === 403
        raise response.status.to_s + " " + response.body
      else
        if response.headers.include?("content-type") and response.headers["content-type"].start_with?("application/json")
          json = JSON.parse(response.body)
          raise response.status.to_s + " | " + json['message']
        else 
          raise response.status.to_s + " | " + response.body
        end
      end
    end

  end
end
