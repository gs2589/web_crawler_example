class TreesController < ApplicationController

def index
  crawler=Adapter::Crawler.new()
  @string=crawler.create_site_map("http://flatironschool.com")
  
  
end



end 