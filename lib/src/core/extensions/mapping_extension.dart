/// An extension on [Iterable] to provide additional mapping functionality.
extension ExIndexedMap<E> on Iterable<E> {
  /// Maps each element and its index to a new form using a given function [f].
  ///
  /// [f] is a function that takes the index of the element and the element
  /// itself as parameters and returns a new value of type [T].
  ///
  /// Returns an [Iterable] of [T] containing the results of applying [f] to
  /// each element and its index in the original [Iterable].
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}
