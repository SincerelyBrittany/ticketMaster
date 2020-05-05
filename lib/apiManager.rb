  class TicketMasterApp::APIManager
      #Stores API endpoint URL in a constant at the top of the class

      BASE_URL = 'https://app.ticketmaster.com/discovery/v2/events'

      def self.eventList #page,pageSize) #uses the NET::HTTP library to send an HTTP request from our program
          #https://app.ticketmaster.com/discovery/v2/events?apikey=Q50bxg9zWmnG1pun2XaPknPeO9n6m5JL&locale=*&page=1

          url = BASE_URL + "?&stateCode=NY" + API_KEY  #+ "&page=#{page}" + "&pageSize=#{pageSize}"
          uri = URI.parse(url)
          response = Net::HTTP.get_response(uri) #NET::HTTP is a Ruby library that allows your program or application to send HTTP requests.
          res = JSON.parse(response.body)
          posts = res["_embedded"]["events"]#articles is an array
          # names = posts[0]["name"]
          array =[]
          posts.each do |post|
            new_hash = {
          name: post["name"],
          type: post["type"],
          #res["_embedded"]["events"][0]["dates"]["start"]["localDate"]
          #res["_embedded"]["events"][0]["dates"]["start"]["localTime"]
          #res["_embedded"]["events"][0]["sales"]["public"]["startDateTime"]
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
        #binding.pry
        TicketMasterApp::TicketMasterScraper.mass_create_from_api(array, from_input_search: false)

      end

      def self.ticketmasterEventSearch
      #
      url = BASE_URL + ".json?keyword=jam&source=ticketmaster&countryCode=US&stateCode=NY" + API_KEY #add stateCode
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri) #NET::HTTP is a Ruby library that allows your program or application to send HTTP requests.
      res = JSON.parse(response.body)
      posts = res["_embedded"]["events"]#articles is an array
      # names = posts[0]["name"]
      array =[]
      posts.each do |post|
        new_hash = {
      name: post["name"],
      url: post["url"],
    }
    array << new_hash
    end
    binding.pry

      end


end
