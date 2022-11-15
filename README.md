# todo_app

Todo app

## ARCHITECTURE

- multi module application, the module is equal to a feature
    - login user authentication without password
    - todo view, edit single and list of todo delete the single todo.
- MVVM + clean architecture, each module (login and todo) has Data containing the network
  implemantation, di implementation of the dependency providers, domain models and repository that
  represent business domain, since I try to follow the clean architecture the implementation that
  has dependencies to the network layer should be locate in data\
  **How to check if the clean architecture is followed?** The clean architecture is like and onion
  the smallest level is domain, domain shouldn't have any dependencies to the other layers, that
  means every file into domain folder shouldn't has any import to other folders. Above the Domain we
  have Data, here we will have remote and local data sources + the repository impl, the repository
  is responsible to retrieve and manipulate data. Then ui have ui layer were we found widget
  implementations + view model, the view model will contain all the logics needed to communicate
  with repository or to display the data
- For the network communication I decided to use DIO + json deserializer
- I used shared preferences to store the name of the user
- for the localization I used intl
- used provider to manage the state and also for doing dependencies injection.
- I decided to abstract each data source + repository to make the code independent and testable.

## Notes

To simplify the scope of the app I decided to not implement page error, I'm managing the error
answering with default values.

For lack of time I decided to not implement ui tests, that should had done to do integration tests
