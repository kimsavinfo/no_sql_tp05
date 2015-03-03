# no_sql_tp05

## ruby with MongoDB

Data source : https://www.githubarchive.org/
Thanks to github's events archive, execute the following queries :
- Number of events by hour
- Number of event by hour on the repository 'rails/rails'
- Repositories with more than 1000 events
- Order repositories : the most active to the least
- Top 10 most active repositories
- The most active repository
- The 5 most active author by hour


Import data in MongoDB (will clean github.events) :
> ruby import_github_events.rb

Execute queries :
> ruby main.rb

Gemfile available :
> bundle install
