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
  gem "font-awesome-sass"
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
  run "touch app/views/shared/_footer.html.erb"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/views/shared/_navbar.html.erb > app/views/shared/_navbar.html.erb"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/views/shared/_footer.html.erb > app/views/shared/_footer.html.erb"
  gsub_file "app/views/layouts/application.html.erb", "<%= yield %>", <<-HTML

  <%= render "shared/navbar" %>
  <main id='main' class="flex justify-center">
  <%= yield %>
  </main>
  <%= render "shared/footer" %>
  HTML

    #     Dark mode
  ###############################################################

  say
  say "
===============================================================================
Setting up Dark mode 🌓
===============================================================================", :yellow
  say

  gsub_file "app/views/layouts/application.html.erb", "<html>", <<-HTML
    <html data-theme="<%= cookies[:theme] %>">
  HTML

  rails_command "generate stimulus theme"
  run "rm app/javascript/controllers/theme_controller.js && touch app/javascript/controllers/theme_controller.js"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/javascript/controllers/theme_controller.js > app/javascript/controllers/theme_controller.js"

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
  say "Generate custom Devise views", :yellow
  say

  generate "devise:views", "User"

  def replace_view(view_type)
    run "rm app/views/users/#{view_type}.html.erb && touch app/views/users/#{view_type}.html.erb"
    run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/views/users/#{view_type}.html.erb > app/views/users/#{view_type}.html.erb"
  end
  view_types = %w(confirmations/new passwords/edit passwords/new registrations/new registrations/edit sessions/new shared/_links)
  view_types.each do |view_type|
    replace_view(view_type)
  end

  say
  say "Generate User model", :yellow
  say

  generate :devise, "User", "first_name", "last_name"

  say
  say "Change config to allow custom Devise views", :yellow
  say

  gsub_file("config/initializers/devise.rb", "# config.scoped_views = false", "config.scoped_views = true")

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
  run "touch app/assets/stylesheets/config/components/_footer.scss"

  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/_colors.scss > app/assets/stylesheets/config/_colors.scss"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/_globals.scss > app/assets/stylesheets/config/_globals.scss"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/components/_header.scss > app/assets/stylesheets/config/components/_header.scss"
  run "curl -L https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/stylesheets/config/components/_footer.scss > app/assets/stylesheets/config/components/_footer.scss"

  inject_into_file "app/assets/config/manifest.js" do
    <<~JS
      //= link application.tailwind.css
    JS
  end
    create_file "app/views/layouts/devise.html.erb", IO.read("app/views/layouts/application.html.erb")
    gsub_file(
    "app/views/layouts/devise.html.erb",
    "<%= yield %>",
    <<-HTML

    <div class="container flex justify-center">
        <div class="bg-[var(--elevation-low-transparent)] rounded border-solid border-[1px] border-[var(--primary-border)] px-3 py-4 md:px-12 md:py-20 min-w-[20rem] w-2/5">
          <%= yield %>
        </div>
      </div>
    HTML
  )
  gsub_file(
    "app/controllers/application_controller.rb",
    "class ApplicationController < ActionController::Base
end
",
    <<-RUBY
    class ApplicationController < ActionController::Base
      layout :layout_by_resource
      before_action :set_theme

      private

      def layout_by_resource
        if devise_controller?
          "devise"
        else
          "application"
        end
      end

      def set_theme
        cookies[:theme] ||= 'dark'
        cookies[:theme] = params[:theme] if params[:theme].in? ['dark', 'light']
      end
    end
    RUBY
  )
  rails_command "tailwindcss:build"

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
