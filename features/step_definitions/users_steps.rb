# @user = User.find_by(email: email)
# unless @user
#   visit '/signup'
#   fill_in 'First Name', with: 'John'
#   fill_in 'Last Name', with: 'Doe'
#   fill_in 'Email', with: email
#   fill_in 'Password', with: password
#   fill_in 'Confirm Password', with: password
#   click_button 'Signup'
# end
