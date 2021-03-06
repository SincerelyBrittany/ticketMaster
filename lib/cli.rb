class TicketMasterApp::CLI

  def start
    introduction
    main_menu
  end


  def initialize
       @page = 1
       @count = 1
       @pageSize = 20
       # @state_input = nil
       @state_code= nil
       @user_query_search_input = nil
       @from_search = nil
  end

  def introduction
    puts "\n\n\n\n\n\n"
    puts "--------------------------------------------------------------------------------------------------------"
    puts "----------------------------------- Welcome To The TicketMaster App!--------------------------------------------"
    puts "--------------------------------------------------------------------------------------------------------"
    # sleep(2)
    puts "\n"
  end
  # #
  def main_menu
    puts
    puts "-----------------------------------------------------"
    puts "------------------- Main Menu!-----------------------"
    puts "-----------------------------------------------------"
    puts "Type ‘1’ Search for Events by State"
    puts "Type ‘2’ to Search by events  "
    puts "Type ‘3’ to Search by events  "
    puts "Type ‘exit’ to exit program"
    puts "Type 'credits' for credits"
    user_input = gets.strip.downcase
    menu_input(user_input)
  end

  def menu_input(user_input)
    if user_input == "1"
      @from_search = false
      find_state_code
      get_data
      ticketmaster_options_loop
    elsif user_input == "2"
      @from_search = true
      get_query_input
      query_selection
      ticketmaster_options_loop
    elsif user_input == "3"
      @from_search = true
      get_query_input
      find_state_code
      query_selection
      ticketmaster_options_loop
    elsif user_input == "exit" #MUST GET TO WORK
      puts "Thank you come again!"
      return
    elsif user_input == "credits"
      credits
    else
      puts "Invalid Response, Please Try Again"
      main_menu
    end
  end

  def get_data
      if !TicketMasterApp::APIManager.eventList(@state_code, @page, @pageSize)
      # TicketMasterApp::APIManager.eventList(@state_code, @page, @pageSize)
      #   binding.pry
        puts "There is no page #{@page} -- returning to page #{@page - 1}"
        sleep(1)
        @page -= 1
      end
  end

  def get_query_input
    puts "Please type what you would like to search"
    @user_query_search_input = gets.chomp.downcase
  end

  def query_selection
      if !TicketMasterApp::APIManager.ticketmasterEventSearch(@user_query_search_input, @state_code, @page, @pageSize)
        binding.pry
        puts "There is no page #{@page} -- returning to page #{@page - 1}"
        sleep(1)
        @page -= 1
      end
  end

  def find_state_code
    puts "Enter Something"
    user_state_input = gets.strip.downcase
    #puts user_input
    user_state_input(user_state_input)
  end


  def user_state_input(user_input) #must fix so that it returns error when entry is invalid
    input = user_input.downcase
      if input.length >= 2
        total = STATE_ABBR_TO_NAME.length
        count = 1
        # while count <= total
        STATE_ABBR_TO_NAME.each do |x,y|
             count += 1
              if x.downcase == input || y.downcase == input
              puts "#{x.upcase}"
              @state_code = x.upcase
              # binding.pry
            end #end of each
          end #end of if
        end #end of unless
      end #end of if


  def instuctions
    puts
    puts "----- Type 'next' see more and 'prev' to return to previous page ------"
    puts
    puts "------ Pick a number to view more information on an article -----------"
    puts
    puts "---------------- Type 'return' to return to main menu -----------------"
    puts
    puts "------------------------ Type 'exit' to exit --------------------------"
  end

  def credits
    puts "This app was created by SincerelyBrittany"
    puts "The API was used by https://newsapi.org/"
    puts "See more about app on my github https://github.com/SincerelyBrittany/newsAPI"
    puts
    puts "press any key to return to the main menu"
    gets
    main_menu
  end

  def ticketmaster_options_loop
    loop do
      second_menu
      input = get_article_choice
        case input
            when "exit"
                break
            when "invalid"
                next
            when "return" # if return make input == user_input
                TicketMasterApp::TicketMasterScraper.destroy_all
                @page = 1
                @count = 1
                @state_input = nil
                @from_search = nil
                main_menu
                return
            when "next"
                if @from_search == false
                  @page += 1
                  start, stop = get_page_range
                  if TicketMasterApp::TicketMasterScraper.all.length <= start
                      get_data
                  end
                else @from_search == true
                  @page += 1
                  start, stop = get_page_range
                  if TicketMasterApp::TicketMasterScraper.search_array.length <= start
                      @count += 1
                      query_selection
                  end
               end
            when "prev"
                if @page <= 1
                    puts "You cannot get that page, you are alredy on page 1!"
                else
                    @page -= 1
                end
            else
              display_article(input)
            end
        end
    end

  def display_article(i)
      if @from_search == false
      start, stop = get_page_range
      a = TicketMasterApp::TicketMasterScraper.all[start...stop][i]
      puts a.full_details
      puts
      puts 'Press any key to go back'
      gets
    else @from_search == true
      start, stop = get_page_range
      b = TicketMasterApp::TicketMasterScraper.search_array[start...stop][i]
      puts b.full_details
      puts
      puts 'Press any key to go back'
      gets
    end
  end

  def get_article_choice
    input = gets.strip.downcase
    commands = ["exit","return","next", "prev"]
    return input.downcase if commands.include?(input.downcase)
    if !valid?(input)
      puts "Invalid Response, Please Try Again"
      sleep(3)
      return "invalid"
    end
      return input.to_i - 1
  end

    def valid?(i)
      if @from_search == false
      i.to_i.between?(1, TicketMasterApp::TicketMasterScraper.all.length)
      else @from_search == true
      i.to_i.between?(1, TicketMasterApp::TicketMasterScraper.search_array.length)
      end
    end
    def second_menu
      display_articles
      instuctions
    end

    def get_page_range

      [(@page - 1) * @pageSize, @page * @pageSize]
      binding.pry
    end

    def display_articles
        if @from_search == true
          # binding.pry
        start, stop = get_page_range
       #binding.pry
        puts "\n\nPAGE #{@page} of your search for #{@user_query_search_input.capitalize}"
          TicketMasterApp::TicketMasterScraper.search_array[start...stop].each.with_index do |p,i|
            puts "#{i+1}. #{p}"
          end
        else @from_search == false
          #binding.pry
          start, stop = get_page_range
          puts "\n\nPAGE #{@page}"
          TicketMasterApp::TicketMasterScraper.all[start...stop].each.with_index do |p,i|
          puts "#{i+1}. #{p}"
          end
      end


end
end
