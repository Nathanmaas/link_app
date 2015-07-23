module ApplicationHelper

  def format_creation_time item
    if item.created_at > Time.now.beginning_of_day
        "#{time_ago_in_words(item.created_at)} ago"
    else
        item.created_at.strftime("%e %b %Y %H:%M:%S%p")
    end
  end

end
