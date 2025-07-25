# Add a declarative step here for populating the DB with movies.

Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    movie[:release_date] = Date.parse(movie[:release_date])
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then(/(.*) seed movies should exist/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then(/I should see "(.*)" before "(.*)"/) do |_e1, _e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  entire_page = page.body
  e1_index = entire_page.index(_e1.to_s)
  e2_index = entire_page.index(_e2.to_s)
  expect(e1_index).to_not be_nil
  expect(e2_index).to_not be_nil
  expect(e1_index).to be < e2_index
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When(/I (un)?check the following ratings: (.*)/) do |_uncheck, _rating_list|
  split_list = _rating_list.split(', ')
  split_list.each do |rating|
    if _uncheck.nil?
      step "I check the \"#{rating}\" checkbox"
    else
      step "I uncheck the \"#{rating}\" checkbox"
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

# Part 2, Step 3
Then(/^I should (not )?see the following movies: (.*)$/) do |_no, _movie_list|
  split_list = _movie_list.split(', ')
  split_list.each do |movie|
    if _no.nil?
      step "I should see \"#{movie}\""
    else
      step "I should not see \"#{movie}\""
    end
  end
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
end

Then(/I should see all the movies/) do
  capybara_see = page.all('table#movies tbody tr').count
  expect(Movie.count).to eq capybara_see
end

### Utility Steps Just for this assignment.

Then(/^debug$/) do
  # Use this to write "Then debug" in your scenario to open a console.
  require "byebug"
  byebug
  1 # intentionally force debugger context in this method
end

Then(/^debug javascript$/) do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end

Then(/complete the rest of of this scenario/) do
  # This shows you what a basic cucumber scenario looks like.
  # You should leave this block inside movie_steps, but replace
  # the line in your scenarios with the appropriate steps.
  raise "Remove this step from your .feature files"
end
