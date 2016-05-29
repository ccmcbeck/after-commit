class Test < ActiveRecord::Base
  include TrackSavedChanges

  after_save :test_after_save
  after_commit :test_after_commit

  # saved number should change
  def self.test
    # create with value of 1
    test = self.create number: 1, title: "1"
    # re-initialize based on found value / could also call test.reset_saved_changes
    test = self.find test.id
    # run a transaction
    test.transaction do
      test.log_history
      test.update number: 2
      test.log_history
      test.update title: "2"
      test.log_history
    end
    nil
  end

  def log_history
    saved_changes_history.each { |s| Rails.logger.debug "** history: #{s.inspect}" }
  end

  private

  def log_status(callee)
    Rails.logger.debug "** #{callee.upcase} **"
    Rails.logger.debug "** previous_changes? #{previous_changes.inspect} **"
    Rails.logger.debug "** saved_changes? #{saved_changes.inspect} **"
  end

  def test_after_save
    log_status __callee__
  end

  def test_after_commit
    log_status __callee__
  end
end
