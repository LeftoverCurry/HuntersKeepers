# frozen_string_literal: true

# The character appearing in the mystery
class Hunter < ApplicationRecord
  belongs_to :playbook
  has_many :gears, through: :hunters_gears
  has_many :hunters_moves
  has_many :moves, through: :hunters_moves
  has_many :hunters_improvements
  validates_associated :hunters_improvements,
                       message: lambda { |_class_obj, obj|
                                  obj[:value]&.map { |h_improv| h_improv.errors.full_messages.to_sentence }&.join(', ')
                                }
  has_many :improvements, through: :hunters_improvements
  validates :harm, numericality: { less_than_or_equal_to: 7, greater_than_or_equal_to: 0 }
  validates :luck, numericality: { less_than_or_equal_to: 7, greater_than_or_equal_to: 0 }

  # List all improvements that are available
  # based on the hunter's playbook, and excludes
  # improvements the hunter has already taken
  #
  # @return [ActiveRecord::Collection]
  def available_improvements
    availables = playbook.improvements.where.not(id: improvements.select(:id))
    availables = availables.not_advanced unless hunters_improvements.count >= 5
    availables
  end

  # Add a negative or positive amount of experience
  # to the hunter.
  #
  # @param exp [Numeric] the amount of experience to give the player
  def gain_experience(exp)
    self.experience += exp
    save
  end

  # Check whether a move has been advanced by an improvement
  # for this hunter
  #
  # @param move [Move] the move to check
  def advanced?(move)
    hunters_moves.find_by(move: move).advanced
  end
end
