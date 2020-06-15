require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      students_hash = []
    html = Nokogiri::HTML(open(index_url))
    html.css(".student-card").collect do |student|
      hash = {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: "http://students.learn.co/" + student.css("a").attribute("href")
      }
      students_hash << hash
    end
    students_hash
    # binding.pry
  end
  
  

def self.scrape_profile_page(profile_url)
   student = {} 
   profile_page = Nokogiri::HTML(open(profile_url))
   links = profile_page.css(".social-icon-container").children.css("a").map {|el| el.attributes('href').value}
   links.each do |link|
     if link.include?("linkedin")
       student[:linkedin] = link
       elsif link.include?("github")
       student[:github] = link
       elsif link.include?("twitter")
       student[:twitter] = link 
     else
       student[:blog] = link
     end
   end
  student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
  student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")
end
end
