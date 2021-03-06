require 'json'
require 'terminal-table'
require 'date'
require 'pry'

class SearchInterface
  def initialize(organization_file_address, user_file_address, ticket_file_address)
    @organization_file_address = organization_file_address
    @user_file_address = user_file_address
    @ticket_file_address = ticket_file_address

    @organizations = FormElement.new(organization_file_address)
    @organizations.get_hash_by_address

    @users = FormElement.new(user_file_address)
    @users.get_hash_by_address

    @tickets = FormElement.new(ticket_file_address)
    @tickets.get_hash_by_address

    @results

    @display_table = DisplayTable.new()
  end

  def search(keyword)
    if is_keyword_a_number(keyword)
      keyword = keyword.to_i
    end

    organization_search_results = @organizations.find_keyword(keyword)
    users_search_results = @users.find_keyword(keyword)

    # find organization name for user
    users_search_results.map! do |user|
      organization_name = @organizations.find_element_by_id(user['organization_id'])['name']

      user['organization_name'] = organization_name

      user
    end

    tickets_search_results = @tickets.find_keyword(keyword)

    # find organization name, submitter name, assignee name for ticket
    tickets_search_results.map! do |ticket|
      organization_name = @organizations.find_element_by_id(ticket['organization_id'])['name']
      submitter_name = @users.find_element_by_id(ticket['submitter_id'])['name']
      assignee_name = @users.find_element_by_id(ticket['assignee_id'])['name']

      ticket['organization_name'] = organization_name
      ticket['submitter_name'] = submitter_name
      ticket['assignee_name'] = assignee_name

      ticket
    end

    @results = {
      "organizationSearchResults": organization_search_results,
      "usersSearchResults": users_search_results,
      "ticketsSearchResults": tickets_search_results
    }
  end

  def show_result()
    puts 'search results:'
    if @results[:organizationSearchResults].length > 0
      puts 'organizations:'
      @display_table.show_organization_table(@results[:organizationSearchResults])
    end

    if @results[:usersSearchResults].length > 0
      puts 'users:'
      @display_table.show_user_table(@results[:usersSearchResults])
    end
    if @results[:ticketsSearchResults].length > 0
      puts 'tickets:'
      @display_table.show_ticket_table(@results[:ticketsSearchResults])
    end
  end

  def is_keyword_a_number(keyword)
    keyword =~/^\d+$/?true:false
  end
end

class FormElement
  def initialize(file_address)
    @file_address = file_address
    @data_hash
    @quick_search_id_element_hash = Hash.new
  end

  def get_hash_by_address
    if File.file?(@file_address)
      File.open(@file_address) do |f|
        @data_hash = JSON.parse(f.read)
      end
      return @data_hash
    else
      raise "cannot find file: #{@file_address}"
    end
  end

  def find_keyword(keyword)
    results = []
    @data_hash.each do |element|
      if find_value_in_nested_hash(element, keyword)
        results.push(element)
      end

      # store info in hash for quick search in next time
      if element.key?(element['_id']) && element.key?(element['name']) && !@quick_search_id_element_hash.key?(element['_id']) 
        @quick_search_id_element_hash[element['_id']] = element
      end
    end

    return results
  end

  def find_value_in_nested_hash(data, desired_value)
    if desired_value == ""
      return find_blank_in_nested_hash(data)
    else
      data.values.each do |value|
        case value

        when desired_value
          return true

        when Hash
          f = find_value_in_nested_hash(value, desired_value)
          return f if f

        when Array
          new_hash = Hash[value.map.with_index {|x,i| [i, x]}]
          f = find_value_in_nested_hash(new_hash, desired_value)
          return f if f
        end
      end
    end

    return nil
  end

  def find_blank_in_nested_hash(data)
  	
    data.values.each do |value|
    # binding.pry
      if value === ''
        return true

      elsif value === Hash
        f = find_blank_in_nested_hash(value)
        return f if f

      elsif value === Array
        new_hash = Hash[value.map.with_index {|x,i| [i, x]}]
        f = find_blank_in_nested_hash(new_hash)
        return f if f
      end
    end

    return nil
  end

  def find_element_by_id(input_id)
    result = ''
    if @quick_search_id_element_hash.empty?
      @data_hash.each do |element|
        if element['_id'] == input_id
          result = element
        end
      end
      
    elsif !@quick_search_id_element_hash.empty?
      result = @quick_search_id_element_hash[input_id]
    end

    return result
  end
end

class DisplayTable
  def show_organization_table(organizations)
    table = Terminal::Table.new do |t|
      t << ['name','domain name','create at','details','shared tickets','tags']
      organizations.each do |organization|

        domain_names = array_to_string(organization['domain_names'])
        tags = array_to_string(organization['tags'])
        create_date = string_to_date(organization['created_at'])
        is_shared_tickets = boolean_to_answer(organization['shared_tickets'])

        t.add_row [organization['name'],domain_names,create_date,organization['details'],is_shared_tickets,tags]
      end
    end
    puts table
  end

  def show_user_table(users)
    table = Terminal::Table.new do |t|
      t << ['name','alias','create date','active','verified','shared','locale','email','phone','signature','organization','tags','suspended','role']
      users.each do |user|

        tags = array_to_string(user['tags'])
        create_date = string_to_date(user['created_at'])
        is_actived = boolean_to_answer(user['actived'])
        is_verified = boolean_to_answer(user['verified'])
        is_shared = boolean_to_answer(user['shared'])
        is_suspended = boolean_to_answer(user['suspended'])

        t.add_row [user['name'],user['alias'],create_date,is_actived,is_verified,is_shared,user['locale'],user['email'],user['phone'],user['signature'],user['organization_name'],tags,is_suspended,user['role']]
      end
    end

    puts table
  end

  def show_ticket_table(tickets)
    table = Terminal::Table.new do |t|
      t << ['subject','created_at','type','description','priority','status','submitter name','assignee name','organization name','tags','has_incidents','due_at','via']
      tickets.each do |ticket|

        tags = array_to_string(ticket['tags'])
        create_date = string_to_date(ticket['created_at'])
        due_date = string_to_date(ticket['due_at'])
        is_has_incidents = boolean_to_answer(ticket['has_incidents'])

        t.add_row [ticket['subject'],create_date,ticket['type'],ticket['description'],ticket['priority'],ticket['status'],ticket['submitter_name'],ticket['assignee_name'],ticket['organization_name'],tags,is_has_incidents,due_date,ticket['via']]
      end
    end

    puts table
  end

  def array_to_string(input_arr)
    new_string = ''
    input_arr.each do |element|
      if new_string.length == 0
        new_string = element
      else
        new_string = new_string + ', ' + element
      end
    end

    return new_string
  end

  def string_to_date(input_str)
    if input_str
      return Date.parse(input_str)
    else
      return 'Unknow'
    end
  end

  def boolean_to_answer(input_boolean)
    answer = ''
    if input_boolean == true
      answer = 'yes'
    else
      answer = 'no'
    end

    return answer
  end
end

