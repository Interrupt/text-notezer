module UserHelper
  def user_notebook_path(user, notebook)
    return "#{CGI.escape(user.name)}/#{CGI.escape(notebook.name)}"
  end
end
