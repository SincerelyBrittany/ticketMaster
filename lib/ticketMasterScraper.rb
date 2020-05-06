class TicketMasterApp::TicketMasterScraper
  @@all = []
  @@search_array = []

  STATE_ABBR_TO_NAME = {
   'AL' => 'Alabama',
   'AK' => 'Alaska',
   'AS' => 'America Samoa',
   'AZ' => 'Arizona',
   'AR' => 'Arkansas',
   'CA' => 'California',
   'CO' => 'Colorado',
   'CT' => 'Connecticut',
   'DE' => 'Delaware',
   'DC' => 'District of Columbia',
   'FM' => 'Federated States Of Micronesia',
   'FL' => 'Florida',
   'GA' => 'Georgia',
   'GU' => 'Guam',
   'HI' => 'Hawaii',
   'ID' => 'Idaho',
   'IL' => 'Illinois',
   'IN' => 'Indiana',
   'IA' => 'Iowa',
   'KS' => 'Kansas',
   'KY' => 'Kentucky',
   'LA' => 'Louisiana',
   'ME' => 'Maine',
   'MH' => 'Marshall Islands',
   'MD' => 'Maryland',
   'MA' => 'Massachusetts',
   'MI' => 'Michigan',
   'MN' => 'Minnesota',
   'MS' => 'Mississippi',
   'MO' => 'Missouri',
   'MT' => 'Montana',
   'NE' => 'Nebraska',
   'NV' => 'Nevada',
   'NH' => 'New Hampshire',
   'NJ' => 'New Jersey',
   'NM' => 'New Mexico',
   'NY' => 'New York',
   'NC' => 'North Carolina',
   'ND' => 'North Dakota',
   'OH' => 'Ohio',
   'OK' => 'Oklahoma',
   'OR' => 'Oregon',
   'PW' => 'Palau',
   'PA' => 'Pennsylvania',
   'PR' => 'Puerto Rico',
   'RI' => 'Rhode Island',
   'SC' => 'South Carolina',
   'SD' => 'South Dakota',
   'TN' => 'Tennessee',
   'TX' => 'Texas',
   'UT' => 'Utah',
   'VT' => 'Vermont',
   'VI' => 'Virgin Island',
   'VA' => 'Virginia',
   'WA' => 'Washington',
   'WV' => 'West Virginia',
   'WI' => 'Wisconsin',
   'WY' => 'Wyoming'
 }

    def self.all
        @@all
        # binding.pry
    end

    def self.search_array
        @@search_array
    end

    def self.mass_create_from_api(results_array, from_input_search: false)
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
                newshash[:venueZipcode],
                from_input_search: from_input_search)
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

    def initialize(name, type, status, genre,venueName, venueCity,venueCountry, venueState, venueZipcode, from_input_search:)

      @name, @type, @status, @genre, @venueName, @venueCity, @venueCountry, @venueState, @venueZipcode =
      name, type, status, genre, venueName, venueCity, venueCountry, venueState, venueZipcode
      save

      if from_input_search == true
        save_to_search
      else from_input_search == false
        save
      end

    end

    def to_s
       self.name
   end

   def name
       @name.capitalize
   end



  def save
      @@all << self
  end

  def save_to_search
      @@search_array << self
  end

  def self.destroy_all
      @@all = []
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
