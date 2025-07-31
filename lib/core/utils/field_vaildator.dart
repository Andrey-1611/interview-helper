String? fieldValidator(String? value, String hintText) {
  value = value?.trim();
  hintText = hintText.toLowerCase().trim();
  if (value == null || value.isEmpty) {
    return 'Поле $hintText не может быть пустым!';
  }
  switch (hintText) {
    case 'почта':
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Неверный формат почты!';
      }
      return null;
    case 'имя':
      if (value.length < 3) {
        return 'Минимум 3 символа!';
      }
      return null;
    case 'пароль':
      if (value.length < 6) {
        return 'Минимум 6 символов';
      }
  }
  return null;
}
