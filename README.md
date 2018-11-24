# Search-practice

## A simple search function
This search function is base on ruby, and able to handle organizations data, users data and tickets data in 3 different JSON files.

### The technology that I used in this project

a. ruby -> a backend language

b. terminal-table (gem) -> a gem to make good table layout in terminal

c. minitest(gem) -> a ruby testing tool

### How to use
a. Install Ruby


b. Clone project
```
git clone https://github.com/hiby90hou/search-practice.git
```

c. Install gems
```
bundle install
```

d. Run ruby project
```
cd lib
ruby ./search_cli.rb
```

e. Run testing
```
ruby ./search_cli_test.rb
```

### Requirement analysis

Using the provided data (tickets.json and users.json and organization.json) => there are 3 JSON files, and they must have some relationship between each other.

write a simple command line application => write a CLI, so no GUI requirement:cry:.

to search the data and return the results in a human readable format. => JSON to a table view.

Feel free to use libraries or roll your own code as you see fit. => Ruby has gems.

Where the data exists, values from any related entities should be included in the results. => I need to search any related data from 3 JSON files.

The user should be able to search on any field, full value matching is fine (e.g. “mar” won’t return “mary”). => find value equal to the keyword.

The user should also be able to search for empty values, e.g. where the description is empty. => value can be empty.

Extensibility - separation of concerns. => I will use functional programming.

Simplicity - aim for the simplest solution that gets the job done whilst remaining => write simple code, do not put everything in a function.

Test Coverage - breaking changes should break your tests. => I want to use Minitest for testing.

Performance - should gracefully handle a significant increase in amount of data provided (e.g 10000+ users). => Read JSON file line by line (f.each_line) is a good solution, if I can get enough time, I will do it, but it is not that important.

Robustness - should handle and report errors => Ruby exceptions handler.

### The relationship between 3 json files

a. An organization does not belong to any other files.

b. A user belongs to organizations.

c. Tickets has submitter_id(user 1) and assignee_id(user 2), it also belongs to organizations.

### My plan before I start to code

a. Create a function to let a user input a keyword to the CLI.

b. ~~Create a function to read JSON file line by line and output each element to ruby object, if the file is too big, stop at the middle of the reading processes and wait for the data digest~~ First step: read JSON file and change it to a big hash.

c. Create a function to match if a hash contains keywords & id (in an array).

d. Create a function to match if a hash has empty value (need to input a template and base on this template to check).

e. Create a function to first search Organization hash, then use the results to search Users hash, then use the results to search tickets hash, and store result in an array.

f. Create a function to output the array to the screen.

### Template

Organization
```
{
  "_id": number,
  "url": string,
  "external_id": string",
  "name": string,
  "domain_names": Array<string>,
  "created_at": Date,
  "details": string,
  "shared_tickets": boolean,
  "tags": Array<string>
}
```

Users
```
{
  "_id": number,
  "url": string,
  "external_id": string,
  "name": string,
  "alias": string,
  "created_at": Date,
  "active": boolean,
  "verified": boolean,
  "shared": boolean,
  "locale": string,
  "timezone": string,
  "last_login_at": Date,
  "email": string,
  "phone": string,
  "signature": string,
  "organization_id": number,
  "tags": Array<string>,
  "suspended": boolean,
  "role": string
}
```

Tickets
```
{
  "_id": string,
  "url": string,
  "external_id": string,
  "created_at": Date,
  "type": string,
  "subject": string,
  "description": string,
  "priority": string,
  "status": string,
  "submitter_id": number,
  "assignee_id": number,
  "organization_id": number,
  "tags": Array<string>,
  "has_incidents": boolean,
  "due_at": Date,
  "via": string
}
```
### What I achieved

a. A search function that includes empty '' search.

b. The search results shown in 3 tables.

c. The data in the table is ready for normal people to use (without the country code part).

d. Limited testing, I am not good at testing, but I want to learn it and I learned how to use Minitest in this project.

### What I need to do
a. Find out the right country-code => country-name key-value hash that can be used in this system, I am not sure how many countries had been included in the data.

b. Write more testing.

c. Improving code performance by creating a function to read JSON file line by line and output each element to ruby object, if the file is too big, stop at the middle of the reading processes and wait for the data digest.

d. More practice on ruby, I was too focused on front-end technology in the last 6 month.
