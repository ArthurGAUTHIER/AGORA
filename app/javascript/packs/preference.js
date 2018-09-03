function addPreferenceCategory(category) {
  PreferenceCategory.create(user_id: current_user, category_id: category);
}
