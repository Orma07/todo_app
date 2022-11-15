abstract class LoginLocalDatasource{
  Future<String?> author();
  Future<bool> storeAuthor(String author);
}