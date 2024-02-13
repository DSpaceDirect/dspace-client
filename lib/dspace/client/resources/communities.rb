# frozen_string_literal: true

module DSpace
  class CommunityResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/communities.md"

    def default_endpoint
      "core/communities"
    end

    def list(**params)
      response = get_request(params: params) # may be scoped to subcommunity
      DSpace::List.from_response(client, response, key: "communities", type: DSpace::Community)
    end

    def create(parent: nil, **attributes)
      if parent
        DSpace::Community.new client, post_request(body: attributes, params: { parent: parent }).body
      else
        DSpace::Community.new client, post_request(body: attributes).body
      end
    end

    def retrieve(uuid:)
      DSpace::Community.new client, get_request(uuid).body
    end

    def update(uuid:, **attributes)
      DSpace::Community.new client, put_request(uuid, body: [attributes]).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end

    def search(method:, **attributes)
      handle_search(resource: DSpace::Community, key: "communities", method: method, **attributes)
    end

    def search_by_metadata(metadata)
      handle_search(resource: DSpace::Community, key: "communities", method: "findAdminAuthorized",
                    query: metadata)
    end

    def search_top
      handle_search(resource: DSpace::Community, key: "communities", method: "top", list: false)
    end
  end
end
