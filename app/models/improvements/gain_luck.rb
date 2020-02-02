module Improvements
  # This is for Improvements like Get back one used Luck point.
  class GainLuck < Improvement
    def apply(hunters_improvement)
      return false if add_errors(hunters_improvement)
      hunters_improvement.hunter.luck += 1
      hunters_improvement.hunter.save
    end

    def add_errors(hunters_improvement)
      super(hunters_improvement)
      if max_luck?(hunters_improvement.hunter)
        hunters_improvement.errors.add(:hunter, 'already has maximum for luck')
      end
    end

    def max_luck?(hunter)
      hunter.luck >= Hunter::MAX_LUCK
    end
  end
end
