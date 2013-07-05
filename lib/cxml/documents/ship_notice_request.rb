# Builder for ShipNoticeRequest object
class ShipNoticeRequest < RequestDoc
  @@defaults = {
    shipment_id: nil
  }

  def features(node)
    node.ShipNoticeRequest {
      node.ShipNoticeHeader({noticeDate: Time.now.iso8601, shipmentDate: Time.now.iso8601}.merge(@opts[:shipment_id] ? { shipmentID: @opts[:shipment_id]} : {}))
    }
  end
end