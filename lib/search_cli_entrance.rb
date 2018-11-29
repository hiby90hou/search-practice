require './lib/search_cli.rb'

interface = SearchInterface.new('./resources/organizations.json','./resources/users.json','./resources/tickets.json')

close_interface = false

while !close_interface
  puts "Please typing in your search keyword:"

  keyword = gets.chomp

  interface.search(keyword)
  interface.show_result()

  puts "Do you want to continue your search? y/n"

  is_continue = gets.chomp

  if is_continue == 'n'
    puts "exit"
    close_interface = true
  end
end
