# Quorum Coding Challenge

A small project created to calcculate votes from legislators and bills.

### Getting started
1. Install Ruby 3.2.2
2. `cd quorum/`
3. `ruby main.rb`

### Writeup
1. Discuss your solution’s time complexity. What tradeoffs did you make?
    - The biggest tradeoff that I had, was to create everything in one file,
      not having the time to split in many different `service` files,
      that would keep the codebase as clean as possible.
      
2. How would you change your solution to account for future columns that might be
requested, such as “Bill Voted On Date” or “Co-Sponsors”?
    - I would add those 2 new fields to the `hash` counter,
      so would be easy to save these datas to print after in the csv

4. How would you change your solution if instead of receiving CSVs of data, you were given a
list of legislators or bills that you should generate a CSV for?
    - I would do a modification to filter data based on the provided lists,
      "querying" the legislator or bill to get them by the id.

6. How long did you spend working on the assignment?
    - 3 hours
