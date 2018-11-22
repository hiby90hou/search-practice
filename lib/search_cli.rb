require 'json'
require 'terminal-table'

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
		organizationSearchResults = @organizations.find_keyword(keyword)

		usersSearchResults = @users.find_keyword(keyword)

		ticketsSearchResults = @tickets.find_keyword(keyword)

		@results = {
			"organizationSearchResults": organizationSearchResults,
			"usersSearchResults": usersSearchResults,
			"ticketsSearchResults": ticketsSearchResults
		}
	end

	def show_result()
		@display_table.showOrganizationTable(@results[:organizationSearchResults])
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
end

class DisplayTable
	def showOrganizationTable(organizations)
		puts organizations
		row = []
		table = Terminal::Table.new do |t|
			t << ['name','domain name','create at','details','shared tickets','tags']
			organizations.each do |organization|
				domain_names = ""
				tags = ""

				organization['domain_names'].each do |domain_name|
					if domain_names.length == 0
						domain_names = domain_name
					else
						domain_names = domain_names + '\n' + domain_name
					end
				end

				organization['tags'].each do |tag|
					if tags.length == 0
						tags = tag
					else
						tags = tags + '\n' + tag
					end
				end

				puts organization
				create_date = organization['created_at']
				t.add_row [organization['name'],domain_names,create_date,organization['details'],organization['shared_tickets'],tags]
			end
		end
		puts table
	end

	def showUserTable(users)
		row = []
		row.push(['id','url','name','domain name','create at','details','shared tickets','tags'])
	end
end
# interface = SearchInterface.new('../resources/organizations.json','../resources/users.json','../resources/tickets.json')