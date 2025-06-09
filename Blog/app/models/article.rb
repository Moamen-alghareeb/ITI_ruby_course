# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  title         :string
#  content       :text
#  user_id       :integer          not null
#  reports_count :integer
#  archived      :boolean
#  image         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#

class Article < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader

  before_save :check_reports

  private

  def check_reports
    self.archived = true if reports_count.to_i >= 3
  end
end
