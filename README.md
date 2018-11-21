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
