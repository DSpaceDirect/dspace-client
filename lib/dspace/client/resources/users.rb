# frozen_string_literal: true

# DSpace
module DSpace
  class UserResource < Request
    ENDPOINT = "eperson/epersons"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::Collection.from_response(response, key: "epersons", type: DSpace::User)
    end

    def search(**params)
      DSpace::User.new get_request("#{ENDPOINT}/search/byEmail", params: params).body
    end

    def create(**attributes)
      DSpace::User.new post_request(ENDPOINT, body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::User.new get_request("#{ENDPOINT}/#{uuid}").body
    end

    def update(uuid:, **attributes)
      DSpace::User.new put_request("#{ENDPOINT}/#{uuid}", body: [attributes]).body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end
  end
end