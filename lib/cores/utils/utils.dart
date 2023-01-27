class Utils {
  static String joineeId(String uId, String mId) =>
      uId.hashCode <= mId.hashCode ? '$uId$mId' : '$mId$uId';
}
