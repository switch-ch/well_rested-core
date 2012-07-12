require 'well_rested/api'

module WellRested
  # All REST requests are made through an API object.
  # API objects store cross-resource settings such as user and password (for HTTP basic auth).
  class CAPI < WellRested::API
    include WellRested  # for logger
    include WellRested::Utils

    attr_accessor :user
    attr_accessor :password
    attr_accessor :default_path_parameters
    attr_accessor :client
    attr_reader   :last_response
    attr_accessor :unique_id
    attr_accessor :version

    def initialize(path_params = {}, session_params = {}, version = "")
      self.default_path_parameters = path_params.with_indifferent_access
      self.client = RestClient
      self.unique_id = session_params.try(:uid) || 'unauthorized'
      self.version = version
    end

    # Convenience method. Also allows request_headers to be can be set on a per-instance basis.
    def request_headers
      self.class.request_headers(self.unique_id, self.version)
    end

    # Return the default headers sent with all HTTP requests.
    def self.request_headers(unique_id, version)
      # Accept necessary for fetching results by result ID, but not in most places.
      {
        :content_type => 'application/json',
        :accept => 'application/json',
        "Authentication" => unique_id,
        :version => version
      }
    end


    protected  # internal methods follow

    # Create or update a resource.
    # If an ID is set, PUT will be used, else POST.
    # If a 200 is returned, the returned attributes will be loaded into the resource, and the resource returned.
    # Otherwise, the resource will not be modified, and a hash generated from the JSON response will be returned.
    def create_or_update_resource(resource, url = nil)
      return false unless resource.valid?

      #logger.info "Creating a #{resource.class}"

      path_params = default_path_parameters.merge(resource.path_parameters)
      payload_hash = resource.class.attribute_formatter.encode(resource.attributes_for_api)
      payload = resource.class.body_formatter.encode(payload_hash)

      #logger.debug " payload: #{payload.inspect}"

      if url.nil?
        url = url_for(resource.class, path_params)  # allow default URL to be overriden by url argument
      else
        url = url_for(resource.class, url)
      end

      # Ask the resource if it is new, then POST, otherwise PUT
      method = resource.new? ? :post : :put
      # If ID is set in path parameters, do a PUT. Otherwise, do a POST.
      # method = resource.path_parameters[:key].blank? ? :post : :put

      response = run_update(method, url, payload)

      hash = resource.class.body_formatter.decode(response.body)
      decoded_hash = resource.class.attribute_formatter.decode(hash)
      logger.info "* Errors: #{decoded_hash['errors'].inspect}" if decoded_hash.include?('errors')

      if response.code.between?(200,299)
        # If save succeeds, replace resource's attributes with the ones returned.
        return decoded_hash.map { |hash| resource.class.new_from_api(hash) } if decoded_hash.kind_of?(Array)
        resource.load_from_api(decoded_hash)
        return resource
      elsif decoded_hash.include?('errors')
        resource.handle_errors(decoded_hash['errors'])
        return false
      end
    end
  end
end
