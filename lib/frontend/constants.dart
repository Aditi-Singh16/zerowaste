class AppConstants {
  static List<String> coupons = ['OFF05', 'OFF10', 'OFF15', 'OFF20', 'OFF2'];
  static Map<String, int> couponValue = {
    'OFF05': 5,
    'OFF10': 10,
    'OFF15': 15,
    'OFF20': 20,
    'OFF2': 2
  };
  static Map<String, String> couponDescription = {
    'OFF05': 'Get 5% off on next purchase',
    'OFF10': 'Get 10% off on next purchase',
    'OFF15': 'Get 15% off on next purchase',
    'OFF20': 'Get 20% off on next purchase',
    'OFF2': 'Get 2% off on next purchase'
  };

  static Map<String, List<int>> esv_ls = {
    "Books": [2, 1, 3],
    "Cotton Clothes": [2, 1, 4],
    "Recycled Products": [1, 2, 3],
    "Electronics": [2, 1, 2],
    "Nylon Clothes": [1, 1, 1],
    "Silk Clothes": [1, 1, 1],
  };
}
