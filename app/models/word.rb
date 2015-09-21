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

  def self.import(file)
    byebug
    spreadsheet = open_spreadsheet(file)
    byebug
    header = spreadsheet.row(1)
    byebug
    (2..spreadsheet.last_row).each do |i|
      byebug
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_id(row["id"]) || new
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
      end
  end

  def self.open_spreadsheet(file)
    byebug
    if File.extname(file.original_filename)
      CSV.new file.path
    else
      nil
    end
    # case File.extname(file.original_filename)
    # when ".csv" then CSV.new(file.path)
    # else raise "Unknown file type: #{file.original_filename}"
    # end
  end
end
