module PostsHelper
  def total_hour(hour,minutes)
    total_hour = (hour+minutes/60).round(1)
    "#{total_hour}時間"
  end
end
