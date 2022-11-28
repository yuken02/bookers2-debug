class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
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
end
