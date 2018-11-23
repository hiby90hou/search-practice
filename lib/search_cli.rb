require 'json'
require 'terminal-table'
require 'date'

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
		organization_search_results = @organizations.find_keyword(keyword)

		users_search_results = @users.find_keyword(keyword)

		# find organization name for user
		users_search_results.map! do |user|
			organization_name = @organizations.find_name_by_id(user['organization_id'])
			user['organization_name'] = organization_name
			user
		end

		puts users_search_results

		tickets_search_results = @tickets.find_keyword(keyword)

		@results = {
			"organizationSearchResults": organization_search_results,
			"usersSearchResults": users_search_results,
			"ticketsSearchResults": tickets_search_results
		}
	end

	def show_result()
		@display_table.show_organization_table(@results[:organizationSearchResults])
		@display_table.show_user_table(@results[:usersSearchResults])
		@display_table.show_ticket_table(@results[:ticketsSearchResults])
	end
end

class FormElement
	def initialize(file_address)
		@file_address = file_address
		@data_hash
	end

	def get_hash_by_address
		if File.file?(@file_address)
			File.open(@file_address) do |f|
  			@data_hash = JSON.parse(f.read)
			end
			return(@data_hash)
		else
			raise "cannot find file: #{@file_address}"
		end
	end

	def find_keyword(keyword)
		results = []
		@data_hash.each do |element|
			# puts k
			if find_value_in_nested_hash(element, keyword)
				results.push(element)
			end
		end

		return results
	end

	def find_value_in_nested_hash(data, desired_value)
	  data.values.each do |value| 
	    case value
	    when desired_value
	      return true
	    when Hash
	      f = find_value_in_nested_hash(value, desired_value)
	      return f if f
	    when Array
	    	new_hash =Hash[value.map.with_index {|x,i| [i, x]}]
	    	f = find_value_in_nested_hash(new_hash, desired_value)
	      return f if f
	    end
	  end
	  nil
	end

	def find_name_by_id(input_id)
		result = ''
		@data_hash.each do |element|
			if element['_id'] == input_id
				result = element['name']
			end
		end

		return result
	end
end

class DisplayTable
	def show_organization_table(organizations)
		# puts organizations
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
		# puts users
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
		# puts tickets
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
		return Date.parse(input_str)
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
# interface = SearchInterface.new('../resources/organizations.json','../resources/users.json','../resources/tickets.json')