abstract class LoginRepository{
  Future<String?> author();
  Future<bool> storeAuthor(String author);
}