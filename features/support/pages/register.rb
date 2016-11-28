class RegisterPage < SitePrism::Page
  set_url "/users/sign_up"

  element :email, "input[name='user[email]']"
  element :password, "input[name='user[password]']"
  element :password_confirmation, "input[name='user[password_confirmation]']"
  element :register_button, "input[type='submit']"
end
