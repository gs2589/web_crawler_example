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
      @errors=[]
    end

    def create_site_map(url, level=0, url_tracker=[], template_links=[], tree_string="")

      @host_url=get_host(url) if level==0 
      
      #prints
      if !url_tracker.include?(url)
        puts(get_indentation(level)+url)
        tree_string<<"#{get_indentation(level)}#{url}<br>"
        url_tracker<<url

        if is_internal(url)
          begin
            sleep(0.5)
            current_doc=Nokogiri::HTML(open(url))
          rescue Exception=>e
          end
          links_in_parent=current_doc.css("a").map do |link|
          #ensures url is in absolute format
            unless !link['href']
               begin
                absolute_url=URI.join("http://#{@host_url}", link['href']).to_s
               rescue Exception=>e
               end
            end
          end
          links_in_parent.compact!
          links_in_parent.each do |absolute_url|

            create_site_map(absolute_url, level+1, url_tracker, links_in_parent, tree_string) unless template_links.include?(absolute_url)
          end      
        end
      end
      tree_string
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