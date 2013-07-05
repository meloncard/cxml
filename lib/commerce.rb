# The Commerce module is used for quickly building documents and dispatching inbound requests
module Commerce
    
  # Define errors
  module CommerceError
    class CommerceError < StandardError; end
    class UnableToProcessError < CommerceError; end
    class InvalidRequestError < CommerceError; end
  end

  # Block object used for binding in dispatch blocks
  class BlockObject
    def initialize
      @procs = {}
    end

    def procs
      @procs
    end

    def method_missing(method, *args, &block)
      raise CommerceError::CommerceError, "Missing dispatch block" unless block_given?

      @procs[method.to_sym] = block
    end
  end

  # Response used for status-responses
  # TODO: Move to cxml/documents
  class Response
    def self.success
      d = CXML::Document.new('Response' => { 'Status' => { 'code' => 200, 'text' => 'OK' } } )
      d.setup
      d.render
    end

    def self.failure(message)
      # TODO: Get failure up to specs
      d = CXML::Document.new('Response' => { 'Status' => { 'code' => 400, 'text' => message } } )
      d.setup
      d.render
    end
  end

  # Dispatch can be used to handle incoming cXML requests
  # 
  # E.g.
  # Commerce.dispatch(request.raw_post) do
  #   order_request do |order_request|
  #     # Process order request
  #     render xml: Commerce::Response.success
  #   end
  # end
  def self.dispatch(xml, &block)
    raise CommerceError::CommerceError, "Missing xml" if xml.blank?
    raise CommerceError::CommerceError, "Missing dispatch block" unless block_given?

    cxml = CXML.parse(xml)
    request = cxml['Request']

    raise CommerceError::InvalidRequestError, "No request element" if request.nil?
    
    deployment_mode = request.delete('deploymentMode')
    id = request.delete('Id')

    raise CommerceError::InvalidRequestError, "Invalid request object: #{request}" if request.keys.count != 1

    request_type, request_item = request.first

    Commerce.debug [ 'Commerce::Dispatch', 'Received request item', request_type, request_item ]
    
    block_object = Commerce::BlockObject.new
    block_object.instance_eval(&block)
    
    processor = block_object.procs[request_type.underscore.to_sym]
    
    raise CommerceError::CommerceError, "Missing handler for #{request_type.underscore}" unless processor
    
    obj = block.binding.eval("self") # Grab self of caller
    obj.instance_exec(request_item, &processor)
  end

  # Send debug messages
  def self.debug(*args)
    if defined?(Rails)
      Rails.logger.debug *args if Rails.logger
      p *args if Rails.env && Rails.env.development?
    end
  end
end