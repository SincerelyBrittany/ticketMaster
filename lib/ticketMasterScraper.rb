class TicketMasterApp::TicketMasterScraper
  @@all = []
  @@search_array = []

    def self.all
        @@all
        # binding.pry
    end

    def self.search_array
        @@search_array
    end

    def self.mass_create_from_api(results_array)
        results_array.each do |newshash|
            new(
                newshash[:name],
                newshash[:type],
                newshash[:status],
                newshash[:genre],
                newshash[:venueName],
                newshash[:venueCity],
                newshash[:venueCountry],
                newshash[:venueState],
                newshash[:venueZipcode])
        end
        binding.pry
    end

    # def self.get_articles(input)
    #    @@all.map do |x|
    #      if x.title.start_with?(input)
    #        input
    #    end
    # end

    def self.get_articles(input)
      @@all.map do |x|
        if x.title.start_with?(input)
        input
        else
        puts "fail"
        end
      end
    end


    attr_accessor   :name, :type, :status, :genre,
      :venueName,:venueCity, :venueCountry, :venueState, :venueZipcode

    def initialize(name, type, status, genre,venueName, venueCity,venueCountry, venueState, venueZipcode)

      @name, @type, @status, @genre, @venueName, @venueCity, @venueCountry, @venueState, @venueZipcode =
      name, type, status, genre, venueName, venueCity, venueCountry, venueState, venueZipcode
      save

    end

    def to_s
       self.name
   end

   def name
       @title.capitalize
   end

  def save
      @@all << self
  end

  def save_to_search
      @@search_array << self
  end

  def self.destroy_all
      @@search_array = []
  end

  def more?
       !!@description
  end

 def full_details

        <<-DESC
        TITLE: #{title}

        DESCRIPTION: #{description}

        CONTENT: #{content}

        URL TO ARTICLE : #{url}
       DESC

  end

end
