class Word < ActiveRecord::Base
  belongs_to :category
  has_many :choices, dependent: :destroy

  accepts_nested_attributes_for :choices,
    reject_if: proc {|attributes| attributes["content"].blank?},
    allow_destroy: true

  validates :category_id, presence: true
  validates :content, presence: true, length: {maximum: 80}
  validates_associated :choices

  OPTION = {learned: :learned, not_learned: :not_learned, all: :all}

  def self.import file
    if File.extname(file.original_filename)
      CSV.new(file.path)
      CSV.foreach(file.path, headers: true) do |row|
        Word.create! row.to_hash
      end
    else
      raise t "unknownfile"
    end
  end
end
