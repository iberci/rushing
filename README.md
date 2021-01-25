# theScore "the Rush" Interview Challenge

### Installation and running this solution

It's assumed that you have docker installed

- Once this repo is pulled, 
- Open up a terminal, and run:

|> docker-compose up


- Once that is finished running, the server should be available at http://localhost:4000
- You should be presented with a simple form in which the user can start an import process of a valid json file

- The File will be async processed and then a link to the graphql interface will be provided,
(I currently have a bug in which the user has to refresh the page.. (see below)

Features: 
  - Sorts importered rushers on any field and allows search on any part of a player's first or last name
  - Exports to JSON

Todo/Issues:
(I am getting a lot of flack from the recruiters to hand something in but I plan on playing with it in the interim)
If I am invited in for interview, I will hopefully have the below list more minimized

1) Real time update of the rusher imports with a progress bar
2) Figure out why LiveView is not re-rendering a component when the import process has been completed for a given version


Notes:
It's my first attempt at LiveView as my primary domain is Rails, but I am very excited at the prospect of learning to work with it

Also please note, that as a result of me primarily leveraging Phoenix/LV, and Graphql, I didn't have to write any React. ;)  I feel it's only fair to warn you that although I am competent with JS (I think), I haven't worked on any released products using either React/Vue client side frameworks (I am mostly back end).

Thank you


- 
