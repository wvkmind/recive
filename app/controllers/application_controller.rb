class ApplicationController < ActionController::Base
  def render_json(*args)
    formats.clear
    formats << :json
    render *args
  end
end
