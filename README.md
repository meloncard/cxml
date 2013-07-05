# cXML

Ruby implementation of cXML protocol. 

## Documentation

Procotol specifications could be found here [http://xml.cxml.org/current/cXMLUsersGuide.pdf](http://xml.cxml.org/current/cXMLUsersGuide.pdf)

## Commerce

cXML library can be used to handle inbound cXML requests via the Commerce.dispatch function.  E.g.

    class CommerceController < ApplicationController
    
      def handle
        Commerce.dispatch(request.raw_post) do
          order_request do |order_request|
            respond_to do |format|
              format.xml { render xml: Commerce::Response.success }
            end
          end
        end
      end
    
    end

## Building documents

To build request documents, you can use the document builder.  E.g.

    Commerce::ConfirmationRequest.new(type: 'reject').render

or send the response to a server (via RestClient)

    Commerce::ShipNoticeRequest.new.send("http://example.com/cxml")

## Running Tests

Install dependencies:

```
bundle install
```

Run suite:

```
rake test
```