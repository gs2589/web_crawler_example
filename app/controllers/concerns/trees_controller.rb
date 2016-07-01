class TreesController < ApplicationController

def index
  if params['url']
  crawler=Adapter::Crawler.new()
  @tree=crawler.create_site_map(params["url"])
  end
  
  
end



end 