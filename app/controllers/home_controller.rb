class HomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

    def index
    @mon = Anam.find_by_day("월")
    @tue = Anam.find_by_day("화")
    @wed = Anam.find_by_day("수")
    @thu = Anam.find_by_day("목")
    @fri = Anam.find_by_day("금")
    @sat = Anam.find_by_day("토")
    end

    def get_bob
      doc = Nokogiri::HTML(open("https://www.korea.ac.kr/user/restaurantMenuAllList.do?siteId=university&id=university_050402000000"))

      for i in [3,5,7,9,11,13]
        bob = Anam.new

        day = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > span.day").inner_text
        bob.day= day

        date = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > span.date > span")[0].inner_text + "/" +
              doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > span.date > span")[1].inner_text
        bob.date = date

        breakfast_a = doc.css(".ku_restaurant//ul//li:nth-child(1)//ol:nth-child(#{i})//li//p.menulist").inner_text.split("-")[1]
        bob.breakfast_a = breakfast_a

        if i == 11 or i == 13
          lunch = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > div:nth-child(4)").inner_text.split("-")[1]
          bob.lunch = lunch

          dinner = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > div:nth-child(5)").inner_text.split("-")[1]
          bob.dinner = dinner

        else
          breakfast_b = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > div:nth-child(4)").inner_text.split("-")[1]
          bob.breakfast_b = breakfast_b

          lunch = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > div:nth-child(5)").inner_text.split("-")[1]
          bob.lunch = lunch

          dinner = doc.css("#contents_body > div.sub_contents > div > ul > li:nth-child(1) > ol:nth-child(#{i}) > li > div:nth-child(6)").inner_text.split("-")[1]
          bob.dinner = dinner
        end

       bob.save
      end
      redirect_to '/'
    end
end
