# Search-practice
## A simple search function

1. Requirement analysis

Using the provided data (tickets.json and users.json and organization.json) => there are 3 json files, and they must have some relationship between each other.

write a simple command line application => write a CLI, so no GUI requirement

to search the data and return the results in a human readable format. => Json to a table view

Feel free to use libraries or roll your own code as you see fit. => ruby has gems

Where the data exists, values from any related entities should be included in the results. => I need to search any related data from 3 json files

The user should be able to search on any field, full value matching is fine (e.g. “mar” won’t return “mary”). => find value equal to keyword

The user should also be able to search for empty values, e.g. where description is empty. => value can be empty

Extensibility - separation of concerns. => I will use functional programming

Simplicity - aim for the simplest solution that gets the job done whilst remaining => write simple code, do not put every thing in a function

Test Coverage - breaking changes should break your tests. => I want to use RSpec for testing

Performance - should gracefully handle a significant increase in amount of data provided (e.g 10000+ users). => Read json file line by line (f.each_line) is a good solution, if I can get enough time, I will do it, but it is not that important.

Robustness - should handle and report errors. => Ruby exceptions handler

2. The relationship between 3 json files

a. Organization do not belong to any other files

b. User belongs to Organizations

c. Tickets has submitter_id(user 1) and assignee_id(user 2), it also belongs to Organizations

3. My plan

a. Create a function to let user to input a keyword to the CLI

b. ~~Create a function to read json file line by line and output each element to ruby object, if file is too big, stop at the middle of the reading processes and wait for the data digest~~ First step: read json file and change it to a big hash

c. Create a function to match if a hash contain keywords & id(in an array) / has empty value

d. Create a function to first search Organization hash, then use the results to search Users hash, then use the results to search tickets hash, and store result to an array

e. Create a function to output the array to the screen
