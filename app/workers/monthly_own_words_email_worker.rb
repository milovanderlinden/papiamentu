class MonthlyOwnWordsEmailWorker
  include Sidekiq::Worker
  def perform
    # email votes casted for your own words since last week
    User.active.own_words_monthly.each do |user|
      words = user.words.select{|word| word.votes.where("'#{1.month.ago.to_date.to_s(:db)}' < created_at").length > 0}
      WordMailer.monthly_own_words_email(user, words).deliver unless words.empty?
    end
  end
end
