# Clients send requests for operations. Only one Request element is allowed for each 
# cXML envelope element, which simplifies the server implementations, because no 
# demultiplexing needs to occur when reading cXML documents. The Request element 
# can contain virtually any type of XML data.

module CXML
  class Request
    attr_accessor :id
    attr_accessor :deployment_mode
    attr_accessor :builder

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @id = data['id']
        @deployment_mode = data['deploymentMode']
        @builder = data['builder']
      end
    end

    def render(node)
      @builder.yield(node) if @builder
    end
  end
end