///
/// Utility class for working with hashes in Echo.
///
class EchoHashUtil {
  ///
  /// Generates a unique hash code for the given type [T].
  ///
  /// The hash code is obtained directly from the string representation of the
  /// type [T]. This approach ensures that each type is associated with a
  /// distinct hash code, leveraging Dart's built-in string hashing functionality.
  ///
  /// This method is highly efficient and straightforward, making it ideal for
  /// situations where a quick and unique identifier for a type is needed.
  ///
  /// Example:
  /// ```
  /// int hashForMyClass = EchoHashUtil.generateTypeHash<MyClass>();
  ///
  /// print(hashForMyClass); // Outputs a unique integer hash code for MyClass.
  /// ```
  ///
  static int generateTypeHash<T>() {
    // Generate the hash code from the type's string representation.
    return T.toString().hashCode;
  }
}
