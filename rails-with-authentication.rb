=begin
Template Name: WMBT Web Services Rails Template with authentication
Author: Matthew Clark (@isMattCoding)
Author URI: https://wmbt.services
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m rails-with-authentication.rb
=end

say "
#######################################################################
#                                                                     #
#  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████████████▓▒░░▒▓███████▓▒░▒▓████████▓▒░ #
#  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
#  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
#  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  ░▒▓█▓▒░     #
#  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
#  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
#   ░▒▓█████████████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  ░▒▓█▓▒░     #
#                            Web Services                             #
#                  Rails Template with authentication                 #
#                        https://wmbt.services                        #
#                                                                     #
#######################################################################
", :yellow

#     Kill Spring processes
###############################################################

say
say "
===============================================================================
Kill all Spring processes 🌼
===============================================================================", :yellow
say

run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"


#     Gemfile
###############################################################

say
say "
===============================================================================
Add custom gems 💎
===============================================================================", :yellow
say

inject_into_file "Gemfile", before: "group :development, :test do" do
  <<~RUBY
  gem "devise"
  gem "tailwindcss-rails"
  gem "sassc-rails"
  RUBY
end

gsub_file(
  "Gemfile",
  "gem \"capybara\"",
  "gem 'rspec-rails', '~> 5.0'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'launchy'"
)

###############################################################
#     After Bundle
###############################################################

say
say "
===============================================================================
After bundle... 🚀
===============================================================================", :yellow
say

after_bundle do
  #     Page Structure
  ###############################################################

  say
  say "
===============================================================================
Setting routes 🚧
===============================================================================", :yellow
  say

  generate(:controller, "pages", "home", "--skip-routes", "--no-test-framework")
  route "root to: 'pages#home'"

  #     .gitignore
  ###############################################################

  say
  say "
===============================================================================
Using GitHub's .gitignore file 😶‍🌫️
===============================================================================", :yellow
  say

  run "rm .gitignore"
  run "curl -L https://raw.githubusercontent.com/github/gitignore/main/Rails.gitignore > .gitignore"
  gsub_file(".gitignore", ".env", "# .env")
  gsub_file(".gitignore", ".env*.local", "# .env*.local")
  gsub_file(".gitignore", "config/initializers/secret_token.rb", "# config/initializers/secret_token.rb")
  gsub_file(".gitignore", "config/master.key", "# config/master.key")

  #     Tailwind
  ###############################################################

  say
  say "
===============================================================================
Add Tailwind 🎨
===============================================================================", :yellow
  say

  rails_command "tailwindcss:install"
  run "mkdir app/assets/stylesheets/config/"
  run "mkdir app/assets/stylesheets/config/components"
  run "touch app/assets/stylesheets/config/_colors.scss"
  run "touch app/assets/stylesheets/config/_globals.scss"
  run "touch app/assets/stylesheets/config/components/_header.scss"

  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/_colors.scss > app/assets/stylesheets/config/_colors.scss"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/_globals.scss > app/assets/stylesheets/config/_globals.scss"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/components/_header.scss > app/assets/stylesheets/config/components/_header.scss"

  inject_into_file "app/assets/config/manifest.js" do
    <<~JS
      //= link application.tailwind.css
    JS
  end



  #     Devise
  ###############################################################

  say
  say "
===============================================================================
Add users with Devise ➕
===============================================================================", :yellow
  say
  say "Installing Devise...", :yellow
  say

  generate "devise:install"

  say
  say "Set ActionMailer url to localhost:3000 in development environment", :yellow
  say

  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
  env: 'development'

  say
  say "Generate User model", :yellow
  say

  generate :devise, "User", "first_name", "last_name"

  say
  say "Add migration for admin column in users table", :yellow
  say

  generate :migration, "add_admin_to_users", "admin:boolean"
  Dir.glob("db/migrate/*_add_admin_to_users.rb").each do |file|

    say
    say "Editing #{file} to change admin default value to false", :yellow
    say

    gsub_file(file, "add_column :users, :admin, :boolean", "add_column :users, :admin, :boolean, default: false")
  end

  #     rspec
  ###############################################################

  say
  say "
===============================================================================
Installing rspec... 🎯
===============================================================================", :yellow
  say

  generate "rspec:install"
  run "rm -rf test"
  run "mkdir spec/features"
  run "mkdir spec/requests"
  run "touch spec/routing_spec.rb"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/spec/routing_spec.rb > spec/routing_spec.rb"


  #     Rubocop
  ###############################################################

  say
  say "
===============================================================================
Configuring Rubocop 🤖
===============================================================================", :yellow
  say

  run "curl -L https://raw.githubusercontent.com/rubocop/rubocop/master/config/default.yml > .rubocop.yml"

  #     Database
  ###############################################################

  say
  say "
===============================================================================
Create database 🧙
===============================================================================", :yellow
  say

  rails_command "db:create"
  rails_command "db:migrate"

  #     Layouts
  ###############################################################

  say
  say "
===============================================================================
Add Layout 🛠️
===============================================================================", :yellow
  say

  run "mkdir app/views/shared/"
  run "touch app/views/shared/_navbar.html.erb"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/views/shared/_navbar.html.erb > app/views/shared/_navbar.html.erb"
  inject_into_file "app/views/layouts/application.html.erb", after: "<body>" do
    <<~HTML
      <%= render "shared/navbar" %>
    HTML
  end


  #     Git
  ###############################################################

  say
  say "
===============================================================================
Initialise Git and make first commit 🥳
===============================================================================", :yellow
  say

  run "rspec"
  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit with authentication template from https://github.com/isMattCoding/wmbt-templates'" }

  say "
  Thank you for using
  #######################################################################
  #                                                                     #
  #  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████████████▓▒░░▒▓███████▓▒░▒▓████████▓▒░ #
  #  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
  #  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
  #  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  ░▒▓█▓▒░     #
  #  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
  #  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░     #
  #   ░▒▓█████████████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  ░▒▓█▓▒░     #
  #                            Web Services                             #
  #                  Rails Template with authentication                 #
  #                        https://wmbt.services                        #
  #                                                                     #
  #######################################################################
  ", :green

  say
  say "
===============================================================================

Rails app with authentication successfully created! 🎉🍾

===============================================================================", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ rails server", :green
  say
  say "To run tests:"
  say "$ rspec", :green
end
