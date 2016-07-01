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

    def create_site_map(url, level=0, url_tracker=[], template_links=[], tree_string={})

      @host_url=get_host(url) if level==0 
      
      #prints a url only if it has not been printed before
      if !url_tracker.include?(url)
        #puts(get_indentation(level)+url)  this line is for developer debugging use
        tree_string["#{get_indentation(level)}#{url}"]={
          url: url,
          level: level, 
          internal: is_internal(url) ? "internal" : "external",
          image: is_image(url) ? " an_image" : ""

        }
        #marks a url as appeared so it does not reappear
        url_tracker<<url

        #only pursues links that are internal and are not images
        if is_internal(url) && !is_image(url)
          begin
            #sleeps before opening a link to prevent overload
            sleep(0.5)
            current_doc=Nokogiri::HTML(open(url))
          rescue Exception=>e
          end
          if current_doc
            links_in_parent=current_doc.css("a, img").map do |link|
            #ensures url is in absolute format
                if link['href']
                 begin
                  absolute_url=URI.join("http://#{@host_url}", link['href']).to_s
                 rescue Exception=>e
                 end
                elsif link['src']
                  begin
                  absolute_url=URI.join("http://#{@host_url}", link['src']).to_s
                 rescue Exception=>e
                 end
              end
            end
          

            links_in_parent.compact!
            #regresses on all links on the page except those present in parent pages
            links_in_parent.each do |absolute_url|

            create_site_map(absolute_url, level+1, url_tracker, links_in_parent, tree_string) unless template_links.include?(absolute_url)
            end 
          end     
        end
      end
      tree_string
    end

    def get_indentation(level)
      indentation=""
      level.times do indentation<<"----" end
      indentation
    end

    def is_internal(url)
      @host_url==get_host(url)
    end

    def get_host(url)
      URI(url).host
    end

    def is_image(url)
      (url.include?(".png")||url.include?(".jpg"))
    end

    



  end
end