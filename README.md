# WMBT Templates
_by [WMBT Web Services](https://wmbt.services)_

Welcome to the WMBT Web Services Rails Template! This template is designed to kickstart a Rails application with built-in authentication, using a combination of Devise for user management and Tailwind CSS for styling. This template also includes configuration for RSpec testing and RuboCop for code linting, making it an excellent starting point for your next Rails project.

## Features
* __Authentication with Devise__: User registration, login, and management.
* __Tailwind CSS__: Pre-configured to use Tailwind for styling.
* __RSpec__: Set up for behavior-driven development testing.
* __RuboCop__: Configured for Ruby code linting.
* __PostgreSQL, MySQL, or SQLite3__: Choose your preferred database.


## Getting Started

To generate a new rails app, simply run the command:

```bash
  rails new RailsAppName \
  -d postgresql \
  -m https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/rails-with-authentication.rb
```

You can replace `RailsAppName` with your new app's name, and `postgresql` with your database of choice: `<postgresql, mysql, sqlite3>`.

Once the app has generated, you can navigate to your app folder and run the app locally:

```bash
  cd RailsAppName
  rails server
```

## Customization
### Devise Configuration
Devise is pre-installed for user authentication. To configure Devise further, refer to the Devise documentation.

### Tailwind CSS
Tailwind CSS is installed and ready to use. Customize your Tailwind configuration in config/tailwind.config.js.

### RSpec
RSpec is set up for testing. Add your tests in the spec directory. Refer to the RSpec documentation for more details.

### RuboCop
RuboCop is configured for code linting. Customize your linting rules in the .rubocop.yml file. Refer to the RuboCop documentation for more details.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.

## License
This project is licensed under the MIT License. See the [LICENSE](https://raw.githubusercontent.com/isMattCoding/wmbt-templates/main/LICENSE) file for details.

***

Thank you for using the WMBT Web Services Rails Template! If you have any questions or need further assistance, feel free to [reach out](https://wmbt.services/fr/contact). Happy coding!
