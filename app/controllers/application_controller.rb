class ApplicationController < ActionController::API
  def json_payload
    return [] if request.raw_post.empty?

    begin
      HashWithIndifferentAccess.new(JSON.parse(request.raw_post))
    rescue
      return []
    end
  end
end
