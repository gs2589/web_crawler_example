module Adapter

# try to remove these. Might not need them because of Rails
require 'open-uri'
require 'nokogiri'
require 'pry'
require 'uri'


  #use recursion
  class Crawler

    def initialize
      @host_url=nil
    end

    def create_site_map(url, level=0, url_tracker=[])
      

      @host_url=get_host(url) if level==0 
      
      #prints
      if !url_tracker.include?(url)
        puts(get_indentation(level)+url)
        url_tracker<<url

        if is_internal(url)
          current_doc=Nokogiri::HTML(open(url))
          current_doc.css("a").each do |link|
          #ensures url is in absolute format
            unless !link['href']
              absolute_url=URI.join("http://#{@host_url}", link['href']).to_s
              create_site_map(absolute_url, level+1, url_tracker)
            end
          end    
        end
      end
    end

    def get_indentation(level)
      indentation=""
      level.times do indentation<<"-" end
      indentation
    end

    def is_internal(url)
      @host_url==get_host(url)
    end

    def get_host(url)
      URI(url).host
    end

    



  end
end