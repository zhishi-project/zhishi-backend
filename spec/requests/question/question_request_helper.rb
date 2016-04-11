require "requests/shared/shared_authenticated_endpoint"

def path_helper(path, show=false)
  question = create(:question)
  if show
    send(path, question)
  else
    send(path)
  end
end
