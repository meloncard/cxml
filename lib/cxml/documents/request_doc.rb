# Default parent for all Request builders
class RequestDoc
  attr_accessor :opts
  class_attribute :defaults

  def initialize(opts={})
    @opts = opts.with_indifferent_access.reverse_merge(self.class.class_variable_defined?("@@defaults") ? self.class.class_variable_get("@@defaults") : {})
  end

  def [](key)
    @opts[key]
  end

  def []=(key,val)
    @opts[key] = val
  end

  def render
    doc = CXML::Document.new('Request' => { 'builder' => proc { |node|
      features(node)
    }})

    doc.setup
    doc.render.to_xml
  end

  def features
    raise NotImplementedError, "Missing features function for #{self.class.name}"
  end

  def send(endpoint)
    RestClient.post endpoint, self.render, content_type: :xml

    # TODO: Abstract and verify response
  end
end