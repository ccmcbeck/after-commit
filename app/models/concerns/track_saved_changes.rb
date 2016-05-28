module TrackSavedChanges
  extend ActiveSupport::Concern

  included do
    attr_reader :saved_changes_history
    after_initialize :reset_saved_changes
    after_save :track_saved_changes
  end

  # on initalize
  def reset_saved_changes
    @saved_changes_history = []
  end

  # state of saved changes since last init
  def saved_changes
    saved_changes = {}
    @saved_changes_history.each do |change|
      change.each_pair do |k, v|
        if saved_changes.key? k
          saved_changes[k][1] = begin
            v[1].dup
          rescue TypeError # http://stackoverflow.com/a/20955038
            v[1]
          end
        else
          saved_changes[k] = v.dup
        end
      end
    end
    saved_changes.reject { |k,v| v[0] == v[1] }
  end

  private

  # on save stash the changes hash
  def track_saved_changes
    @saved_changes_history << changes.dup
  end

end
