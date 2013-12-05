module Job_Scraper
  class Job

    attr_accessor :title, :url, :date_posted, :listing_site

    def initialize(title, url, date_posted, listing_site)
      @title = title
      @url = url
      @date_posted = date_posted
      @listing_site = listing_site
    end

    def to_s
      "#{@title} @ #{@url} posted on #{@date_posted} on #{@listing_site}"
    end
  end
end
