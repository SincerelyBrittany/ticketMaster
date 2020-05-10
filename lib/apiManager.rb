  class TicketMasterApp::APIManager
      #Stores API endpoint URL in a constant at the top of the class

      BASE_URL = 'https://app.ticketmaster.com/discovery/v2/events'

      def self.eventList(state_code, page, pageSize)#page,pageSize) #uses the NET::HTTP library to send an HTTP request from our program
          #https://app.ticketmaster.com/discovery/v2/events?apikey=Q50bxg9zWmnG1pun2XaPknPeO9n6m5JL&locale=*&page=1
          puts "MAKING STATE SEARCH REQUEST"
          url = BASE_URL + "?&stateCode=#{state_code}" + API_KEY + "&page=#{page}" + "&pageSize=#{pageSize}" #+ "&page=#{page}" + "&pageSize=#{pageSize}"
          puts "#{url}"
          uri = URI.parse(url)
          response = Net::HTTP.get_response(uri) #NET::HTTP is a Ruby library that allows your program or application to send HTTP requests.
          res = JSON.parse(response.body)
          posts = res["_embedded"]["events"]#articles is an array
          # names = posts[0]["name"]
          return false if posts == nil
          array =[]
          posts.each do |post|
            new_hash = {
          name: post["name"],
          type: post["type"],
          #res["_embedded"]["events"][0]["dates"]["start"]["localDate"]
          #res["_embedded"]["events"][0]["dates"]["start"]["localTime"]
          #res["_embedded"]["events"][0]["sales"]["public"]["startDateTime"]
          #res["_embedded"]["events"][0]["sales"]["public"]["endDateTime"]
          date: post["sales"]["public"]["startDateTime"],
          status: post["dates"]["status"]["code"], #rescheduled
          #res["_embedded"]["events"][0]["classifications"][0]["segment"]["name"] # Arts & Theatre
          genre: post["classifications"][0]["genre"]["name"], #Theatre
          venueName: post["_embedded"]["venues"][0]["name"], #venue name
          venueCity: post["_embedded"]["venues"][0]["city"]["name"], #city name
          venueState: post["_embedded"]["venues"][0]["state"]["name"], #state name
          venueZipcode: post["_embedded"]["venues"][0]["postalCode"], #zipcode
          venueCountry: post["_embedded"]["venues"][0]["country"]["countryCode"] # "US"
        }
        array << new_hash
        end
        if array.length > 0 #if array length is more than zero then return mass_create_from_api
          binding.pry
          TicketMasterApp::TicketMasterScraper.mass_create_from_api(array, from_input_search: false)
          end
          return array.length > 0
        end

      def self.ticketmasterEventSearch(event_name, state_code=nil, page, pageSize)

      puts "MAKING SEARCH EVENT REQUEST"
      # url = BASE_URL + ".json?keyword=#{event_name}&source=ticketmaster&countryCode=US&stateCode=NY" + API_KEY #add stateCode
      if state_code != nil
        url = BASE_URL + ".json?keyword=#{event_name}&source=ticketmaster&countryCode=US" + API_KEY + "&page=#{page}" + "&pageSize=#{pageSize}"
      else
        url = BASE_URL + ".json?keyword=#{event_name}&source=ticketmaster&countryCode=US&stateCode=#{state_code}" + API_KEY + "&page=#{page}" + "&pageSize=#{pageSize}"
      end
      puts "#{url}"
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri) #NET::HTTP is a Ruby library that allows your program or application to send HTTP requests.
      res = JSON.parse(response.body)
      posts = res["_embedded"]["events"]#articles is an array
      # names = posts[0]["name"]
      return false if posts == nil
      array =[]
      posts.each do |post|
        new_hash = {
      name: post["name"],
      type: post["type"],
      #res["_embedded"]["events"][0]["dates"]["start"]["localDate"]
      #res["_embedded"]["events"][0]["dates"]["start"]["localTime"]
      date: post["sales"]["public"]["startDateTime"],
      #res["_embedded"]["events"][0]["sales"]["public"]["endDateTime"]
      status: post["dates"]["status"]["code"], #rescheduled
      #res["_embedded"]["events"][0]["classifications"][0]["segment"]["name"] # Arts & Theatre
      genre: post["classifications"][0]["genre"]["name"], #Theatre
      venueName: post["_embedded"]["venues"][0]["name"], #venue name
      venueCity: post["_embedded"]["venues"][0]["city"]["name"], #city name
      venueState: post["_embedded"]["venues"][0]["state"]["name"], #state name
      venueZipcode: post["_embedded"]["venues"][0]["postalCode"], #zipcode
      venueCountry: post["_embedded"]["venues"][0]["country"]["countryCode"] # "US"
    }
    array << new_hash
    end
    if array.length > 0 #if array length is more than zero then return mass_create_from_api
      binding.pry
      TicketMasterApp::TicketMasterScraper.mass_create_from_api(array, from_input_search: true)
      end
      return array.length > 0
    end
  end
