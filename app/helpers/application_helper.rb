# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def notebook_path(notebook)
    return "first_test/notebook/#{CGI.escape(notebook.name)}"
  end
  
  def user_path(user)
    return "user/#{CGI.escape(user.name)}"
  end
end
