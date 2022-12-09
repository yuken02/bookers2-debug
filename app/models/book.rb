class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  # has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #検索機能
  def self.find_out(method, keyword)
    if method == "perfect_matching"
      @book = Book.where("title LIKE?", "#{keyword}")
    elsif method == "prefix_match"
      @book = Book.where("title LIKE?", "#{keyword}%")
    elsif method == "backward_match"
      @book = Book.where("title LIKE?", "%#{keyword}")
    else
      @book = Book.where("title LIKE?", "%#{keyword}%")
    end
  end

  #日付期間指定
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  scope :created_2days_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3days_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4days_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5days_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6days_ago, -> { where(created_at: 6.day.ago.all_day) }
end
