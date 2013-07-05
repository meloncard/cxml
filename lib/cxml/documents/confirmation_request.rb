# Builder for ConfirmationRequest object
class ConfirmationRequest < RequestDoc
  @@defaults = {
    type: 'accept',
    payload_id: nil,
    confirm_id: nil,
    invoice_id: nil
  }

  def features(node)
    node.ConfirmationRequest({}.merge(@opts[:confirm_id] ? { confirmID: @opts[:confirm_id] } : {}).merge(@opts[:invoice_id] ? { invoice_id: @opts[:invoice_id] } : {})) {
      node.ConfirmationHeader(type: @opts[:type], noticeDate: Time.now.iso8601)
      node.OrderReference {
        node.DocumentReference(@opts[:payload_id] ? { payloadID: @opts[:payload_id] } : {})
      }
    }
  end

end