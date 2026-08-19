enum UserMapFilter {
  /// Hiển thị bãi động + bãi khảo sát.
  all,

  /// Chỉ bãi đang mở (active, status=open).
  activeOpen,

  /// Chỉ bãi khảo sát (chưa hoạt động).
  surveying,

  /// Chỉ bãi động còn chỗ trống.
  availableOnly,
}
