# README

I needed a way to keep track of `ActiveModel` changes during a transaction and launch a Sidekiq job if a value changes. Alas:

* `ActiveModel::Dirty.changes()` isn't available in `after_commit`
* `ActiveModel::Dirty.previous_changes()` is available but it only reports the most recent `save`

I needed a solution that allowed me to keep track of **all the changes** in a transaction -- even if the model was saved multiple times.

So I created this sample Rails app with an `ActiveSupport::Concern` called `TrackSavedChanges` where `saved_changes()` returns a single AR-style `changes()` hash to reflect the net effect of a sequence of saves from the first to the last.  Consider this code:

    after_commit: :after_commit_test

    test = Test.create(number: 1)
    test = Test.find(test.id) # to initialize a fresh object

    test.transaction do
      test.update(number: 1)
      test.update(title: "foo")
    end

    def :after_commit_test
      puts previous_changes.inspect
      puts saved_changes.inspect
    end

which results in:

    previous_changes: {"title"=>["1", "2"], "updated_at"=>[...]}
    saved_changes: {"title"=>["1", "2"], "number"=>[1, 2], "updated_at"=>[...]}


because `saved_changes` includes `number` which was omitted from `previous_changes`

You can see this problem by cloning this repo and running `Test.test` from inside the Rails console.  For a deeper understanding of the issues see:

* The module code in [track_saved_changes.rb](https://github.com/ccmcbeck/after-commit/blob/master/app/models/concerns/track_saved_changes.rb)
* Automated test in [test_spec.rb](https://github.com/ccmcbeck/after-commit/blob/master/spec/models/test_spec.rb)
